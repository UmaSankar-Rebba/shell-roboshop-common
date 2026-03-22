#!/bin/bash

source ./common.sh

USER_CHECK

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILES
VALIDATE $? "Copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILES
VALIDATE $? "Installing Mongodb"

systemctl enable mongod &>>$LOGS_FILES
VALIDATE $? "Enabling Mongodb"

systemctl start mongod &>>$LOGS_FILES
VALIDATE $? "Starting Mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod &>>$LOGS_FILES
VALIDATE $? "Restart mongodb"