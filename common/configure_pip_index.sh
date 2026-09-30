#!/bin/sh

configure_pip_index() {
    secret_file="${PIP_INDEX_URL_SECRET_FILE:-/run/secrets/pip_index_url}"

    if [ -r "${secret_file}" ]; then
        private_index_url=$(cat "${secret_file}")
        case "${private_index_url}" in
            https://*) ;;
            *)
                echo "Error: private pip index secret must contain an HTTPS URL" >&2
                return 1
                ;;
        esac

        export PIP_CONFIG_FILE=/dev/null
        export PIP_INDEX_URL="${private_index_url}"
        unset PIP_EXTRA_INDEX_URL
        echo "Using the configured private pip index"
        return 0
    fi

    if [ "${REQUIRE_PIP_INDEX_SECRET:-false}" = "true" ]; then
        echo "Error: required private pip index secret is unavailable" >&2
        return 1
    fi
}
