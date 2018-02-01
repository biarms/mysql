# About this Repo

## Overview
This is a fork of the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for
[mysql](https://registry.hub.docker.com/_/mysql/). See [the Docker Hub page](https://registry.hub.docker.com/_/mysql/)
for the full readme on how to use this Docker image and for information regarding contributing and issues.

The goal of this fork was to build an ARM (arm32v6 and arm32v7) compliant images, as the official 'mysql' don't (currently) support such
ARM builds (at least, not in January 2018), which could be confirmed by running this command:
```
# docker run --rm mplatform/mquery mysql
Image: mysql
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
```
While
```
# docker run --rm mplatform/mquery biarms/mysql:5.7
Image: biarms/mysql:5.7
 * Manifest List: No
 * Supports: arm/linux
```

Notices that these images are build on top of official docker images (debian for mysql-server 5.5 and ubuntu for mysql-server 5.7), and offer the same 'docker-entry-point' functionality as the official images (including the MYSQL_ROOT_PASSWORD_FILE usefull for docker swarm). By the way, the docker-entry-point.sh file embedded in this image is directly downloaded from the official mysql docker repository. 

Conclusions: 
- The 5.7 image was designed to be compliant with arm32v7, and therefore, should be able to run on Raspberry Pi (2 and 3), Odroid, Orange PI, etc. But NOT with a Raspberry Pi 1.
- However, the 5.5 image was designed to be compliant with arm32v6, and therefore, should be able to run on any ARM devices, including Raspberry Pi 1 and Raspberry pi Zero.

As these docker images were created to mimic as much as possible the official mysql build, the official 'mysql' readme (generated in [docker-library/docs](https://github.com/docker-library/docs) and specifically in [docker-library/docs/mysql](https://github.com/docker-library/docs/tree/master/mysql)) should be fully applicable.

To pull this image from [docker hub/docker cloud](https://hub.docker.com/r/biarms/mysql/):
```
$ docker pull biarms/mysql:5.5 # for arm32v6 OS, like RPI0 or RPI1
$ docker pull biarms/mysql:5.7 # for arm32v7 OS, like RPI2, RPI3, ODROID-XU4, Orange Pi, etc.
```

## Test of this image on different ARM boxes:

### My (very very) simple test suite:
```
cat /etc/os-release
docker run --rm -it biarms/mysql:5.5 uname -a
docker run --rm -it biarms/mysql:5.5 --version
docker run --rm -it biarms/mysql:5.7 uname -a
docker run --rm -it biarms/mysql:5.7 --version
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

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux aed8004324bd 4.9.27-35 #1 SMP PREEMPT Tue May 9 22:16:51 UTC 2017 armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
180201  0:48:12 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.59-0+deb8u1 for debian-linux-gnu on armv7l ((Debian))

$ docker run --rm -it biarms/mysql:5.7 uname -a
Linux a6109d57acce 4.9.27-35 #1 SMP PREEMPT Tue May 9 22:16:51 UTC 2017 armv7l armv7l armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5.7 --version
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

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux 5a41fab6f9e2 4.9.77-v7+ #1081 SMP Wed Jan 17 16:15:20 GMT 2018 armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
180201  0:49:55 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.59-0+deb8u1 for debian-linux-gnu on armv7l ((Debian))

$ docker run --rm -it biarms/mysql:5.7 uname -a
Unable to find image 'biarms/mysql:5.7' locally
5.7: Pulling from biarms/mysql
Digest: sha256:93876d5a0f3a463f1d77e49afe9306ab12c58465c13e87623a1390bc45c22276
Status: Downloaded newer image for biarms/mysql:5.7
Linux a1be7c2b57f5 4.9.77-v7+ #1081 SMP Wed Jan 17 16:15:20 GMT 2018 armv7l armv7l armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5.7 --version
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

# docker run --rm -it biarms/mysql:5.5 uname -a
Linux 4cc9fec6292b 3.10.102 #115 SMP PREEMPT Sat Dec 3 09:19:19 CST 2016 aarch64 GNU/Linux

# docker run --rm -it biarms/mysql:5.5 --version
180201  0:49:58 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.59-0+deb8u1 for debian-linux-gnu on armv7l ((Debian))

# docker run --rm -it biarms/mysql:5.7 uname -a
Linux 2f48120c7588 3.10.102 #115 SMP PREEMPT Sat Dec 3 09:19:19 CST 2016 aarch64 aarch64 aarch64 GNU/Linux

# docker run --rm -it biarms/mysql:5.7 --version
mysqld  Ver 5.7.21-0ubuntu0.16.04.1 for Linux on armv7l ((Ubuntu))
```


### Tests with an Raspberry PI 1 (on a armv6 OS):
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

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux d75a854ad6d5 4.9.78+ #1084 Thu Jan 25 17:40:10 GMT 2018 armv6l GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
180201  0:48:16 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.59-0+deb8u1 for debian-linux-gnu on armv7l ((Debian))
```
