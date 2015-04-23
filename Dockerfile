# Couchbase Server for Ubuntu 14.04
#
# GitHub - http://github.com/dalekurt/docker-couchbase-server
# Docker Hub - http://hub.docker.com/u/dalekurt/couchbase-server
# Twitter - http://www.twitter.com/dalekurt

FROM stackbrew/ubuntu:14.04
MAINTAINER Dale-Kurt Murray "dalekurt.murray@gmail.com"

ENV CB_USERNAME		Administrator
ENV CB_PASSWORD		couchbaseadmin
ENV CB_REST_USERNAME	Administrator
ENV CB_REST_PASSWORD	couchbaseadmin
ENV CB_BUCKET		mystuff

# Basic environment setup
# note: SpiderMonkey build req's: https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Linux_Prerequisites
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get install -y librtmp0 python-httplib2 language-pack-en-base vim wget curl \
	&& dpkg-reconfigure locales

# Downloading and Installing Couchbase
ENV CB_VERSION 3.0.3
# The file name has changed for previous version 2.x.x
# ENV CB_FILENAME couchbase-server-enterprise_${CB_VERSION}_x86_64.deb
#
ENV CB_FILENAME couchbase-server-enterprise_${CB_VERSION}-ubuntu12.04_amd64.deb
ENV CB_SOURCE http://packages.couchbase.com/releases/$CB_VERSION/$CB_FILENAME

RUN wget -O/tmp/$CB_FILENAME $CB_SOURCE && \
	dpkg -i /tmp/$CB_FILENAME && \
	rm /tmp/$CB_FILENAME

# SpiderMonkey, jsawk, and resty
RUN apt-get install -y libmozjs-24-bin \
	&& ln -s /usr/bin/js24 /usr/local/bin/js \
	&& echo "export JS=/usr/local/bin/js" > /etc/jsawkrc \
	&& wget -O/usr/local/bin/jsawk http://github.com/micha/jsawk/raw/master/jsawk \
	&& wget -O/usr/local/bin/resty http://github.com/micha/resty/raw/master/resty \
	&& chmod +x /usr/local/bin/jsawk /usr/local/bin/resty \
	&& { \
		echo ""; \
		echo "source /usr/local/bin/resty -W 'http://localhost:8091/pools/default'"; \
		echo ""; \
	} >> /etc/bash.bashrc

# Create directory structure for volume sharing
RUN mkdir -p /app \
	&& mkdir -p /app/data \
	&& mkdir -p /app/index \
	&& mkdir -p /app/resources \
	&& mkdir -p /app/conf \
	&& mkdir -p /app/backup \
	&& mkdir -p /app/logs \
	&& chown -R couchbase:couchbase /app
VOLUME ["/app/data"]
VOLUME ["/app/backup"]
VOLUME ["/app/volume"]

# Add bootstrapper
ADD resources/docker-couchbase /usr/local/bin/docker-couchbase
RUN export PATH=$PATH:/opt/couchbase/bin \
	&& echo "export PATH=$PATH:/opt/couchbase/bin" >> /etc/bash.bashrc
EXPOSE 8091 8092 11210

# Add backup to /app/backup
ADD backup /app/backup

# Add Resources
ADD resources/couchbase.txt /app/resources/couchbase.txt
ADD resources/docker.txt /app/resources/docker.txt
ADD resources/default.conf /app/conf/default.conf

ENTRYPOINT ["docker-couchbase"]
CMD	["start"]
