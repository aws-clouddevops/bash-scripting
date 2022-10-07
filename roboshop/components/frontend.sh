#!/bin/bash

set -e # ensures your script will stop if any of the instruction fails

# source is an import command , it imports the code and runs locally

source components/common.sh

echo -n "Installing Nginx: "

yum install nginx -y
systemctl enable nginx

echo -n "Starting Nginx:"
systemctl start nginx
stat $?

echo -n "Downloading the Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

cd /usr/share/nginx/html
rm -rf *
unzip  -o /tmp/frontend.zip  >> /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -n "Restarting Nginx"
systemctl restart nginx
stat $?