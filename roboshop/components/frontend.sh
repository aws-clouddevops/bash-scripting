#!/bin/bash

set -e # ensures your script will stop if any of the instruction fails

# source is an import command , it imports the code and runs locally

source components/common.sh

echo -n "Installing Nginx:"

yum install nginx -y  >> /tmp/frontend.log
systemctl enable nginx

echo -n "Starting Nginx:"
systemctl start nginx

echo -n "Downloading the Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
echo -n "Extracting the Zip File:"
unzip /tmp/frontend.zip  >> /tmp/frontend.log

mv frontend-main/* .
mv static/* .
echo -n "Performing Cleanup:"
rm -rf frontend-main README.md

echo -n "Configuring the Reverse Proxy:"
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx