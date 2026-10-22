#!/bin/sh
# Gives the Neuron repo credential from the neuron_repo build secret to apt, dnf, pip and curl
# for one RUN step. The RUN step mounts the secret (--mount=type=secret,id=neuron_repo), sources
# this file and calls neuron_repo_auth first. Everything it writes is removed when the step's
# shell exits, however the step ends, so the credential never reaches an image layer.
#
# With the secret, the repo setup step calls neuron_repo_park at its end. That moves the Neuron
# apt list, yum repo file and private pip extra index (none of them hold the credential) to
# /etc/neuron-repo, and neuron_repo_auth turns them on again for each step that needs them. So
# the image does not keep a private repo it cannot log in to, and a later apt-get update or pip
# install in the image or in an image built from it does not fail on it. The pip extra index is
# set to the public Neuron index instead of being removed, so `pip config unset
# global.extra-index-url` in an image built from this one keeps working.
#
# Without the secret these functions do nothing. Builds that pass the older NEURON_*_REPO_KEY
# build args, and builds against the public repos, work as before.
#
# The repo host names come from /etc/neuron-repo-hosts, which the repo setup step writes. That
# file holds no credential. NEURON_REPO_HOSTS_FILE can point at another file, for tests.

NEURON_REPO_PARK_DIR="${NEURON_REPO_PARK_DIR:-/etc/neuron-repo}"
NEURON_PUBLIC_PIP_INDEX=https://pip.repos.neuron.amazonaws.com

neuron_repo_auth() {
    _neuron_repo_secret="${NEURON_REPO_SECRET_FILE:-/run/secrets/neuron_repo}"
    [ -s "${_neuron_repo_secret}" ] || return 0

    _neuron_repo_cred="$(cat "${_neuron_repo_secret}")"
    case "${_neuron_repo_cred}" in
        ?*:?*) ;;
        *)
            echo "Error: the neuron_repo secret must be 'user:password'" >&2
            return 1
            ;;
    esac
    _neuron_repo_user="${_neuron_repo_cred%%:*}"
    _neuron_repo_pass="${_neuron_repo_cred#*:}"

    _neuron_repo_hosts="${NEURON_REPO_HOSTS_FILE:-/etc/neuron-repo-hosts}"
    if [ -r "${_neuron_repo_hosts}" ]; then
        . "${_neuron_repo_hosts}"
    fi

    NEURON_REPO_AUTH_DIR="$(mktemp -d)" || return 1
    trap _neuron_repo_auth_cleanup EXIT
    # One netrc file for curl, and for pip through NETRC.
    NEURON_REPO_NETRC="${NEURON_REPO_AUTH_DIR}/netrc"
    : > "${NEURON_REPO_NETRC}"
    chmod 600 "${NEURON_REPO_NETRC}"
    for _neuron_repo_host in ${NEURON_APT_REPO:-} ${NEURON_YUM_REPO:-} ${NEURON_PIP_REPO:-}; do
        printf 'machine %s login %s password %s\n' \
            "${_neuron_repo_host}" "${_neuron_repo_user}" "${_neuron_repo_pass}" >> "${NEURON_REPO_NETRC}"
    done
    export NEURON_REPO_NETRC
    export NETRC="${NEURON_REPO_NETRC}"

    if [ -n "${NEURON_APT_REPO:-}" ] && [ -d /etc/apt ]; then
        mkdir -p /etc/apt/auth.conf.d
        printf 'machine %s login %s password %s\n' \
            "${NEURON_APT_REPO}" "${_neuron_repo_user}" "${_neuron_repo_pass}" > /etc/apt/auth.conf.d/neuron-repo.conf
        chmod 600 /etc/apt/auth.conf.d/neuron-repo.conf
    fi

    # Turn on the repo config the setup step parked.
    if [ -f "${NEURON_REPO_PARK_DIR}/neuron.list" ]; then
        cp "${NEURON_REPO_PARK_DIR}/neuron.list" /etc/apt/sources.list.d/neuron.list
    fi
    if [ -f "${NEURON_REPO_PARK_DIR}/neuron.repo" ]; then
        cp "${NEURON_REPO_PARK_DIR}/neuron.repo" /etc/yum.repos.d/neuron.repo
        chmod 600 /etc/yum.repos.d/neuron.repo
        printf 'username=%s\npassword=%s\n' "${_neuron_repo_user}" "${_neuron_repo_pass}" >> /etc/yum.repos.d/neuron.repo
    fi
    # The environment variable takes precedence over the pip config files, for this step only.
    if [ -f "${NEURON_REPO_PARK_DIR}/pip-extra-index-url" ]; then
        PIP_EXTRA_INDEX_URL="$(cat "${NEURON_REPO_PARK_DIR}/pip-extra-index-url")"
        export PIP_EXTRA_INDEX_URL
    fi

    unset _neuron_repo_secret _neuron_repo_hosts _neuron_repo_cred _neuron_repo_user _neuron_repo_pass _neuron_repo_host
}

# Called at the end of the repo setup step. Does nothing unless neuron_repo_auth found the secret.
neuron_repo_park() {
    [ -n "${NEURON_REPO_AUTH_DIR:-}" ] || return 0
    mkdir -p "${NEURON_REPO_PARK_DIR}"
    if [ -f /etc/apt/sources.list.d/neuron.list ]; then
        mv /etc/apt/sources.list.d/neuron.list "${NEURON_REPO_PARK_DIR}/neuron.list"
    fi
    if [ -f /etc/yum.repos.d/neuron.repo ]; then
        mv /etc/yum.repos.d/neuron.repo "${NEURON_REPO_PARK_DIR}/neuron.repo"
    fi
    _neuron_repo_pip="${PIP:-pip3}"
    _neuron_repo_index="$(${_neuron_repo_pip} config get global.extra-index-url 2>/dev/null || true)"
    if [ -n "${_neuron_repo_index}" ] && [ "${_neuron_repo_index}" != "${NEURON_PUBLIC_PIP_INDEX}" ]; then
        printf '%s\n' "${_neuron_repo_index}" > "${NEURON_REPO_PARK_DIR}/pip-extra-index-url"
        ${_neuron_repo_pip} config set global.extra-index-url "${NEURON_PUBLIC_PIP_INDEX}" >/dev/null || return 1
    fi
    unset _neuron_repo_pip _neuron_repo_index
}

_neuron_repo_auth_cleanup() {
    rm -f /etc/apt/auth.conf.d/neuron-repo.conf
    # Only the copies made from the parked config are removed.
    if [ -f "${NEURON_REPO_PARK_DIR}/neuron.list" ]; then
        rm -f /etc/apt/sources.list.d/neuron.list
    fi
    if [ -f "${NEURON_REPO_PARK_DIR}/neuron.repo" ]; then
        rm -f /etc/yum.repos.d/neuron.repo
    fi
    if [ -n "${NEURON_REPO_AUTH_DIR:-}" ]; then
        rm -rf "${NEURON_REPO_AUTH_DIR}"
    fi
}
