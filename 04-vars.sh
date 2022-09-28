#!/bin/bash

a=10
# a is 10 and is a integer

b=abc
# abc is string

### No datatypes in bash scripting, Everything is a string by default

echo value of a is : $a
echo ${a}
echo "${b}"

# all of them mean the same to print the value

echo value of d is : $d

# when the data is not mentioned its a null value

# what ever we are running on xshell it runs on heat memoty when some value is declared  on export
# its the value till the machine is up once we exit and relogin the valu has to be declared again
# export will only be considered when its not declafred locally
# local values have high priority
# variables declared in the program have high priority than those declared on export

DATE=2022-09-05
echo "Good Morning, Todays date is $DATE"