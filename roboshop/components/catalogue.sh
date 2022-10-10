#!/bin/bash

set -e

source components/common.sh

COMPONENT=catalogue
FUSER=roboshop

echo -n "Confirgire yum Repos for modejs: " 
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Installing Nodejs: "
yum install nodejs -y  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Adding ${FUSER} user: "
id ${FUSER} || useradd ${FUSER}  >> /tmp/${COMPONENT}.log # creates user only if the user does not exist
stat $?

echo -n "Downloading ${COMPONENT}: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Cleanup of old ${COMPONENT} content: "
rm -rf /home/${FUSER}/${COMPONENT} >> /tmp/${COMPONENT}.log
stat $?

echo -n "Extracting ${COMPONENT} content: "
cd /home/${FUSER}/  >> /tmp/${COMPONENT}.log
unzip -o /tmp/${COMPONENT}.zip  >> /tmp/${COMPONENT}.log  &&  mv ${COMPONENT}-main ${COMPONENT}  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Chnaging the ownership to ${FUSER}: "
chown -R $FUSER:$FUSER $COMPONENT/
stat $?

echo -n "Installing ${COMPONENT} Dependencies: "
cd $COMPONENT && npm install  &>> /tmp/${COMPONENT}.log
stat $?

echo -n "Configuring the Systemd files: "
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${FUSER}/${COMPONENT}/systemd.service
mv /home/${FUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting the service: "
systemctl daemon-reload &>> /tmp/${COMPONENT}.log
systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
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

