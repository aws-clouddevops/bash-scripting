#!/bin/bash

# sample() {
    # echo "hai from the sample function"
    # echo "I will be printing uptime"
   # uptime
# }

# sample

# Defining the function stat

stat(){
    echo "load average on the system from last 1 min is : $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"
    echo "Number of users signed in is : $(who|wc -l)"
    echo "Stat Function is completed bye"

}

# calling the function
stat
sleep 5 # the function pauses for 5 sec
stat
sleep 5