#!/bin/bash
set -e

DOCKER_IMAGE_VERSION=5.5 make
DOCKER_IMAGE_VERSION=5.7 make
