# About this Repo

[![Travis build status](https://api.travis-ci.org/biarms/mysql.svg?branch=master)](https://travis-ci.org/biarms/mysql)
[![CircleCI build status](https://circleci.com/gh/biarms/mysql.svg?style=svg)](https://circleci.com/gh/biarms/mysql)

## Overview
This is a fork of the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for
[Mysql](https://registry.hub.docker.com/_/mysql/). See [the Docker Hub page](https://registry.hub.docker.com/_/mysql/)
for the full readme on how to use this Docker image and for information regarding contributing and issues.

The goal of this fork was to build ARM (arm32v6, arm32v7, arm64v8) compliant images, as the official 'mysql' don't support 
such ARMS builds, which could be confirmed by running this command:
```
# docker run --rm mplatform/mquery mysql
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
$ docker pull biarms/mysql:5 # should get a working images on any arm device from v6 to v8
```

Caution: 
- like 'latest', the version 5 is a moving target: today, it gives 5.5.60 for armv6 and armv7 devices, but 5.7.30 for arm64v8 and x86_64 devices. Tomorrow, it could give 5.7.31 !
  Be sure to always run the 'docker pull biarms/mysql:5' to get the latest images.
- Also notes that you don't get the same minor version according to the arm device you are using !
    ```
    Image: biarms/mysql:5
     * Manifest List: Yes
     * Supported platforms:
       - linux/arm/v6  # => mysql version 5.5.60
       - linux/amd64   # => mysql version 5.7.30
       - linux/arm/v7  # => mysql version 5.7.30 designed for armv7 is not published because of docker 19.03 bug on 'rpi1', so you will get the 'armv6' version, which is 5.5.60. See https://github.com/biarms/mysql/issues/4 
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
  In other words, `docker run -it --rm biarms/mysql:5.7 --version` (or `docker run -it --rm biarms/mysql:5.7.30 --version`) will return 
    1. nothing on arm32v6 devices (so it will not work on armv6 devices like rpi zero or rpi one)
    2. '5.7.30' on arm32v7 devices (like Odroid, or rpi2, rpi3, rpi4 running a 32 bits OS)
    3. '5.7.30' on arm64v8 devices (like rpi2, rpi3, rpi4 running a 64 bits OS)
    4. '5.7.30' on x86_64 devices (like a MacOS, Linux or PC)

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
