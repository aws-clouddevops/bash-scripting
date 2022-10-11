#!/bin/bash

set -e

source components/common.sh

COMPONENT=cart
FUSER=roboshop

echo -n "Confirgure yum Repos for nodejs: " 
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Installing Nodejs: "
yum install nodejs -y  >> /tmp/${COMPONENT}.log
stat $?

echo -n "Adding ${FUSER} user: "
id ${FUSER} >> /tmp/${COMPONENT}.log || useradd ${FUSER}  >> /tmp/${COMPONENT}.log # creates user only if the user does not exist
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
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/${FUSER}/${COMPONENT}/systemd.service
mv /home/${FUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting the service: "
systemctl daemon-reload &>> /tmp/${COMPONENT}.log
systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
stat $?