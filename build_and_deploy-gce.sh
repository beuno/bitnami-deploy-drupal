#! /bin/bash
set -ex

# What zone to build and deploy in
ZONE=us-central1-f

# Log into gcloud with the service account
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

# Build the image
packer build -var "zone=$ZONE" -var "custom_image_name=$BUILD_TAG" deployment/drupal-gce.packer

# The name of the instance to launch, BUILD_TAG is Jenkin's job ID and name
SERVICE=$BUILD_TAG

# Create and boot the instance
gcloud compute instances create $SERVICE \
  --project bitnamigcetest2 \
  --image $SERVICE \
  --zone $ZONE \
  --tags http-server
