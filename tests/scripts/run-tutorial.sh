#!/usr/bin/env bash -

# Setup any global variables
CLUSTER_NAME=testing-tests
gcloud config set compute/zone us-central1-f

# Run your tutorial
gcloud container clusters create $CLUSTER_NAME

# Cleanup on success
./test/scripts/cleanup.sh
