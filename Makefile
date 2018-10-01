SHELL = bash

# Inspired from https://github.com/hypriot/rpi-mysql/blob/master/Makefile

#DOCKER_REGISTRY=''
DOCKER_IMAGE_NAME=biarms/mysql
DOCKER_IMAGE_TAGNAME=$(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)-linux-$(ARCH)

default: build test tag push-images

check:
	@if [[ "$(DOCKER_IMAGE_VERSION)" == "" ]]; then \
	    echo 'DOCKER_IMAGE_VERSION is $(DOCKER_IMAGE_VERSION) (MUST BE SET !)' && \
	    echo 'Correct usage sample: ' && \
	    echo '    ARCH=arm32v7 DOCKER_IMAGE_VERSION=5.5 make ' && \
	    echo '    or ' && \
        echo '    ARCH=arm64v8 DOCKER_IMAGE_VERSION=5.7 make' && \
        exit 1; \
	fi
	@if [[ "$(ARCH)" == "" ]]; then \
	    echo 'ARCH is $(ARCH) (MUST BE SET !)' && \
	    echo 'Correct usage sample: ' && \
	    echo '    ARCH=arm32v7 DOCKER_IMAGE_VERSION=5.5 make ' && \
	    echo '    or ' && \
        echo '    ARCH=arm64v8 DOCKER_IMAGE_VERSION=5.7 make' && \
        exit 1; \
	fi
	@which manifest-tool > /dev/null || (echo "Ensure that you've got the manifest-tool utility in your path. Could be downloaded from  https://github.com/estesp/manifest-tool/releases/download/" && exit 2)
	@echo "DOCKER_REGISTRY: $(DOCKER_REGISTRY)"

build: check
	docker build -t $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):latest $(DOCKER_FILE) .

test: version
	set -eo pipefail
	docker run --rm $(DOCKER_IMAGE_NAME) /bin/echo "Success."
	docker run --rm $(DOCKER_IMAGE_NAME) uname -a
	docker run --rm $(DOCKER_IMAGE_NAME) mysql --version || grep mysql
	docker run --rm $(DOCKER_IMAGE_NAME) mysqld --version || grep mysql
	docker run --rm $(DOCKER_IMAGE_NAME) mysql --version || grep $(DOCKER_IMAGE_VERSION)
	docker run --rm $(DOCKER_IMAGE_NAME) mysqld --version || grep $(DOCKER_IMAGE_VERSION)

tag: check
	docker tag $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):latest $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
	docker tag $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):latest $(DOCKER_IMAGE_TAGNAME)

push-images: check
	docker push $(DOCKER_IMAGE_TAGNAME)
	docker push $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
	docker push $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):latest

push: push-manifest push-images

rmi: check
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)

rebuild: rmi build

version: check
	docker run --rm $(DOCKER_IMAGE_NAME) mysql --version
	docker run --rm $(DOCKER_IMAGE_NAME) mysqld --version

start: check
	docker run --rm -e MYSQL_ROOT_PASSWORD=changeit -it $(DOCKER_IMAGE_TAGNAME) mysqld

push-manifest: check
	# When https://github.com/docker/cli/pull/138 merged branch will be part of an official release:
	# docker manifest create biarms/mysql biarms/mysql-arm
	# docker manifest annotate biarms/mysql biarms/mysql-arm --os linux --arch arm
	# docker manifest push new-list-ref-name
	#
	# In the mean time, I use: https://github.com/estesp/manifest-tool
	# sudo wget -O /usr/local/bin manifest-tool https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-armv7
	# sudo chmod +x /usr/local/bin/manifest-tool
	echo "image: $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)" > manifest.yaml
	echo "manifests:" >> manifest.yaml
	#echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:linux-arm32v6-$(DOCKER_IMAGE_VERSION) " >> manifest.yaml
	#echo "    platform: " >> manifest.yaml
	#echo "      os: linux " >> manifest.yaml
	#echo "      architecture: arm " >> manifest.yaml
	#echo "      variant: v6 " >> manifest.yaml
	#echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:linux-arm32v7-$(DOCKER_IMAGE_VERSION) " >> manifest.yaml
	#echo "    platform: " >> manifest.yaml
	#echo "      os: linux " >> manifest.yaml
	#echo "      architecture: arm " >> manifest.yaml
	#echo "      variant: v7 " >> manifest.yaml
	echo "  - image: $(DOCKER_REGISTRY)biarms/mysql:linux-arm64v8-$(DOCKER_IMAGE_VERSION) " >> manifest.yaml
	echo "    platform: " >> manifest.yaml
	echo "      os: linux " >> manifest.yaml
	echo "      architecture: arm64 " >> manifest.yaml
	echo "      variant: v8 " >> manifest.yaml
	manifest-tool push from-spec manifest.yaml
	# rm manifest.yaml

