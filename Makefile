SHELL = bash

# Inspired from https://github.com/hypriot/rpi-mysql/blob/master/Makefile

# DOCKER_REGISTRY ?= # Nothing, or 'registry:5000/'
# BETA_VERSION ?= # Nothing, or '-beta-123'
DOCKER_IMAGE_NAME=biarms/mysql
DOCKER_IMAGE_TAGNAME=$(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)-linux-$(ARCH)$(BETA_VERSION)

BUILD_ARCH = $(ARCH)/
BUILD_DATE ?= `date -u +"%Y-%m-%dT%H-%M-%SZ"`
# See https://microbadger.com/labels
VCS_REF = `git rev-parse --short HEAD`

MYSQL_VERSION_ARM32V6=5.5.60
MYSQL_VERSION_OTHER_ARCH=5.7.30

default: build

build: all-images create-and-push-manifests

push: check-binaries
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "biarms/mysql:latest"

all-images: prepare
	ARCH=arm32v6 LINUX_ARCH=armv6l  DOCKER_IMAGE_VERSION=${MYSQL_VERSION_ARM32V6} DOCKER_FILE='-f Dockerfile-arm32v6' make all-one-image
	ARCH=arm32v7 LINUX_ARCH=armv7l  DOCKER_IMAGE_VERSION=${MYSQL_VERSION_OTHER_ARCH} make all-one-image
	ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=${MYSQL_VERSION_OTHER_ARCH} make all-one-image
	ARCH=amd64   LINUX_ARCH=x86_64  DOCKER_IMAGE_VERSION=${MYSQL_VERSION_OTHER_ARCH} make all-one-image

