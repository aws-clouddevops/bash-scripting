#!/bin/bash

ACTION=$1 # expects value from command line
# if we use doubal quotes we need to use on both the sides of equal to
# if we use single quotes it kills the value of the variable

# Demo on if Else
# if [ "$ACTION" = "start" ]; then
#   echo "Selected choice is start"

# else
#   echo "Only valid option is start"
#fi

# Demo on else if

if [ "$ACTION" = "start" ]; then
   echo "Starting ABC Service"

elif [ "$ACTION" = "stop" ]; then
    echo "Stopping ABC Service"

elif [ "$ACTION" = "restart" ]; then
    echo "Restarting ABC Service"

else
   echo "Only valid options are \e[34m start or stop or restart only \e[0m"
fi