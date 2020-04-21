#!/usr/bin/env bash

#-e -- fail on exit
#-u -- no unset vars
#-o pipefail -- if one chain in pipe fails all fail
set -e -u -o pipefail

#TODO: Sanitize inputs
#Take image as first positional arg and all else for tags
#Split on colon of first argument and assign values to array
DOCKER_META_SOURCE=(${1/:/ })
DOCKER_TAGS=${@:2}

DOCKER_SOURCE_IMAGE=${DOCKER_META_SOURCE[0]:-}
DOCKER_SOURCE_TAG=${DOCKER_META_SOURCE[1]:-}

#Fail if any var is empty and print usage
if [[ -z ${DOCKER_SOURCE_IMAGE} || -z ${DOCKER_SOURCE_TAG} || -z ${DOCKER_TAGS} ]]
then
  echo "Usage: ${0} DOCKER_SOURCE_IMAGE:SOURCE_TAG TAG1 TAG2..."
else
  >&2 echo -e "Image: ${DOCKER_SOURCE_IMAGE} Tags: ${DOCKER_TAGS}"
fi

#Iterate over tags and apply
for tag in ${DOCKER_TAGS}
do
  #Print to stderr in case we want to manipulate stdin
  >&2 echo -e "\tTagging: ${DOCKER_SOURCE_IMAGE}:${DOCKER_SOURCE_TAG} tag: ${tag}"
  docker tag ${DOCKER_SOURCE_IMAGE}:${DOCKER_SOURCE_TAG} ${DOCKER_SOURCE_IMAGE}:${tag}
done
