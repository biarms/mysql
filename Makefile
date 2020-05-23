SHELL = bash

DOCKER_REGISTRY = docker.io/
DOCKER_IMAGE_NAME = biarms/mysql
ARCH = arm64v8
LINUX_ARCH = aarch64
DOCKER_IMAGE_VERSION = 5.7.30

DOCKER_IMAGE_TAGNAME = $(DOCKER_REGISTRY)$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)-linux-$(ARCH)$(BETA_VERSION)

default: install-qemu debug-env test-tc-2

# Launch a local build as on circleci, that will call the default target, but inside the 'circleci build and test env'
circleci-local-build:
	@ circleci local execute

# Test are qemu based. SHOULD_DO: use `docker buildx bake`. See https://github.com/docker/buildx#buildx-bake-options-target
install-qemu:
	# @ # From https://github.com/multiarch/qemu-user-static:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

debug-env:
	uname -a
	ls /etc/*release* || true
	cat /proc/cpuinfo || true
	# | grep release
	# sh -c 'cat /etc/os-release'
	# sh -c 'cat /etc/lsb-release'
	docker version
	docker info
	docker ps -a

test-tc-2:
	# Test Case 2: test that it is possible to use "xxx_FILE" syntax
	echo "IMAGE: ${DOCKER_IMAGE_TAGNAME}"
	docker swarm leave --force || true
	docker swarm init
	docker service rm mysql-test2 || true
	docker secret rm mysql-test2-secret || true
	## Next impl is OK if you run this test suite on a test VM, for instance. But it is NOK if run in CircleCI, as CircleCI execution is inside a docker container that use docker socket mount to share the docker server
	## So volumes mounts won't be OK
	# rm -rf tmp || true
	# mkdir tmp
	# echo "dummy_password" > tmp/password_file
	# docker create --name mysql-test2 -v `pwd`/tmp/password_file:/tmp/root_password_file -v `pwd`/tmp/password_file:/tmp/user_password_file -e MYSQL_ROOT_PASSWORD_FILE=/tmp/root_password_file -e MYSQL_DATABASE=testdb -e MYSQL_USER=testuser -e MYSQL_PASSWORD_FILE=/tmp/user_password_file ${DOCKER_IMAGE_TAGNAME}
	printf "dummy_password" | docker secret create mysql-test2-secret -
	docker service create --name mysql-test2 --secret mysql-test2-secret -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-test2-secret -e MYSQL_DATABASE=testdb -e MYSQL_USER=testuser -e MYSQL_PASSWORD_FILE=/run/secrets/mysql-test2-secret ${DOCKER_IMAGE_TAGNAME}
	while ! (docker service logs mysql-test2 2>&1 | grep 'ready for connections') ; do sleep 1; done
	docker service rm mysql-test2
	docker secret rm mysql-test2-secret
	#
	docker ps -a
	# rm -rf tmp

