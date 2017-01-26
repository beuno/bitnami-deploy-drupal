#! /bin/bash
set -ex

# What zone to build and deploy in
ZONE="us-east-1"
INSTANCE_COUNT="1"
INSTANCE_TYPE="m3.medium"

# Build the image and save the output to a log file
packer build -machine-readable -var "zone=$ZONE" -var "custom_image_name=$BUILD_TAG" -var "aws_access_key=$AWS_ACCESS_KEY_ID" -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" deployment/drupal-aws.packer | tee packer-build-$BUILD_TAG.log

# Extract the ami_id of the built image from the log
AMI_ID=$(grep 'artifact,0,id' packer-build-$BUILD_TAG.log | cut -d, -f6 | cut -d: -f2)

# Create and boot the instance
# You need to have AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env vars or
# a ~/.aws/* config set up for this to work
aws ec2 run-instances \
  --image-id $AMI_ID \
  --count $INSTANCE_COUNT \
  --instance-type $INSTANCE_TYPE \
  --region $ZONE
