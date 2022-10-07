#!/bin/bash

set -e # ensures your script will stop if any of the instruction fails

# source is an import command , it imports the code and runs locally

source components/common.sh

yum install nginx -y
systemctl enable ningx
systemctl start ningx
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx