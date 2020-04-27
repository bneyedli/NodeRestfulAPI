#!/usr/bin/env bash

set -u -e -o pipefail

cd /srv/container/data
npm start &
nginx -t -c /etc/nginx/nginx.conf 
nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
