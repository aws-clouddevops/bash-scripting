#!/bin/bash

set -e # ensures your script will stop if any of the instruction fails

# source is an import command , it imports the code and runs locally

source components/common.sh

echo -n "Installing Nginx: "

yum install nginx -y  >> /tmp/frontend.log
systemctl enable nginx

echo -n "Starting Nginx: "
systemctl start nginx
stat $?

echo -n "Downloading the Code: "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

cd /usr/share/nginx/html
rm -rf *
echo -n "Extracting the Zip File: "
unzip  -o /tmp/frontend.zip  >> /tmp/frontend.log
stat $?

mv frontend-main/* .
mv static/* .
echo -n "Performing Cleanup: "
rm -rf frontend-main README.md
stat $?

echo -n "Configuring the reverse proxy: "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?


for component in catalogue user cart shipping payment ; do
echo -n "Updating the proxy file: "
sed -i -e "/${component}/s/localhost/${component}.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
stat $?
done

echo -n "Restarting Nginx: "
systemctl restart nginx
stat $?