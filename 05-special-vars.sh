#!/bin/bash

# when every simgle quotes are used it kills the pow

# Here are the special variables

# $0            : This gives you the name of the script you are running
# $1 to $9      : You can a maximum of 9 variables from command line when you are running the script
# $*            : Prints all supplied variables in script
# $@            : Prints all supplied variables in script
# $#            : Prints number of variables
# $$            : Prints Process id of the script
# $?            : Gives you the exit code of the previous commands

echo -e  "script name that you're running is \e[34m $0 \e[0m"

a=10
b=$1     # $1 first argument passed to the script
c=$2
d=$3

echo value of a is : $a
echo value of b is : $b
echo valus of c is : $c
echo valus id d is : $d


# sh scriptname.sh 100 200 300
# sh scriptname.sh $1  $2  $3

echo "Printing the variables that we have passed in the script $*"
echo "Printing the variables that we have passed in the script $@"
echo "Printing the number of variables in the script $#"
echo "Printing the PID of the script that we are running $$"
