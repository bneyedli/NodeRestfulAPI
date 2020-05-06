#!/usr/bin/env bash

set -e -u -o pipefail

echo "Start nginx in background"
nginx&


echo "Wait for listening socket"
while true
do
  if ss -lnt | grep ":80 " > /dev/null
  then
    echo "Nginx is UP"
    break
  else
    echo "Nginx not listening, sleeping"
    sleep 1
  fi
done

echo "Curl localhost with sketchy UA: masscan"
curl -s -f -H "User-Agent: masscan" localhost > /dev/null

if test -f /var/log/modsec_audit.log
then
  echo "Modsecurity logfile exists"
else
  echo "Modsecurity logfile missing"
  exit 1
fi

if grep masscan /var/log/modsec_audit.log > /dev/null 
then
  echo "Sketchy UA Identified"
else
  echo "Logs missing for UA: masscan"
  exit 1
fi
