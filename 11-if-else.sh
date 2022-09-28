#!/bin/bash

ACTION=$1 # expects value from command line

if [ "$ACTION" = "start" ] ; then # Delaing with strings hence using '=' if we use numbers we use 'eq for equal to'
    echo "Selected choice is start"

else 
    echo "Only valid option is start"
fi