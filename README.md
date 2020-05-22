# The biarms/mysql project

![GitHub release (latest by date)](https://img.shields.io/github/v/release/biarms/mysql?label=Latest%20Github%20release&logo=Github)
![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/biarms/mysql?include_prereleases&label=Highest%20GitHub%20release&logo=Github&sort=semver)

[![TravisCI build status image](https://img.shields.io/travis/biarms/mysql/master?label=Travis%20build&logo=Travis)](https://travis-ci.org/biarms/mysql)
[![CircleCI build status image](https://img.shields.io/circleci/build/gh/biarms/mysql/master?label=CircleCI%20build&logo=CircleCI)](https://circleci.com/gh/biarms/mysql)

[![Docker Pulls image](https://img.shields.io/docker/pulls/biarms/mysql?logo=Docker)](https://hub.docker.com/r/biarms/mysql)
[![Docker Stars image](https://img.shields.io/docker/stars/biarms/mysql?logo=Docker)](https://hub.docker.com/r/biarms/mysql)
[![Highest Docker release](https://img.shields.io/docker/v/biarms/mysql?label=docker%20release&logo=Docker&sort=semver)](https://hub.docker.com/r/biarms/mysql)

<!--
![TravisCI build status image](https://travis-ci.org/biarms/mysql.svg?branch=master) 
-->

## Overview
This is a fork of the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for
[Mysql](https://registry.hub.docker.com/_/mysql/). See [the Docker Hub page](https://registry.hub.docker.com/_/mysql/)
for the full readme on how to use this Docker image and for information regarding contributing and issues.

The goal of this fork was to build ARM (arm32v6, arm32v7, arm64v8) compliant images, as the official 'mysql' don't support 
such ARMS builds, which could be confirmed by running this command:
```
# `docker run --rm mplatform/mquery mysql`, which is an older (and lighter !) alternative to `DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect mysql
Image: mysql
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
```
While
```
# docker run --rm mplatform/mquery biarms/mysql:5
Image: biarms/mysql:5
 * Manifest List: Yes
 * Supported platforms:
   - linux/arm/v6
   - linux/amd64
   - linux/arm64
```

Notices that these images are build on top of official docker images (resin/raspbian for armv6 and ubuntu for armv7 and arm64), and (try to) offer the same 'docker-entry-point' functionality as the official images (including the MYSQL_ROOT_PASSWORD_FILE useful for docker swarm).

As these docker images were created to mimic as much as possible the official mysql build, the official 'mysql' readme (available at [docker-library/docs](https://github.com/docker-library/docs) and specifically in [docker-library/docs/mysql](https://github.com/docker-library/docs/tree/master/mysql)) should be fully applicable.

To pull this image from [docker hub/docker cloud](https://hub.docker.com/r/biarms/mysql/):
```
$ docker pull biarms/mysql:5 # should get a working images on any arm device from v6 to v8, but also on x86_64 server  
```

Caution: 
- Like 'latest', the version 5 is a moving target: today, it gives 5.5.60 for armv6 and armv7 devices, but 5.7.30 for arm64v8 and x86_64 devices. Tomorrow, it could give 5.7.31 !
  Be sure to always run the 'docker pull biarms/mysql:5' to get the latest images.
- Also notes that you don't get the same version according to the arm device you are using !
    ```
    Image: biarms/mysql:5
     * Supported platforms:
       - linux/arm/v6  # => mysql version 5.5.60
       - linux/amd64   # => mysql version 5.7.30
       - linux/arm64   # => mysql version 5.7.30
    ```
  In other words, `docker run -it --rm biarms/mysql:5 --version` will return:
    1. '5.5.60' on arm32v6 devices
    2. '5.5.60' on arm32v7 devices (because of our workaround about https://github.com/biarms/mysql/issues/4 issue)
    3. '5.7.30' on arm64v8 devices
    4. '5.7.30' on x86_64 devices
- Be aware no arm32v6 image is build for the 5.7 and 5.7.30 releases ! In other words, `docker run --rm mplatform/mquery biarms/mysql:5.7.30` (as well as `docker run --rm mplatform/mquery biarms/mysql:5.7`) will return something similar to:
    ``` 
    Image: biarms/mysql:5.7.30
     * Manifest List: Yes
     * Supported platforms:
       - linux/amd64    # => mysql version 5.7.30
       - linux/arm/v7   # => mysql version 5.7.30
       - linux/arm64    # => mysql version 5.7.30
    ```
  Which means that `docker run -it --rm biarms/mysql:5.7 --version` (or `docker run -it --rm biarms/mysql:5.7.30 --version`) will return: 
    1. an error on arm32v6 devices (so it will not work on armv6 devices like rpi zero or rpi one)
    2. '5.7.30' on arm32v7 devices (like Odroid, or rpi2, rpi3, rpi4 running a 32 bits OS)
    3. '5.7.30' on arm64v8 devices (like rpi2, rpi3, rpi4 running a 64 bits OS)
    4. '5.7.30' on x86_64 devices (like a MacOS, Linux or PC)
- However, as soon as you stay with 5.5, you should get something working on any device
    ``` 
       - linux/amd64    # => mysql version 5.5.62
       - linux/arm/v6   # => mysql version 5.5.60
       - linux/arm/v7   # => mysql version 5.5.60 (even if we have a better 5.5.62 image !)
       - linux/arm64    # => mysql version 5.5.62
    ```
- With 5.5.62, you should get always the same version, but this is NOK for armv6 :(
    ``` 
    Image: biarms/mysql:5.5.62
     * Manifest List: Yes
     * Supported platforms:
       - linux/amd64    # => mysql version 5.5.62
       - linux/arm/v7   # => mysql version 5.5.62
       - linux/arm64    # => mysql version 5.5.62
    ```

## Detailed image information: 

### Versions summary:

|                                                 | *arm32v6* | *arm32v7*  | *arm64v8* | *amd64*  |
|-------------------------------------------------|-----------|------------|-----------|----------|
| `docker run --rm biarms/mysql --version`        |  5.5.60   | 5.5.60 (1) |  5.7.30   |  5.7.30  |
| `docker run --rm biarms/mysql:5 --version`      |  5.5.60   | 5.5.60 (1) |  5.7.30   |  5.7.30  |
| `docker run --rm biarms/mysql:5.5 --version`    |  5.5.60   | 5.5.60 (2) |  5.5.62   |  5.5.62  |
| `docker run --rm biarms/mysql:5.5.62 --version` |   NOK     | 5.5.62     |  5.5.62   |  5.5.62  |
| `docker run --rm biarms/mysql:5.7 --version`    |   NOK     | 5.7.30     |  5.7.30   |  5.7.30  |
| `docker run --rm biarms/mysql:5.7.30 --version` |   NOK     | 5.7.30     |  5.7.30   |  5.7.30  |

- (1) Should be 5.7.30 (build for arm32v7), but is 5.5.60 (build of arm32v6) because of 'docker pull' issue. See https://github.com/biarms/mysql/issues/4 for more details.
- (2) Should be 5.5.62 (build for arm32v7), but is 5.5.60 (build of arm32v6) because of 'docker pull' issue. See https://github.com/biarms/mysql/issues/4 for more details.

### Architecture

|                                                                 | *arm32v6* | *arm32v7* | *arm64v8* | *amd64* |
|-----------------------------------------------------------------|-----------|-----------|-----------|---------|
| `docker run --rm biarms/mysql dpkg --print-architecture`        |   armhf   |   armhf   |   arm64   |  amd64  |
| `docker run --rm biarms/mysql:5 dpkg --print-architecture`      |   armhf   |   armhf   |   arm64   |  amd64  |
| `docker run --rm biarms/mysql:5.5 dpkg --print-architecture`    |   armhf   |   armhf   |   arm64   |  amd64  |
| `docker run --rm biarms/mysql:5.5.62 dpkg --print-architecture` |   armhf   |   armhf   |   arm64   |  amd64  |
| `docker run --rm biarms/mysql:5.7 dpkg --print-architecture`    |   armhf   |   armhf   |   arm64   |  amd64  |
| `docker run --rm biarms/mysql:5.7.30 dpkg --print-architecture` |   armhf   |   armhf   |   arm64   |  amd64  |

### Base OS

|                                                                  | *arm32v6*    |    *arm32v7*     |   *arm64v8*    |    *amd64*     |
|------------------------------------------------------------------|--------------|------------------|----------------|----------------|
| `docker run --rm biarms/mysql sh -c 'cat /etc/*release'`         | debian 7 (a) | debian 7 (a) (1) | Ubuntu 18.04.4 | Ubuntu 18.04.4 |
| `docker run --rm biarms/mysql:5 sh -c 'cat /etc/*release'`       | debian 7 (a) | debian 7 (a) (1) | Ubuntu 18.04.4 | Ubuntu 18.04.4 |
| `docker run --rm biarms/mysql:5.5 sh -c 'cat /etc/*release'`     | debian 7 (a) | debian 7 (a) (2) | Ubuntu 14.04.6 | Ubuntu 14.04.6 |
| `docker run --rm biarms/mysql:5.5.62 sh -c 'cat /etc/*release'`  |     NOK      |  Ubuntu 14.04.6  | Ubuntu 14.04.6 | Ubuntu 14.04.6 |
| `docker run --rm biarms/mysql:5.7 sh -c 'cat /etc/*release'`     |     NOK      |  Ubuntu 18.04.4  | Ubuntu 18.04.4 | Ubuntu 18.04.4 |
| `docker run --rm biarms/mysql:5.7.30 sh -c 'cat /etc/*release'`  |     NOK      |  Ubuntu 18.04.4  | Ubuntu 18.04.4 | Ubuntu 18.04.4 |

- (a) Exact OS is `Raspbian 7 (wheezy)`, which is a 'debian 7 like' OS (base image is 'resin/rpi-raspbian')
- (1) Should be `Ubuntu 18.04.4` (build for arm32v7), but is a debian-7 like arm32v6 compatible OS because of 'docker pull' issue. See https://github.com/biarms/mysql/issues/4 for more details.
- (1) Should be `Ubuntu 14.04.6` (build for arm32v7), but is a debian-7 like arm32v6 compatible OS because of 'docker pull' issue. See https://github.com/biarms/mysql/issues/4 for more details.

### How to get real arm32v7 images on arm32v7 devices ?
By downloading them directly, without using the docker manifest. For instance:
```
docker run -it --rm biarms/mysql:5.5.62-linux-arm32v7 --version
```

## How to build locally:

Thanks to CircleCi client: 
```
circleci local execute -e DOCKER_USERNAME=******** -e DOCKER_PASSWORD=********
```
or
```
DOCKER_USERNAME=******** DOCKER_PASSWORD=******** make circleci-local-build
```

## Misc references:
1. https://dariancabot.com/2017/04/26/raspberry-pi-installing-mysql-5-7-on-jessie/
1. http://ftp.debian.org/debian/pool/main/m/mysql-5.7/
