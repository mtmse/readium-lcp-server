#!/bin/bash

# Retrieve the version from api/common_server.go
APP_VERSION=$(grep "Software_Version = "$1"" ../api/common_server.go | awk '{print $3}' | sed 's/"//g')

if [ -z "$APP_VERSION" ]; then
  echo "Error: Could not find version in api/common_server.go"
  exit 1
fi

if ! command -v yq &> /dev/null
then
    echo "yq could not be found, please install it"
    exit 1
fi

yq eval ".appVersion = \"$APP_VERSION\"" -i helm-chart/Chart.yaml
yq eval ".version = \"$APP_VERSION\"" -i helm-chart/Chart.yaml
