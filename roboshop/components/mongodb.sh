#!/bin/bash

source components/common.sh

COMPONENT=mongodb

echo -n "Configuring the MongoDb repo: "
curl -s -o /etc/yum.repos.d/mon${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $? # calling function with variable

echo -n "Installing ${COMPONENT}: "
yum install -y mongodb-org >> /tmp/${COMPONENT}.log
stat $?

echo -n "updating the $COMPONENT config: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Starting ${COMPONENT} service: "
systemctl enable mongod >> /tmp/${COMPONENT}.log
systemctl start mongod
stat $?

echo -n "Downloading the Schema: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Extracting the ${COMPONENT} schema: "
cd /tmp && unzip -o mongodb.zip >> /tmp/${COMPONENT}.log
stat $?

echo -n "Injecting the ${COMPONENT} Schema: "
cd mongodb-main
mongo < catalogue.js >> /tmp/${COMPONENT}.log
mongo < users.js >> /tmp/${COMPONENT}.log
stat $?

echo -n -e "\n \n****_____${COMPONENT} Configuration Completed_____*****\n"