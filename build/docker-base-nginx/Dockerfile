ARG DOCKER_DISTRIBUTION
ARG DOCKER_RELEASE
FROM ${DOCKER_DISTRIBUTION}:${DOCKER_RELEASE}
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y install --no-install-recommends nginx-light apache2-utils libgeoip1 liblua5.3-0 libmaxminddb0 && rm -rf /var/lib/apt/lists/*
COPY files/etc/nginx/ /etc/nginx/
COPY files/bin/ /usr/local/bin/
ARG MODSEC_RELEASE
ARG MODSEC_NGINX_RELEASE
COPY mod-deps/libmodsecurity_${MODSEC_RELEASE}-1_amd64.deb mod-deps/libnginx-mod-security_${MODSEC_NGINX_RELEASE}-1_amd64.deb /tmp/
RUN dpkg -i /tmp/libmodsecurity_${MODSEC_RELEASE}-1_amd64.deb /tmp/libnginx-mod-security_${MODSEC_NGINX_RELEASE}-1_amd64.deb || \
	( apt update && apt-get -f --force-yes --yes install && dpkg -i /tmp/libmodsecurity_${MODSEC_RELEASE}-1_amd64.deb /tmp/libnginx-mod-security_${MODSEC_NGINX_RELEASE}-1_amd64.deb ) && rm -rf /tmp/*.deb
RUN mkdir -p /etc/nginx/modules/ && cp /usr/local/nginx/modules/ngx_http_modsecurity_module.so /etc/nginx/modules/
RUN dpkg -L libmodsecurity
RUN dpkg -L libnginx-mod-security
