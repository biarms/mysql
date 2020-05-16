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
### Test results with a Odroid XU4 (a pure armv7l device):
```
$ uname -a
Linux odroid 5.4.0-odroid-armmp #1 SMP PREEMPT Ubuntu 5.4.33-202004230334~focal (2020-04-22) armv7l armv7l armv7l GNU/Linux

$ cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal

$ docker run --rm -it biarms/mysql:5 uname -a
Linux 21206c44333b 5.4.0-odroid-armmp #1 SMP PREEMPT Ubuntu 5.4.33-202004230334~focal (2020-04-22) armv7l armv7l armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on armv7l ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.5 --version
200515 22:00:03 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.61-0ubuntu0.14.04.1 for debian-linux-gnu on armv7l ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.7 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on armv7l ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.7.30 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on armv7l ((Ubuntu))
```

### Tests with a Raspberry PI 3 (running an ubuntu aarch64 OS):
```
$ uname -a
Linux blue 5.4.0-1008-raspi #8-Ubuntu SMP Wed Apr 8 11:13:06 UTC 2020 aarch64 aarch64 aarch64 GNU/Linux

$ cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux 07f3959ade48 5.4.0-1008-raspi #8-Ubuntu SMP Wed Apr 8 11:13:06 UTC 2020 aarch64 aarch64 aarch64 GNU/Linux

$ docker run --rm -it biarms/mysql:5 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on aarch64 ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.5 --version
200515 22:21:20 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.61-0ubuntu0.14.04.1 for debian-linux-gnu on aarch64 ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.7 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on aarch64 ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.7.30 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on aarch64 ((Ubuntu))
```

### Tests on a x86_64 device:
```
$ uname -m
x86_64

$ docker run --rm -it biarms/mysql:5 uname -m
x86_64

$ docker run --rm -it biarms/mysql:5 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on x86_64 ((Ubuntu))

$ docker run --rm -it biarms/mysql:5 bash -c 'cat /etc/*release' | grep 'VERSION='
VERSION="18.04.4 LTS (Bionic Beaver)"

$ docker run --rm -it biarms/mysql:5.5 --version
Unable to find image 'biarms/mysql:5.5' locally
5.5: Pulling from biarms/mysql
docker: no matching manifest for linux/amd64 in the manifest list entries.
See 'docker run --help'.

$ docker run --rm -it biarms/mysql:5.7 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on x86_64 ((Ubuntu))

$ docker run --rm -it biarms/mysql:5.7.30 --version
mysqld  Ver 5.7.30-0ubuntu0.18.04.1 for Linux on x86_64 ((Ubuntu))
```

## Misc references:
1. https://dariancabot.com/2017/04/26/raspberry-pi-installing-mysql-5-7-on-jessie/
1. http://ftp.debian.org/debian/pool/main/m/mysql-5.7/