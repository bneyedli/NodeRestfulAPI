#!/usr/bin/env bash

set -u -e -o pipefail

INSPEC_PROFILE=${1}

inspec supermarket exec ${INSPEC_PROFILE} --reporter=json-min 2> /dev/null
