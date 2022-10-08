#!/bin/bash

set -e

source components/common.sh

COMPONENT=catalogue
FUSER=roboshop

echo -n "Confirgire yum Repos for modejs: " 
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
stat $?

echo -n "Installing Nodejs: "
yum install nodejs -y  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Adding ${FUSER} user: "
useradd roboshop
stat $?

echo -n "Downloading ${COMPONENT}: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Cleanup of old ${COMPONENT} content: "
rm -rf /home/${FUSER}/${COMPONENT} >> /tmp/${COMPONENT}.log

echo -n "Extracting ${COMPONENET}"
cd /home/{$FUSER}/  >> /tmp/${COMPONENT}.log
unzip -o /tmp/${COMPONENET}.zip  >> /tmp/${COMPONENT}.log  &&  mv ${COMPONENT}-main ${COMPONENT}  >> /tmp/${COMPONENT}.log$ cd /home/roboshop/catalogue
stat $?

echo -n "Installing ${COMPONENT} Dependencies: "
npm install  >> /tmp/${COMPONENT}.log
stat $?

# $ vim systemd.servce

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

# Ref Log:
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}
# vim /etc/nginx/default.d/roboshop.conf

# systemctl restart nginx

