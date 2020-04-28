#!/usr/bin/env bash
set -e -u

echo "Build base image"
make purge-docker BUILD_TARGET=docker-ubuntu-base || true

echo "Build base web image"
make purge-docker BUILD_TARGET=docker-ubuntu-web || true

echo "Build app image"
make purge-docker BUILD_TARGET=docker-node-rest-api || true
