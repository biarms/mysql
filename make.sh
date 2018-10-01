#!/bin/bash
set -e

export ARCH=$(uname -i)
export DOCKER_IMAGE_VERSION=5.5.59
make
