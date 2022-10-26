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

PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" --instance-market-options  "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"|jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

echo -e "Private Ip address of the created machine is $PRIVATE_IP"

echo -e "Spot Instance ${COMPONENT} is ready"

echo -e "Creating Route53 record"

sed -e 's/PRIVATEIP/${PRIVATE_IP}/' -e 's/COMPONENT/${COMPONENT}/' r53.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id Z01423552ZMVW82NC77OX --change-batch file://r53.json |jq