create-and-push-manifests: #ideally, should reference 'all-images', but that's boring when we test this script...
	# biarms/mysql:5.7.30
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" --os linux --arch arm --variant v7
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" --os linux --arch arm64 --variant v8
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}" --os linux --arch amd64
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}${BETA_VERSION}"
	# biarms/mysql:5.7
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend "biarms/mysql:5.7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5.7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" --os linux --arch arm --variant v7
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5.7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" --os linux --arch arm64 --variant v8
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5.7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}" --os linux --arch amd64
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "biarms/mysql:5.7${BETA_VERSION}"
	# biarms/mysql:5
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend "biarms/mysql:5${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_ARM32V6}-linux-arm32v6${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_ARM32V6}-linux-arm32v6${BETA_VERSION}" --os linux --arch arm --variant v6
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" --os linux --arch arm --variant v7
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" --os linux --arch arm64 --variant v8
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:5${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}" --os linux --arch amd64
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "biarms/mysql:5${BETA_VERSION}"
	# biarms/mysql:latest
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend "biarms/mysql:latest${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_ARM32V6}-linux-arm32v6${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:latest${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_ARM32V6}-linux-arm32v6${BETA_VERSION}" --os linux --arch arm --variant v6
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:latest${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm32v7${BETA_VERSION}" --os linux --arch arm --variant v7
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:latest${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-arm64v8${BETA_VERSION}" --os linux --arch arm64 --variant v8
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate "biarms/mysql:latest${BETA_VERSION}" "biarms/mysql:${MYSQL_VERSION_OTHER_ARCH}-linux-amd64${BETA_VERSION}" --os linux --arch amd64
	# Don't push this image on purpose !

all-one-image: build-one-image test-one-image tag-one-image push-one-image

check-binaries:
	@ which docker > /dev/null || (echo "Please install docker before using this script" && exit 1)
	@ which git > /dev/null || (echo "Please install git before using this script" && exit 2)
	@ # deprecated: which manifest-tool > /dev/null || (echo "Ensure that you've got the manifest-tool utility in your path. Could be downloaded from  https://github.com/estesp/manifest-tool/releases/" && exit 3)
	@ DOCKER_CLI_EXPERIMENTAL=enabled docker manifest --help | grep "docker manifest COMMAND" > /dev/null || (echo "docker manifest is needed. Consider upgrading docker" && exit 4)
	@ DOCKER_CLI_EXPERIMENTAL=enabled docker version -f '{{.Client.Experimental}}' | grep "true" > /dev/null || (echo "docker experimental mode is not enabled" && exit 5)

check: check-binaries
	@ if [[ "$(DOCKER_IMAGE_VERSION)" == "" ]]; then \
	    echo 'DOCKER_IMAGE_VERSION is $(DOCKER_IMAGE_VERSION) (MUST BE SET !)' && \
	    echo 'Correct usage sample: ' && \
        echo '    ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=5.7.30 make' && \
	    echo '    or ' && \
        echo '    ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=5.7.30 make' && \
        exit -1; \
	fi
	@ if [[ "$(ARCH)" == "" ]]; then \
	    echo 'ARCH is $(ARCH) (MUST BE SET !)' && \
	    echo 'Correct usage sample: ' && \
        echo '    ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=5.7.30 make' && \
	    echo '    or ' && \
        echo '    ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=5.7.30 make' && \
        exit -2; \
	fi
	@ if [[ "$(LINUX_ARCH)" == "" ]]; then \
	    echo 'LINUX_ARCH is $(LINUX_ARCH) (MUST BE SET !)' && \
	    echo 'Correct usage sample: ' && \
	    echo '    ARCH=arm32v7 LINUX_ARCH=armv7l DOCKER_IMAGE_VERSION=5.7.30 make ' && \
	    echo '    or ' && \
        echo '    ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=5.7.30 make' && \
        exit -3; \
	fi
	@ echo "DOCKER_REGISTRY: ${DOCKER_REGISTRY}"
	@ echo "BUILD_DATE: ${BUILD_DATE}"
	@ echo "VCS_REF: ${VCS_REF}"

prepare: check-binaries
	@ # From https://github.com/multiarch/qemu-user-static:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

build-one-image: check
	docker build -t ${DOCKER_REGISTRY}${DOCKER_IMAGE_TAGNAME} --build-arg VERSION="${DOCKER_IMAGE_VERSION}" --build-arg VCS_REF="${VCS_REF}" --build-arg BUILD_DATE="${BUILD_DATE}" --build-arg BUILD_ARCH="${BUILD_ARCH}" ${DOCKER_FILE} .

test-one-image: check
	docker run --rm ${DOCKER_IMAGE_TAGNAME} /bin/echo "Success."
	docker run --rm ${DOCKER_IMAGE_TAGNAME} uname -a
	docker run --rm ${DOCKER_IMAGE_TAGNAME} mysql --version
	docker run --rm ${DOCKER_IMAGE_TAGNAME} uname -a | grep "${LINUX_ARCH}"
	docker run --rm ${DOCKER_IMAGE_TAGNAME} mysql --version | grep mysql
	docker run --rm ${DOCKER_IMAGE_TAGNAME} mysqld --version | grep mysql
	docker run --rm ${DOCKER_IMAGE_TAGNAME} mysql --version | grep "${DOCKER_IMAGE_VERSION}"
	docker run --rm ${DOCKER_IMAGE_TAGNAME} mysqld --version | grep "${DOCKER_IMAGE_VERSION}"
	# on armv6l, it will return 'armv7l'...
	# docker run --rm ${DOCKER_IMAGE_NAME} mysql --version | grep "${LINUX_ARCH}"
	# docker run --rm ${DOCKER_IMAGE_NAME} mysqld --version | grep "${LINUX_ARCH}"
	docker stop mysql-test || true
	docker rm mysql-test || true
	docker create --name mysql-test -e MYSQL_ROOT_PASSWORD=root_password -e MYSQL_DATABASE=testdb -e MYSQL_USER=testuser -e MYSQL_PASSWORD=testpassword ${DOCKER_IMAGE_TAGNAME}
	docker start mysql-test
	# wait for port 3306 to be ready
	# netstat -tulpn | grep LISTEN | grep 3306
	# lsof -i -P -n | grep LISTEN | grep 3306
	while ! (docker logs mysql-test 2>&1 | grep 'ready for connections') ; do sleep 1; done
	# docker run --rm -it --link mysql-test ${DOCKER_IMAGE_NAME} bash -c 'sleep 1 && mysql -h mysql-test -u testuser -ptestpassword -e "show variables;" testdb'
	docker stop mysql-test
	docker rm mysql-test

tag-one-image: check
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_REGISTRY)$(DOCKER_IMAGE_TAGNAME)

push-one-image: check
	docker push $(DOCKER_IMAGE_TAGNAME)

# Helper targets
rmi-one-image: check
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)

