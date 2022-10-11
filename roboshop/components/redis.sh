#!/bin/bash

set -e

source components/common.sh

COMPONENT=redis

echo -n "Configuring the ${COMPONENT} Repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> /tmp/${COMPONENT}.log
stat $?

echo -n "Installing ${COMPONENT}: "
yum install redis-6.2.7 -y >> /tmp/${COMPONENT}.log
stat $?

echo -n "Whitelisting the ${COMPONENT} config: "
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf >> /tmp/${COMPONENT}.log
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf >> /tmp/${COMPONENT}.log
stat $?

echo -n "Starting $COMPONENT: "
systemctl daemon redis &>> /tmp/${COMPONENT}.log >> /tmp/${COMPONENT}.log
systemctl enable redis &>> /tmp/${COMPONENT}.log >> /tmp/${COMPONENT}.log
systemctl start redis  &>> /tmp/${COMPONENT}.log >> /tmp/${COMPONENT}.log
stat $?