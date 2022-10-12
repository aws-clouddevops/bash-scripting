#!/bin/bash

set -e

source components/common.sh

COMPONENT=payment

# Calling Python Function

echo -n "Installing Python: "
yum install python36 gcc python3-devel -y &>> ${LOGFILE}
stat $?

USER_SETUP

DOWNLOAD_AND_EXTRACT

echo -n "Install Dependencies: "
cd /home/${FUSER}/${COMPONENT}/
pip3 install -r requirements.txt &>>${LOGFILE}
stat $?

USER_ID=$(id -u roboshop)
GROUP_ID=$(id -u roboshop)

echo -n "Updating the ${COMPONENT}.ini file: "
sed -i -e 's/^uid/ c uid=${USERID}/' -e 's/^gid/ c gid=${GROUPID}/' ${COMPONENT}.ini
stat $?