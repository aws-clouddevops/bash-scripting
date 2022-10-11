#!/bin/bash

set -e

source components/redis.sh

COMPONENT=redis

echo -n "Configuring the ${COMPONENT} Repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing ${COMPONENT}: "
yum install redis-6.2.7 -y >> /tmp/${COMPONENT}.log
stat $?



# vim /etc/redis.conf
# vim /etc/redis/redis.conf
# 127.0.0.1 to 0.0.0.0

# systemctl enable redis
# systemctl start redis
# systemctl status redis -l