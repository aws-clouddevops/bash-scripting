#!/bin/bash

ID=$(id -u)

if [ $ID -eq 0 ]; then
    echo "Excecuting httpd installation"
    yum install httpd -y

else
    echo -e "\e[31m Try executing the script with a sudo access \e[0m"

fi