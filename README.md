# About this Repo

## Overview
This is a fork of the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for
[mysql](https://registry.hub.docker.com/_/mysql/). See [the Docker Hub page](https://registry.hub.docker.com/_/mysql/)
for the full readme on how to use this Docker image and for information regarding contributing and issues.

The goal of this fork was just to build an ARM (arm32v7) compliant image, as the official 'mysql' don't currently contain such
ARM build (at least, not in January 2018), which could be confirmed by running this command:
```
# docker run --rm mplatform/mquery mysql
Image: mysql
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64

# docker run --rm mplatform/mquery biarms/mysql
Image: biarms/mysql
 * Manifest List: No
 * Supports: arm/linux
```

Therefore, this image should be able to run on Raspberry Pi (2 and 3), Odroid, Orange PI, etc, but not on a Raspberry Pi 1.

The official 'mysql' readme (generated in [docker-library/docs](https://github.com/docker-library/docs),
specifically in [docker-library/docs/mysql](https://github.com/docker-library/docs/tree/master/mysql)) should be
fully applicable to this docker image, as this docker image was created to mimic as much as possible the official mysql build.

To pull this image from [docker hub/docker cloud](https://hub.docker.com/r/biarms/mysql/):
```
# docker pull biarms/mysql
```

## Test of this image on different ARM boxes:

### My (very very) simple test suite:
```
cat /etc/os-release
docker run --rm -it biarms/mysql uname -a
docker run --rm -it biarms/mysql --version
```

### Tests results with an Odroid XU4 (on a armv7l OS):
```
$ cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.3 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
$ docker run --rm -it biarms/mysql uname -a
Linux 97f1d0baf38e 4.9.27-35 #1 SMP PREEMPT Tue May 9 22:16:51 UTC 2017 armv7l armv7l armv7l GNU/Linux
$ docker run --rm -it biarms/mysql --version
mysqld  Ver 5.7.21-0ubuntu0.16.04.1 for Linux on armv7l ((Ubuntu))
```

### Tests with an Raspberry PI 3 (on a armv7l OS):
```
$ cat /etc/os-release
PRETTY_NAME="Raspbian GNU/Linux 8 (jessie)"
NAME="Raspbian GNU/Linux"
VERSION_ID="8"
VERSION="8 (jessie)"
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"
$ docker run --rm -it biarms/mysql uname -a
docker run --rm -it biarms/mysql --versionLinux 63c4d9485416 4.9.77-v7+ #1081 SMP Wed Jan 17 16:15:20 GMT 2018 armv7l armv7l armv7l GNU/Linux
$ docker run --rm -it biarms/mysql --version
mysqld  Ver 5.7.21-0ubuntu0.16.04.1 for Linux on armv7l ((Ubuntu))
```

### Tests with an Orange PI (on a aarch64 OS):
```
# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.3 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
# docker run --rm -it biarms/mysql uname -a
Linux 363729d43c0a 3.10.102 #115 SMP PREEMPT Sat Dec 3 09:19:19 CST 2016 aarch64 aarch64 aarch64 GNU/Linux
# docker run --rm -it biarms/mysql --version
mysqld  Ver 5.7.21-0ubuntu0.16.04.1 for Linux on armv7l ((Ubuntu))
```
