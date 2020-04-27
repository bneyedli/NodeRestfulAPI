ARG UBUNTU_RELEASE
FROM ubuntu:${UBUNTU_RELEASE}
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y upgrade && apt -y --no-install-recommends install gnupg2 apt-transport-https ca-certificates curl git ruby ruby-dev make gcc g++ localepurge && rm -rf /var/lib/apt/lists/*
ARG GEM_SOURCE_URL
ARG INSPEC_VERSION
RUN gem install --no-document --source ${GEM_SOURCE_URL} inspec-bin:${INSPEC_VERSION} rdoc
RUN inspec --chef-license=accept      
#Make compliance checks happy
RUN apt -y purge ruby-dev gcc g++ && rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/UMASK.*/UMASK\t027/' -e 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS\t60/' -e 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS\t7/' /etc/login.defs
