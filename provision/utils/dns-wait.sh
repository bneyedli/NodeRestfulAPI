#!/usr/bin/env bash
set -e -u -o pipefail

host=${1}
ttl=$(dig ${host} | grep -v ^\; | sed '/^$/d' | awk '{ print $2 }')

wait=$(( ttl +1 ))

#Ensure TTL expires before we query for host
if (( wait < 60 ))
then
  >&2 echo "Waiting for: ${wait} seconds to ensure clean cache"
  sleep ${wait}
fi

dig +short ${host}
