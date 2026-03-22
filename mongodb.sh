#!/bin/bash

source ./common.sh

USER_CHECK

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILES
VALIDATE $? "Copying mongo repo"

MONGODB_CHECKUP

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod &>>$LOGS_FILES
VALIDATE $? "Restart mongodb"