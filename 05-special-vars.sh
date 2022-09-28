#!/bin/bash

Here are the special variables

# $0            : This gives you the name of the script you are running
# $1 to $9      : You can a maximum of 9 variables from command line when you are running the script
# $*
$@
$#

echo  "script name that you're running is $0"

a=10
b=$1

echo value of a is : $a
echo value of b is : $b

# sh scriptname.sh 100 200 300
# sh scriptname.sh $1  $2  $3