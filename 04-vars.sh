#!/bin/bash

a=10
# a is 10 and is a integer

b=abc
# abc is string

### No datatypes in bash scripting, Everything is a string by default

echo value of a is : $a
echo $(a)
echo "$(b)"

# all of them mean the same to print the value