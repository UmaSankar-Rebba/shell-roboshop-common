#!/bin/bash

source ./common.sh

USER_CHECK

dnf module list nginx &>>$LOGS_FILES
VALIDATE $? "Lists the nginx"

dnf module disable nginx -y &>>$LOGS_FILES
VALIDATE $? "disable the default version of nginx"

dnf module enable nginx:1.24 -y &>>$LOGS_FILES
VALIDATE $? "enable the 1.24 version of nginx"

dnf install nginx -y &>>$LOGS_FILES
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGS_FILES
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGS_FILES
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "removing default nginx content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "Downloading frontend content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzipping the code"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

systemctl restart nginx &>>$LOGS_FILES
VALIDATE $? "restart nginx"