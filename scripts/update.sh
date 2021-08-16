#!/bin/bash

set -e

version=`curl --silent "https://api.github.com/repos/stedolan/jq/releases/latest" | jq .tag_name | xargs`
revision=`curl --silent "https://api.github.com/repos/stedolan/jq/commits/${version}" | jq .sha | xargs`
version=${version#"jq-"}
echo "latest stable version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "stable/Dockerfile"

#git add stable/Dockerfile
#git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}, revision: ${revision}"

set -e

version="master"
revision=`curl --silent "https://api.github.com/repos/stedolan/jq/commits/${version}" | jq .sha | xargs`
echo "latest edge version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "edge/Dockerfile"

#git add edge/Dockerfile
#git diff-index --quiet HEAD || git commit --message "updated edge to version ${version}, revision: ${revision}"
