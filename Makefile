SHELL = bash

DOCKER_REGISTRY = docker.io/
DOCKER_IMAGE_NAME = biarms/mysql
ARCH = arm64v8
DOCKER_IMAGE_VERSION = 5.7.30

DOCKER_IMAGE_TAGNAME = $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)-linux-$(ARCH)-issue-03

default: test-tc-2

# Launch a local build as on circleci, that will call the default target, but inside the 'circleci build and test env'
circleci-local-build:
	@ circleci local execute

install-qemu:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

setup-swarm:
	# docker swarm leave --force || true
	# docker swarm init
	docker swarm init || true

hack-swarm-node:
	test $$(docker node ls | wc -l) = 2
	NODE_ID=$$(docker node ls | grep Leader | cut -d ' ' -f1) ;\
	  echo NODE_ID=$$NODE_ID ;\
	  docker node inspect $$NODE_ID

debug-env:
	echo "IMAGE: ${DOCKER_IMAGE_TAGNAME}"
	uname -a
	cat /etc/*release || true # to avoid failure on mac
	cat /proc/cpuinfo || true # to avoid failure on mac
	docker version
	docker info
	docker node ls
	# Check that previous command returns only 2 lines
	test $$(docker node ls | wc -l) = 2
	NODE_ID=$$(docker node ls | grep Leader | cut -d ' ' -f1) ;\
	  echo NODE_ID=$$NODE_ID ;\
	  docker node inspect $$NODE_ID
	docker ps -a
	docker service ls
	# docker images
	docker pull "${DOCKER_IMAGE_TAGNAME}"
	docker image inspect "${DOCKER_IMAGE_TAGNAME}"

test-tc-2: install-qemu setup-swarm debug-env
	TRACE=on bash tc-2.sh "${DOCKER_IMAGE_TAGNAME}"
