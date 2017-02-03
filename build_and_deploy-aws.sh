#! /bin/bash
set -ex

# What zone to build and deploy in
ZONE="eu-central-1"
INSTANCE_COUNT="1"
INSTANCE_TYPE="m3.medium"

# Build the image and save the output to a log file
packer build -machine-readable -var "zone=$ZONE" -var "custom_image_name=$BUILD_TAG" -var "aws_access_key=$AWS_ACCESS_KEY_ID" -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" -var "image_name=$BUILD_TAG" deployment/drupal-aws.packer | tee packer-build-$BUILD_TAG.log

# Extract the ami_id of the built image from the log
AMI_ID=$(grep 'artifact,0,id' packer-build-$BUILD_TAG.log | cut -d, -f6 | cut -d: -f2)

# Create and boot the instance
# You need to have AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env vars or
# a ~/.aws/* config set up for this to work
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count $INSTANCE_COUNT \
  --instance-type $INSTANCE_TYPE \
  --key-name $INSTANCE_KEY_NAME \
  --region $ZONE \
  --security-groups $AWS_SEC_GROUPS \
  --output text \
  --query 'Instances[*].InstanceId')

aws ec2 create-tags --resources $INSTANCE_ID \
  --region $ZONE \
  --tags Key=Name,Value=$BUILD_TAG

# Wait for the instance to boot
while state=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --output text \
  --region $ZONE \
  --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "pending"; do
    sleep 1;
done; echo " $state"

# Public IP address of the instance 
IP_ADDRESS=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --output text \
  --region $ZONE \
  --query 'Reservations[*].Instances[*].PublicIpAddress')

