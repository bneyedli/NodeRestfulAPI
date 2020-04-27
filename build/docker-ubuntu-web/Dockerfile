ARG DOCKER_DISTRIBUTION
ARG DOCKER_RELEASE
FROM ${DOCKER_DISTRIBUTION}:${DOCKER_RELEASE}
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y install --no-install-recommends nginx-light apache2-utils && rm -rf /var/lib/apt/lists/*
