SHELL = bash

DOCKER_REGISTRY = docker.io/
DOCKER_IMAGE_NAME = biarms/mysql
ARCH = arm64v8
DOCKER_IMAGE_VERSION = 5.7.30

DOCKER_IMAGE_TAGNAME = $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)-linux-$(ARCH)

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
	# cat /proc/cpuinfo || true # to avoid failure on mac
	docker version
	docker info
	docker node ls
	# Check that previous command returns only 2 lines
	test $$(docker node ls | wc -l) = 2
	NODE_ID=$$(docker node ls | grep Leader | cut -d ' ' -f1) ;\
	  echo NODE_ID=$$NODE_ID ;\
	  docker node inspect $$NODE_ID
	docker ps -a
	docker images
	docker pull ${DOCKER_IMAGE_TAGNAME}
	docker image inspect ${DOCKER_IMAGE_TAGNAME}

test-tc-2: install-qemu setup-swarm debug-env
	docker service rm mysql-test2 || true
	docker secret rm mysql-test2-secret || true
	printf "dummy_password" | docker secret create mysql-test2-secret -
	echo "Launch the service in background to be able to analyse the service..."
	docker service create --name mysql-test2 --secret mysql-test2-secret -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-test2-secret -e MYSQL_DATABASE=testdb -e MYSQL_USER=testuser -e MYSQL_PASSWORD_FILE=/run/secrets/mysql-test2-secret ${DOCKER_IMAGE_TAGNAME} &
	echo "Wait a bit..."
	sleep 3
	echo "Then Continue"
	docker service inspect mysql-test2
	echo "Next"
	docker service inspect mysql-test2 | grep "Architecture" || true
	# Diff between Travis and CircleCI: the 'Architecture' is set for CircleCI, but not for Travis !
	echo "Wait"
	while ! (docker service logs mysql-test2 2>&1 | grep 'ready for connections') ; do sleep 1; done
	docker service logs mysql-test2
	docker service rm mysql-test2
	docker secret rm mysql-test2-secret
	#
	docker ps -a
	# rm -rf tmp