rebuild-one-image: rmi-one-image build-one-image

# build-manifest-with-manifest-tool-deprecated:
# 	# When https://github.com/docker/cli/pull/138 merged branch will be part of an official release:
# 	# docker manifest create biarms/mysql biarms/mysql-arm
# 	# docker manifest annotate biarms/mysql biarms/mysql-arm --os linux --arch arm
# 	# docker manifest push new-list-ref-name
# 	#
# 	# In the mean time, I use: https://github.com/estesp/manifest-tool
# 	# sudo wget -O /usr/local/bin manifest-tool https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-armv7
# 	# sudo chmod +x /usr/local/bin/manifest-tool
# 	echo "image: $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):5" > manifest.yaml
# 	echo "manifests:" >> manifest.yaml
# 	echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:5.5.62-linux-armv6l " >> manifest.yaml
# 	echo "    platform: " >> manifest.yaml
# 	echo "      os: linux " >> manifest.yaml
# 	echo "      architecture: arm " >> manifest.yaml
# 	echo "      variant: v6 " >> manifest.yaml
# 	echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:5.5.61-linux-armv7l " >> manifest.yaml
# 	echo "    platform: " >> manifest.yaml
# 	echo "      os: linux " >> manifest.yaml
# 	echo "      architecture: arm " >> manifest.yaml
# 	echo "      variant: v7 " >> manifest.yaml
# 	echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:5.5.61-linux-aarch64 " >> manifest.yaml
# 	echo "    platform: " >> manifest.yaml
# 	echo "      os: linux " >> manifest.yaml
# 	echo "      architecture: arm64 " >> manifest.yaml
# 	echo "      variant: v8 " >> manifest.yaml
# 	echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:5.5.61-linux-aarch64 " >> manifest.yaml
# 	echo "    platform: " >> manifest.yaml
# 	echo "      os: linux " >> manifest.yaml
# 	echo "      architecture: arm64 " >> manifest.yaml
# 	echo "      variant: v8 " >> manifest.yaml
# 	manifest-tool push from-spec manifest.yaml
# 	# rm manifest.yaml
#
# create-manifests-deprecated:
# 	# Pre-requist to perform next step (inspired from https://github.com/hypriot/rpi-mysql/blob/master/.travis.yml)
# 	# echo "Enabling docker client experimental features"
# 	# mkdir -p ~/.docker
# 	# echo '{ "experimental": "enabled" }' > ~/.docker/config.json
# 	# docker version
# 	#
# 	#
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate biarms/mysql:5 biarms/mysql:5.5.60-linux-armv6l  --os linux --arch arm   --variant v6
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate biarms/mysql:5 biarms/mysql:5.5.61-linux-armv7l  --os linux --arch arm   --variant v7
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate biarms/mysql:5 biarms/mysql:5.5.61-linux-aarch64 --os linux --arch arm64 --variant v8
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push biarms/mysql:5
# 	# Latest
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend biarms/mysql biarms/mysql:5.5.60-linux-armv6l biarms/mysql:5.5.61-linux-armv7l biarms/mysql:5.5.61-linux-aarch64
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate biarms/mysql biarms/mysql:5.5.60-linux-armv6l  --os linux --arch arm   --variant v6
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate biarms/mysql biarms/mysql:5.5.61-linux-armv7l  --os linux --arch arm   --variant v7
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest annotate biarms/mysql biarms/mysql:5.5.61-linux-aarch64 --os linux --arch arm64 --variant v8
# 	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push biarms/mysql
