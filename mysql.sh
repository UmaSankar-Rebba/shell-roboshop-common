#!/bin/bash

source ./common.sh
USER_CHECK

dnf install mysql-server -y &>>$LOGS_FILES
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGS_FILES
VALIDATE $? "enabled mysqld"

systemctl start mysqld &>>$LOGS_FILES
VALIDATE $? "start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1