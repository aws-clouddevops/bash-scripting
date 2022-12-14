# validating if the user has root access

ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo -e "\e[31m Try executing the script with a sudo access \e[0m"
    exit 1
fi

stat() {
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failure. Look for the logs \e[0m"
    fi
}

FUSER=roboshop
LOGFILE=/tmp/robot.log

USER_SETUP() {

    echo -n "Adding ${FUSER} user: "
    id ${FUSER} &>> LOGFILE || useradd ${FUSER} >> /tmp/${COMPONENT}.log #creates user ony if in case user does not exist 
    stat $?
}

NODEJS() {
    echo -n "Confirgure yum Repos for nodejs: " 
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash  >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "Installing Nodejs: "
    yum install nodejs -y  >> /tmp/${COMPONENT}.log
    stat $?

    #calling Adding user function
    USER_SETUP

    #callong download and extract function
    DOWNLOAD_AND_EXTRACT

    echo -n "Installing ${COMPONENT} Dependencies: "
    cd $COMPONENT && npm install  &>> /tmp/${COMPONENT}.log
    stat $?

    # Calling configuration service

    CONFIG_SVC
}

CONFIG_SVC() {

    echo -n "Configuring the Systemd files: "
    sed -i -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/${FUSER}/${COMPONENT}/systemd.service
    mv /home/${FUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
    stat $?

    echo -n "Starting the service: "
    systemctl daemon-reload &>> /tmp/${COMPONENT}.log
    systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
    systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
    stat $?
}

DOWNLOAD_AND_EXTRACT() {

    echo -n "Downloading ${COMPONENT}: "
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"  >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "Cleanup of old ${COMPONENT} content: "
    rm -rf /home/${FUSER}/${COMPONENT} >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "Extracting ${COMPONENT} content: "
    cd /home/${FUSER}/  >> /tmp/${COMPONENT}.log
    unzip -o /tmp/${COMPONENT}.zip  >> /tmp/${COMPONENT}.log  &&  mv ${COMPONENT}-main ${COMPONENT}  >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "Changing the ownership to ${FUSER}: "
    chown -R $FUSER:$FUSER $COMPONENT/
    stat $?

}

MAVEN() {

    echo -n "Installing Maven: "
    yum install maven -y  &>> ${LOGFILE}
    stat $?    

    USER_SETUP

    DOWNLOAD_AND_EXTRACT

    echo -n "Generating the artifacts: "
    cd /home/${FUSER}/${COMPONENT}
    mvn clean package &>>${LOGFILE}
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
    stat $?

    CONFIG_SVC

}

PYTHON() {

   echo -n "Installing Python: "
    yum install python36 gcc python3-devel -y &>> ${LOGFILE}
    stat $?

    USER_SETUP

    DOWNLOAD_AND_EXTRACT

    echo -n "Install Dependencies: "
    cd /home/${FUSER}/${COMPONENT}/
    pip3 install -r requirements.txt &>>${LOGFILE}
    stat $?

    USER_ID=$(id -u roboshop)
    GROUP_ID=$(id -u roboshop)

    echo -n "Updating the ${COMPONENT}.ini file: "
    sed -i -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c gid=${GROUP_ID}" ${COMPONENT}.ini
    stat $?

    CONFIG_SVC 
}