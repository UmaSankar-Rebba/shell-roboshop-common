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
     echo -e "$R "$(date "+%y-%m-%d %H:%M:%S")" $2 is Failure $N" | tee -a $LOGS_FILES
     exit 1
    else
     echo -e "$G "$(date "+%y-%m-%d %H:%M:%S")" $2 is Success $N" | tee -a $LOGS_FILES
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

APP_SETUP(){
    id roboshop
if [ $? -ne 0 ]; then {
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE $? "Creating syst  em user"
}
else
 echo -e "$C User already exists skipping $N"
fi
}

SYSTEM_CTL(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Created systemctl service"
    systemctl daemon-reload
    systemctl enable $app_name
    systemctl start $app_name
}
#Downloading app
mkdir -p /app
VALIDATE $? "creating app directory"

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOGS_FILES
VALIDATE $? "Downloading catalogue code"

cd /app
VALIDATE $? "Changing directory"

rm -rf /app/*
VALIDATE $? "Removing existing data in the folder"

unzip /tmp/$app_name.zip &>>$LOGS_FILES
VALIDATE $? "Unzip the code file"

echo "$(date "+%y-%m-%d") | Script ended at time $(date)"
