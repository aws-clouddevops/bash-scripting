#!/bin/bash


# AMI_ID=ami-00ff427d936335825
# If $ is empty or $1 is not supplied, then I want to mark it as follows


if [ -z "$1" ]; then
    echo -e "\e[31m Machine Name is Missing \e[0m"
    exit 1
fi


COMPONENT=$1
SGID="sg-0b01a705773cff66c"

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7"  | jq '.Images[].ImageId' | sed -e 's/"//g')
echo "This is the AMI id we are using $AMI_ID"

aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" --instance-market-options  "MarketType=spot, SpotOption={"SpotInstanceType": "persistant","InstanceInterruptionBehaviour"="stop"}"|jq