#!/bin/bash

COMPONENT=$1

# AMI_ID=ami-00ff427d936335825
SGID="sg-0b01a705773cff66c"

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7"  | jq '.Images[].ImageId' | sed -e 's/"//g')
echo "This is the AMI id we are using $AMI_ID"

aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SGID} --tag-specification "ResourceType=instance,Tags[{Key=Name,Value=${COMPONENT}}]" |jq