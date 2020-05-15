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
Image: biarms/mysql:5.5
 * Manifest List: Yes
 * Supported platforms:
   - linux/arm/v6
   - linux/amd64
   - linux/arm/v7
   - linux/arm64
```

Notices that these images are build on top of official docker images (resin/raspbian for armv6 and ubuntu for armv7 and arm64), and (try to) offer the same 'docker-entry-point' functionality as the official images (including the MYSQL_ROOT_PASSWORD_FILE useful for docker swarm).

As these docker images were created to mimic as much as possible the official mysql build, the official 'mysql' readme (available at [docker-library/docs](https://github.com/docker-library/docs) and specifically in [docker-library/docs/mysql](https://github.com/docker-library/docs/tree/master/mysql)) should be fully applicable.

To pull this image from [docker hub/docker cloud](https://hub.docker.com/r/biarms/mysql/):
```
$ docker pull biarms/mysql:5 # should get the correct arm images on any arm device
```

Caution: 
- like 'latest', the version 5 is a moving target: today, it gives 5.5.60 for armv6 devices, but 5.7.30 for other devices. Tomorrow, it could give 5.7.31.
Be sure to always run the 'docker pull biarms/mysql:5' to get the latest images.
```
Image: biarms/mysql:5
 * Manifest List: Yes
 * Supported platforms:
   - linux/arm/v6  # => mysql version 5.5.60
   - linux/amd64   # => mysql version 5.7.30
   - linux/arm/v7  # => mysql version 5.7.30
   - linux/arm64   # => mysql version 5.7.30
```
- be aware no arm32v6 image is build for the release 5.7 ! In other words, `docker run --rm mplatform/mquery biarms/mysql:5.7.30` (as well as `docker run --rm mplatform/mquery biarms/mysql:5.7`) will return something similar to:
``` 
Image: biarms/mysql:5.7.30
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v7
   - linux/arm64
```

## Tests of these images on different ARM boxes:

### My (very very) simple test suite:
```
uname -a
cat /etc/os-release
docker run --rm -it biarms/mysql:5 uname -a
docker run --rm -it biarms/mysql:5 --version
docker run --rm -it biarms/mysql:5.5 --version
docker run --rm -it biarms/mysql:5.7 --version
docker run --rm -it biarms/mysql:5.7.30 --version
```
### Tests results with an Odroid XU4 (a pure armv7l device):
```
TODO
```

### Tests with an Raspberry PI 1 (a pure armv6 device):
```
TODO
```

### Tests with an Raspberry PI 3 (running an ubuntu aarch64 OS):
```
TODO
```

### Tests with an Rock 64 board (on an ubuntu aarch64 OS):
```
TODO
```

## Misc references:
1. https://dariancabot.com/2017/04/26/raspberry-pi-installing-mysql-5-7-on-jessie/
1. http://ftp.debian.org/debian/pool/main/m/mysql-5.7/