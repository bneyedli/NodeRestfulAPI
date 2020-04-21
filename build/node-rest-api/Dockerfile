ARG DOCKER_DISTRIBUTION
ARG DOCKER_RELEASE
FROM ${DOCKER_DISTRIBUTION}:${DOCKER_RELEASE}
COPY git-deps /usr/local/src/git-deps
COPY keys /usr/local/share/keys
ENV DEBIAN_FRONTEND noninteractive
ARG NODE_VERSION
RUN apt update && apt -y upgrade && apt -y install gnupg2 apt-transport-https ca-certificates
RUN echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $(grep DISTRIB_CODENAME /etc/lsb-release|cut -d= -f2) main" > /etc/apt/sources.list.d/nodesource.list
RUN apt-key add /usr/local/share/keys/nodesource.gpg.key
#TODO: --no-install-recommends -- localepurge -- cache cleanup
RUN apt update && apt -y install libxml2-dev libffi-dev git ruby ruby-dev nodejs make gcc g++
RUN cd /usr/local/src/git-deps/node-restful-api-tutorial && npm install
ARG GEM_SOURCE_URL
ARG INSPEC_VERSION
RUN gem install --no-document --source ${GEM_SOURCE_URL} inspec-bin:${INSPEC_VERSION} rdoc
RUN inspec --chef-license=accept      
RUN sed -i -e 's/UMASK.*/UMASK\t027/' -e 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS\t60/' -e 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS\t7/' /etc/login.defs
