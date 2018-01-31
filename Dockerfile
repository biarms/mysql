# Changed from original - end: don't inherite from debian:jessie, because mysql-server-5.7 don't exist on debian:jessie arm apt-get repo
FROM ubuntu:trusty-20180123
# Changed from original - end
# Changed from original - start: add one line to override the maintainer
MAINTAINER Brother In Arms <project.biarms@gmail.com>
# Changed from original - end

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

# add gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget

RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y --no-install-recommends \
# for MYSQL_RANDOM_ROOT_PASSWORD
		pwgen \
# for mysql_ssl_rsa_setup
		openssl \
# FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
# File::Basename
# File::Copy
# Sys::Hostname
# Data::Dumper
		perl \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
	key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	rm -r "$GNUPGHOME"; \
	apt-key list > /dev/null

ENV MYSQL_MAJOR 5.7
# Changed from original - start: MYSQL_VERSION is not used anymore
# ENV MYSQL_VERSION 5.7.21-1debian8
# Changed from original - end

# Changed from original - start: mysql-server is found in official ubuntu repo
# RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list
# Changed from original - end

# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
RUN { \
        # Changed from original - start: mysql-community-server is named mysql-server on ubuntu
		echo mysql-server mysql-server/data-dir select ''; \
        # Changed from original: root-pass is names root_password on ubuntu
		echo mysql-server mysql-server/root_password password 'changeit'; \
        # Changed from original: re-root-pass is names root_password_again on ubuntu
		echo mysql-server mysql-server/root_password_again password 'changeit'; \
		echo mysql-server mysql-server/remove-test-db select false; \
        # Changed from original - end
	} | debconf-set-selections \
# Changed from original - start: add tzdata package to fix a timezone blocking issue at startup
# (according to https://serverfault.com/questions/511821/how-to-update-install-zoneinfo-timezone-database-on-centos)
# Changed from original - end
	&& apt-get update && apt-get install -y "mysql-server-${MYSQL_MAJOR}" tzdata && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	&& chmod 777 /var/run/mysqld \
# comment out a few problematic configuration values
	&& find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
# don't reverse lookup hostnames, they are usually another container
	&& echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

VOLUME /var/lib/mysql

# Changed from original - start: next 3 lines result from a hack: download the official docker-entrypoint.sh file from official github repo
ADD https://raw.githubusercontent.com/docker-library/mysql/master/${MYSQL_MAJOR}/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chown mysql:mysql /usr/local/bin/docker-entrypoint.sh
# Changed from original - end
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
# Changed from original - start: on ubuntu, /usr/local/bin is not in the path
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# Changed from original - end

EXPOSE 3306
CMD ["mysqld"]

# Changed from original: next line was added
# (inspired by https://github.com/rothgar/rpi-wordpress/blob/master/mysql/Dockerfile)
ADD my-small.cnf /etc/mysql/conf.d/
