ARG DOCKER_DISTRIBUTION
ARG DOCKER_RELEASE
FROM ${DOCKER_DISTRIBUTION}:${DOCKER_RELEASE}
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y install --no-install-recommends nginx-light checkinstall build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev libtool autoconf automake libxml2-dev libcurl4-openssl-dev libgeoip-dev libmaxminddb-dev liblua5.3-dev && rm -rf /var/lib/apt/lists/*
COPY git-deps/ModSecurity  /usr/local/src/ModSecurity
COPY files/Makefile-ModSecurity.patch /usr/local/src/ModSecurity/
COPY git-deps/ModSecurity-nginx /usr/local/src/ModSecurity-nginx
ARG NGINX_VERSION
COPY src-deps/nginx-${NGINX_VERSION}.gz /usr/local/src/
COPY files/etc/nginx/ /etc/nginx/
COPY files/bin/ /usr/local/bin/
RUN mkdir -p {/opt/src,/srv/artifacts}
