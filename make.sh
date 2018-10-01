#!/bin/bash
set -eo pipefail
set -x

export DOCKER_IMAGE_VERSION=5.5.59
export ARCH=$(arch)

if [[ '$ARCH' == 'armv6l' ]]; then
    export DOCKER_FILE='-f Dockerfile-arm32v6'
fi

make
