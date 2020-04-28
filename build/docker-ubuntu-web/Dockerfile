ARG DOCKER_DISTRIBUTION
ARG DOCKER_RELEASE
FROM ${DOCKER_DISTRIBUTION}:${DOCKER_RELEASE}
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y install --no-install-recommends nginx-light apache2-utils build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev libtool autoconf automake libxml2-dev libcurl4-openssl-dev libgeoip-dev libmaxminddb-dev && rm -rf /var/lib/apt/lists/*
COPY git-deps/ModSecurity  /usr/local/src/ModSecurity
WORKDIR /usr/local/src/ModSecurity
RUN sh build.sh && ./configure && make && make install
COPY git-deps/ModSecurity-nginx /usr/local/src/ModSecurity-nginx
ARG NGINX_VERSION
COPY src-deps/nginx-${NGINX_VERSION}.gz /usr/local/src/
WORKDIR /usr/local/src/nginx-${NGINX_VERSION}
RUN mkdir /etc/nginx/modules/ && tar xzvf /usr/local/src/nginx-${NGINX_VERSION}.gz && cd nginx-${NGINX_VERSION} && ./configure --with-compat --add-dynamic-module=/usr/local/src/ModSecurity-nginx && make modules && cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules/
COPY files/etc/nginx/ /etc/nginx/
RUN cp /usr/local/src/ModSecurity/unicode.mapping /etc/nginx/modsec/
RUN rm -rf /usr/local/src/ModSecurity-nginx /usr/local/src/ModSecurity /usr/local/src/nginx-${NGINX_VERSION}
COPY files/bin/ /usr/local/bin/
