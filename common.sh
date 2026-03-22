#!/bin/bash
USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILES="/var/log/shell-roboshop/$0.log"
R="\e[31m"
G="\e[32m"
C="\e[36m"
N="\e[0m"
SCRIPT_DIR=$PWD
MYSQL_HOST=mysql.rebba.online

mkdir -p $LOGS_FOLDER

echo "$(date "+%y-%m-%d") | Script started at time $(date)"

USER_CHECK(){
    if [ $USER_ID -ne 0 ]; then
     echo -e " $R You dont have permission to access this operation $N.$G Please contact sudo Admin $N"
     exit 1
fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
     echo -e "$R "$(date +%y-%m-%d %H:%M:%S)" $2 is Failure $N" | tee -a $LOGS_FILES
     exit 1
    else
     echo -e "$G "$(date +%y-%m-%d %H:%M:%S)" $2 is Success $N" | tee -a $LOGS_FILES
    fi
}

NODEJS_SETUP(){
    dnf module disable nodejs -y &>>$LOGS_FILES
    VALIDATE $? "Disabling nodejs default version"

    dnf module enable nodejs:20 -y&>>$LOGS_FILES
    VALIDATE $? "ENABLE NODEJS 20 version"

    dnf install nodejs -y&>>$LOGS_FILES
    VALIDATE $? "Installing nodejs"

    npm install &>>$LOGS_FILES
    VALIDATE $? "INstalling dependiens"
}

echo "$(date "+%y-%m-%d") | Script ended at time $(date)"
