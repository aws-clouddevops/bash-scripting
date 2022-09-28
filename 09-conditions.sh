#!/bin/bash

# when ever we use case we close it with esac
# syntax of case
# case $var in
#   cond1)
#        command1 ;;
#   cond2)
#        command2;;
#   *)
#       exz;;;

# esac

ACTION=$1

case $ACTION in
    start)
        echo "starting xyz Service"
        ;;
    stop)
        echo "Stopping XYZ Service"
        ;;
    restart)
        echo "Restarting XYZ Service"

esac