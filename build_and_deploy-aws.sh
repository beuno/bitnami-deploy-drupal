#! /bin/bash
set -ex

# What zone to build and deploy in
ZONE=us-east-1

# Build the image and save the output to a log file
packer build -machine-readable -var "zone=$ZONE" -var "custom_image_name=$BUILD_TAG" -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY" deployment/drupal-aws.packer | tee packer-build-$BUILD_TAG.log

# Extract the ami_id of the built image from the log
AMI_ID=$(grep 'artifact,0,id' packer-build-$BUILD_TAG.log | cut -d, -f6 | cut -d: -f2)

# The name of the instance to launch, BUILD_TAG is Jenkin's job ID and name
SERVICE=$BUILD_TAG

# Create and boot the instance
aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type m3.medium

