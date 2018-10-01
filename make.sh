#!/bin/bash
set -eo pipefail
set -x

export DOCKER_IMAGE_VERSION=5.5.59
export ARCH=$(uname -i)

if [[ '$ARCH' == 'armv6' ]]; then
    export DOCKER_FILE='-f Dockerfile-arm32v6'
fi

make
