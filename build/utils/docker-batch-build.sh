#!/usr/bin/env bash
set -e -u

echo "Build base image"
make build test BUILD_TARGET=docker-ubuntu-base

echo "Build base web image"
make build test BUILD_TARGET=docker-ubuntu-web

echo "Build app image"
make build test publish BUILD_TARGET=docker-node-rest-api
