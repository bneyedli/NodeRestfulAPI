ARG DOCKER_DISTRIBUTION
ARG DOCKER_RELEASE
FROM ${DOCKER_DISTRIBUTION}:${DOCKER_RELEASE}
COPY git-deps /usr/local/src/git-deps
COPY keys /usr/local/share/keys
COPY files/bin/* /usr/local/bin/
ENV DEBIAN_FRONTEND noninteractive
ARG NODE_VERSION
RUN echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $(grep DISTRIB_CODENAME /etc/lsb-release|cut -d= -f2) main" > /etc/apt/sources.list.d/nodesource.list
RUN apt-key add /usr/local/share/keys/nodesource.gpg.key
RUN apt update && apt -y --no-install-recommends install libxml2-dev libffi-dev nodejs && rm -rf /var/lib/apt/lists/*
COPY files/etc/nginx/app.conf /etc/nginx/conf.d/
WORKDIR /srv/container/data
RUN cp  /usr/local/src/git-deps/node-restful-api-tutorial/* . && npm install
ARG API_PASS
RUN htpasswd -b -c /srv/container/data/.htpasswd junglescout ${API_PASS}
CMD ["entrypoint.sh"]
HEALTHCHECK --interval=5m --timeout=3s CMD curl localhost:3000 && curl localhost:8080
EXPOSE 8080
