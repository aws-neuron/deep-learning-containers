#!/bin/sh

# Check if required environment variables are set
if [ -z "${NEURON_ARTIFACT_PATH}" ]; then
    echo "Error: NEURON_ARTIFACT_PATH environment variable is not set"
    exit 1
fi

if [ -z "${IGNORE_MISSING_NEURON_COMPONENTS}" ]; then
    echo "Error: IGNORE_MISSING_NEURON_COMPONENTS environment variable is not set"
    exit 1
fi

if [ -z "${PIP}" ]; then
    echo "Warning: PIP not set, defaulting to pip3"
    PIP="pip3"
fi

# Print debug info
echo "Using: NEURON_ARTIFACT_PATH=${NEURON_ARTIFACT_PATH}"
echo "Using: IGNORE_MISSING_NEURON_COMPONENTS=${IGNORE_MISSING_NEURON_COMPONENTS}"
echo "Using: PIP=${PIP}"

packages=""
flags=""
while [ "$#" -gt 0 ]; do
    # Parse input using read
    IFS=: read -r pkg_name version_arg extra_flags <<EOF
$1
EOF

    # Handle the case where version exists in NEURON_ARTIFACT_PATH
    if [ -n "${version_arg}" ] && [ -f "${NEURON_ARTIFACT_PATH}/pip/${version_arg}" ]; then
        packages="${packages} ${NEURON_ARTIFACT_PATH}/pip/${version_arg}"
    else
        if [ "${IGNORE_MISSING_NEURON_COMPONENTS}" = "false" ]; then
            # If version is empty, just add the package name
            if [ -z "${version_arg}" ]; then
                packages="${packages} ${pkg_name}"
            else
                packages="${packages} ${pkg_name}==${version_arg}"
            fi
        else
            echo "Ignoring package ${pkg_name}"
        fi
    fi
    
    # Store unique flags (only if extra_flags is not empty)
    if [ -n "${extra_flags}" ]; then
        for flag in $(echo "${extra_flags}" | tr ' ' '\n'); do
            case " ${flags} " in
                *" ${flag} "*) ;; 
                *) flags="${flags} ${flag}" ;;
            esac
        done
    fi
    shift
done

if [ ! -z "${packages}" ]; then
    echo "Installing packages: ${packages} with flags ${flags}"
    ${PIP} install --no-cache-dir --force-reinstall \
        --extra-index-url="file:///${NEURON_ARTIFACT_PATH}/pip" \
        ${packages} ${flags}
fi
