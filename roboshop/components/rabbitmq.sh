#!/bin/bash

source components/common.sh

COMPONENTS=rabbitmq

echo -n "Installing and configuring Erland Dependencies: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> ${LOGFILE}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> ${LOGFILE}
stat $?

echo -n "Installing Rabbitmq: "
yum install rabbitmq-server -y &>> ${LOGFILE}
stat $?

echo -n "Starting the ${COMPONENT}: "
systemctl enable rabbitmq-server &>> ${LOGFILE}
systemctl start rabbitmq-server &>> ${LOGFILE}
stat $?

rabbitmqctl list_users | grep roboshop &>> ${LOGFILE}
if [ $? -ne 0 ]; then
    echo -n "Creating ${COMPONENT} Application User: "
    rabbitmqctl add_user roboshop roboshop123 &>> ${LOGFILE}
    stat $?
fi

echo -n "Configuting the ${COMPONENT} ${FUSER} Permission"
rabbitmqctl set_user_tags roboshop administrator &>> ${LOGFILE} &&  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${LOGFILE}
stat $?