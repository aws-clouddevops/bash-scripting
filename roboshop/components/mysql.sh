#!/bin/bash

source components/common.sh

COMPONENT=mysql
LOGFILE=/tmp/robot.log
MYSQL_PASSWORD=asdfasdfasdf

echo -n "Configuring the $COMPONENT repo: "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/${COMPONENT}.repo &>> ${LOGFILE}
stat $? 

echo -n "Installing $COMPONENT :"
yum install mysql-community-server -y &>> ${LOGFILE}
stat $? 

echo -n "Starting ${COMPONENT} : "
systemctl enable mysqld  &>> ${LOGFILE}
systemctl start mysqld &>> ${LOGFILE}
stat $? 


echo -n "Fetching the default root password: "
DEFAULT_ROOT_PASSWORD=$(sudo grep temp /var/log/mysqld.log | head -n 1 | awk -F " " '{print $NF}')
stat $? 

#If the exit code is non-zero then only I want to execute, if not, I would like to skip

echo show databases | mysql -uroot -pRoboShop@1 &>> ${LOGFILE}
if [ $? -ne 0 ]; then 
    echo -n "Reset Root Password: "
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}" &>> ${LOGFILE}
    if [ -z "${MYSQL_PASSWORD}" ]; then
    echo "Need MYSQL_PASSWORD env variable"
    exit 1
fi
    stat $? 
fi 

echo show plugins | mysql -uroot -pRoboShop@1 | grep validate_password &>> ${LOGFILE}
if [ $? -eq 0 ] ; then 
    echo -n "Uninstalling the password validate plugin :"
    echo  "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1  &>> ${LOGFILE}
    stat $? 
fi 