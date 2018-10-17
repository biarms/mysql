# About this Repo

## Overview
This is a fork of the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for
[Mysql](https://registry.hub.docker.com/_/mysql/). See [the Docker Hub page](https://registry.hub.docker.com/_/mysql/)
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
# docker run --rm mplatform/mquery biarms/mysql:5.5
Image: biarms/mysql:5.5
 * Manifest List: Yes
 * Supported platforms:
   - linux/arm/v6
   - linux/arm64
   - linux/arm/v7
```

Notices that these images are build on top of official docker images (resin/raspbian for armv6 and ubuntu for armv7 and arm64), and (try to) offer the same 'docker-entry-point' functionality as the official images (including the MYSQL_ROOT_PASSWORD_FILE usefull for docker swarm).

As these docker images were created to mimic as much as possible the official mysql build, the official 'mysql' readme (available at [docker-library/docs](https://github.com/docker-library/docs) and specifically in [docker-library/docs/mysql](https://github.com/docker-library/docs/tree/master/mysql)) should be fully applicable.

To pull this image from [docker hub/docker cloud](https://hub.docker.com/r/biarms/mysql/):
```
$ docker pull biarms/mysql:5.5 # should work on any arm device
```

## Test of this image on different ARM boxes:

### My (very very) simple test suite:
```
cat /etc/os-release
docker run --rm -it biarms/mysql:5.5 uname -a
docker run --rm -it biarms/mysql:5.5 --version
```

### Tests results with an Odroid XU4 (on a armv7l OS):
```
$ cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.1 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.1 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux 536497b49325 4.14.55-146 #1 SMP PREEMPT Wed Jul 11 22:31:01 -03 2018 armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
181017 19:48:45 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.60-0+deb7u1 for debian-linux-gnu on armv7l ((Debian))
```

### Tests with an Raspberry PI 3 (running a raspian armv7 OS):
```
$ cat /etc/os-release
PRETTY_NAME="Raspbian GNU/Linux 9 (stretch)"
NAME="Raspbian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux 80e6e9733c8c 4.14.34-v7+ #1110 SMP Mon Apr 16 15:18:51 BST 2018 armv7l GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
181017 20:22:36 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.60-0+deb7u1 for debian-linux-gnu on armv7l ((Debian))
```

### Tests with an Raspberry PI 3 (running a debian aarch64 OS):
```
$ cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux buster/sid"
NAME="Debian GNU/Linux"
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux 1e6e450fabf8 4.18.0-2-arm64 #1 SMP Debian 4.18.10-2 (2018-10-07) aarch64 aarch64 aarch64 GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
181017 19:57:33 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.61-0ubuntu0.14.04.1 for debian-linux-gnu on aarch64 ((Ubuntu))
```

### Tests with an Rock 64 board (on a aarch64 OS):
```
$ cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux b0c7998b824e 4.4.132-1072-rockchip-ayufan-ga1d27dba5a2e #1 SMP Sat Jul 21 20:18:03 UTC 2018 aarch64 GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
181017 19:51:19 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.59-0+deb7u1 for debian-linux-gnu on armv7l ((Debian))
```

### Tests with an Raspberry PI 1 (on a armv6 OS):
```
$ cat /etc/os-release
PRETTY_NAME="Raspbian GNU/Linux 9 (stretch)"
NAME="Raspbian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"

$ docker run --rm -it biarms/mysql:5.5 uname -a
Linux 801449bca92e 4.9.59+ #1047 Sun Oct 29 11:47:10 GMT 2017 armv6l GNU/Linux

$ docker run --rm -it biarms/mysql:5.5 --version
181017 20:19:22 [Warning] Using unique option prefix key_buffer instead of key_buffer_size is deprecated and will be removed in a future release. Please use the full name instead.
mysqld  Ver 5.5.60-0+deb7u1 for debian-linux-gnu on armv7l ((Debian))
```



