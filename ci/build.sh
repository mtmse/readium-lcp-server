#!/bin/bash

# Helper script for building all images for multiple architectures
# NOTE: May not be possible on all types of machines
docker buildx bake --set *.platform=linux/amd64,linux/arm64
