#!/bin/bash

# ACTION=$1 # expects value from command line
# if we use doubal quotes we need to use on both the sides of equal to
# if we use single quotes it kills the value of the variable

# Demo on if Else
# if [ "$ACTION" = "start" ]; then
#   echo "Selected choice is start"

# else
#   echo "Only valid option is start"
#fi

# Demo on else if
# Linux is always case sensitive if its start need to used start not Start
# if we want to use multiple options nees to use '-o' example [ "$ACTION" = "start" -o "$ACTION" = "Start" -o "$ACTION" = "START" ]

# if [ "$ACTION" = "start" ]; then
# echo "Starting ABC Service"

# elif [ "$ACTION" = "stop" ]; then
#   echo "Stopping ABC Service"
#    exit 1
# elif [ "$ACTION" = "restart" ]; then
#   echo "Restarting ABC Service"
#    exit 2
# else
# echo -e "Only valid options are \e[34m start or stop or restart only \e[0m"
#   exit 3
# fi

# using exit quotes give the error at the particlar place

ACTION=$1

if [ -z $ACTION ]; then
    echo "Argument is needed either Start or Stop or Restart"
    exit 1

fi
# -z, -n are used to restrict the code when invalid option is given
