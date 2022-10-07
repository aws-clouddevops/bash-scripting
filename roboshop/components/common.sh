# validating if the user has root access

ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo -e "\e[31m Try executing the script with a sudo access \e[0m"
    exit 1
fi