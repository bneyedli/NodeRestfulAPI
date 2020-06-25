#!/usr/bin/env bash

set -e -u -o pipefail

NGINX_VERSION=${1}
MODSEC_VERSION=${2}
MODSEC_NGINX_VERSION=${3}

echo "Build ModSecurity"
cp -r /usr/local/src/ModSecurity /opt/src/
cd /opt/src/ModSecurity 
test -f ./configure || sh build.sh 
if [[ ! -f ./configure ]]
then
  find . > files-pre-build.txt
  sh build.sh 
  find . > files-post-build.txt
fi
./configure --bindir=/usr/local/bin
find . > files-pre-cfg.txt
echo "Make"
make
find . > files-post-make.txt
echo "Patch Makefile with local additions"
patch /opt/src/ModSecurity/Makefile < /usr/local/src/ModSecurity/Makefile-ModSecurity.patch
echo "Build ModSecurity package"
checkinstall -y --pkgname libmodsecurity --pkgversion ${MODSEC_VERSION} \
  make install
mv  /opt/src/ModSecurity/libmodsecurity_${MODSEC_VERSION}-1_amd64.deb /srv/artifacts
echo -e "Done.\n\n"

echo "Build and install ModSecurity Nginx Connector"
mkdir -p /etc/nginx/modules/
cd /opt/src/
tar xzvf /usr/local/src/nginx-${NGINX_VERSION}.gz
cd /opt/src/nginx-${NGINX_VERSION}
./configure --modules-path=/etc/nginx/modules \
  --with-compat --add-dynamic-module=/usr/local/src/ModSecurity-nginx
make modules
checkinstall -y --requires libmaxminddb0 --requires libgeoip1 --requires libxml2 --pkgname libnginx-mod-security --pkgversion ${MODSEC_NGINX_VERSION} make install
mv /opt/src/nginx-${NGINX_VERSION}/libnginx-mod-security_${MODSEC_NGINX_VERSION}-1_amd64.deb /srv/artifacts
echo -e "Done.\n\n"
