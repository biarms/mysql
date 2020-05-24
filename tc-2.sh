#!/usr/bin/env bash

run-tc2() {
  local image_to_test="$1"
  docker pull "${image_to_test}"
  echo "docker info is a generic provider ?"
  docker info | grep provider || true
  echo "Image architecture: "
  docker inspect "${image_to_test}" | grep "Architecture" || true
  docker service rm mysql-test2 2>/dev/null || true
	docker secret rm mysql-test2-secret 2>/dev/null || true
	printf "dummy_password" | docker secret create mysql-test2-secret -
	echo "Launch the service in background to be able to analyse the service..."
	docker service create -d --name mysql-test2 --secret mysql-test2-secret -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-test2-secret -e MYSQL_DATABASE=testdb -e MYSQL_USER=testuser -e MYSQL_PASSWORD_FILE=/run/secrets/mysql-test2-secret "${image_to_test}"
	i=0
	timeout=0
	result=0
	while true ; do
	  result=$(docker service logs mysql-test2 2>&1 | grep -c "ready for connections") || true # docker service logs may return an error code if the service is not really up. || true will ignore it...
	  if [ $result -gt 0 ]; then
	    echo "Log are OK, exiting"
	    break
	  else
	    echo "Logs are still NOK..."
	  fi
	  i=$[$i+1]
	  echo "i:$i"
	  if [ $i -gt 10 ]; then
	    timeout=1
	  	echo "Timeout !!! TC will fail (after service inspection and cleanup...)"
	  	break
  	fi
	  sleep 1
	done
	#docker service ls
	# docker service inspect mysql-test2
	# Diff between Travis and CircleCI: the 'Architecture' is set for CircleCI, but not for Travis !
	echo "Service architecture:"
	docker service inspect mysql-test2 | grep "Architecture" || true
	#docker service logs mysql-test2
	echo "service cleanup"
	docker service rm mysql-test2
	docker secret rm mysql-test2-secret
	#docker ps -a
	if [[ $timeout -eq 1 ]]; then
	  echo "TC failed because of timeout !"
	  exit -2
	else
	  echo "Service was started and work as expected !"
	fi
}

main() {
    # From https://github.com/progrium/bashstyle
    set -eo pipefail
    [[ "$TRACE" ]] && set -x
    run-tc2 "$1"
    # run-tc2 "biarms/mysql:5.7.30-linux-amd64"
    # run-tc2 "biarms/mysql:5.7.30-linux-arm64v8"
}

# From https://github.com/progrium/bashstyle
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
