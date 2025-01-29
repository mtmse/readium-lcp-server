#!/bin/sh
# Replace value in config.yaml using env variable
sed -i "s|public_base_url:.*|public_base_url: \"$PUBLIC_BASE_URL\"|" ./config.yaml
exec "$@"
