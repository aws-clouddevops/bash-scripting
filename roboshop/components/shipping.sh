#!/bin/bash

set -e

source components/common.sh

COMPONENT=shipping
LOGFILE=/tmp/robot.log

echo -n "Installing Maven: "
yum install maven -y  &>> ${LOGFILE}
stat $?

#Creates the repository
USER_SETUP

DOWNLOAD_AND_EXTRACT
#Downloads and extracts 

echo -n "Generating the artifacts: "
cd /home/${FUSER}/${COMPONENT}
mvn clean package &>>${LOGFILE}
mv target/shipping-1.0.jar shipping.jar
stat $?

# Calling the svc setup
CONFIG_SVC



