SHELL = bash

# Inspired from https://github.com/hypriot/rpi-mysql/blob/master/Makefile
# And from https://stackoverflow.com/questions/5873025/heredoc-in-a-makefile

DOCKER_IMAGE_NAME=biarms/mysql
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):linux-arm-$(DOCKER_IMAGE_VERSION)

default: check build test push

check:
	if [[ "$(DOCKER_IMAGE_VERSION)" == "" ]]; then echo 'DOCKER_IMAGE_VERSION is $(DOCKER_IMAGE_VERSION) (MUST BE SET !)' && exit 1; fi
	which manifest-tool || (echo "Ensure that you've got the manifest-tool utility in your path. Could be downloaded from  https://github.com/estesp/manifest-tool/releases/download/" && exit 2)

build: check
	docker build -t $(DOCKER_IMAGE_TAGNAME) -f Dockerfile-$(DOCKER_IMAGE_VERSION) .

push: check
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest
	docker push $(DOCKER_IMAGE_TAGNAME)
	docker push $(DOCKER_IMAGE_NAME):latest
	# When https://github.com/docker/cli/pull/138 merged branch will be part of an official release:
	# docker manifest create biarms/mysql biarms/mysql-arm
	# docker manifest annotate biarms/mysql biarms/mysql-arm --os linux --arch arm
	# docker manifest push new-list-ref-name
	#
	# In the mean time, I use: https://github.com/estesp/manifest-tool
	# sudo wget -O /usr/local/bin manifest-tool https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-armv7
	# sudo chmod +x /usr/local/bin/manifest-tool
	## define manifest
	## 	image: biarms/mysql:$(DOCKER_IMAGE_VERSION)
	## 	manifests:
	## 	  - image: biarms/mysql:linux-arm-$(DOCKER_IMAGE_VERSION)
	## 	    platform:
	## 	    architecture: arm
	## 	    os: linux
	## 	#TODO: armv6l, armv7l, aarch64
	## endef
	## echo $(manifest) > manifest.yaml
	manifest-tool push from-spec manifest-$(DOCKER_IMAGE_VERSION).yaml

test: check
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."
	docker run --rm $(DOCKER_IMAGE_TAGNAME) uname -a
    docker run --rm $(DOCKER_IMAGE_TAGNAME) --version
	# docker run --rm -e MYSQL_ROOT_PASSWORD=changeit -it $(DOCKER_IMAGE_TAGNAME) mysqld

version: check
	docker run --rm $(DOCKER_IMAGE_TAGNAME) mysql --version

rmi: check
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)

rebuild: rmi build
