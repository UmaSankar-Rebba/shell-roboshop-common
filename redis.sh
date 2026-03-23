#!/bin/bash

source ./common.sh

USER_CHECK

dnf module disable redis -y &>>$LOGS_FILES
VALIDATE $? "disable deafault version of redis"

dnf module enable redis:7 -y &>>$LOGS_FILES
VALIDATE $? "enable redis 7 version"

dnf install redis -y &>>$LOGS_FILES
VALIDATE $? "install redis "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf
VALIDATE $? "OKAY"

systemctl enable redis &>>$LOGS_FILES
VALIDATE $? "enable redis"

systemctl start redis &>>$LOGS_FILES
VALIDATE $? "start rediss"