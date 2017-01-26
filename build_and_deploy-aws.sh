#! /bin/bash
set -ex

# What zone to build and deploy in
ZONE=us-east-1

# Log into aws
#"$GOOGLE_APPLICATION_CREDENTIALS"

# Build the image
packer build -var "zone=$ZONE" -var "custom_image_name=$BUILD_TAG" deployment/drupal-aws.packer

# The name of the instance to launch, BUILD_TAG is Jenkin's job ID and name
SERVICE=$BUILD_TAG

# Create and boot the instance
aws ec2 run-instances \
  --image-id $SERVICE \
  --count 1 \
  --instance-type m3.medium
