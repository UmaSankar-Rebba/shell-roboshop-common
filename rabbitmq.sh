#!/bin/bash

source ./common.sh

USER_CHECK

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Repo copied"

dnf install rabbitmq-server -y &>>$LOGS_FILES
VALIDATE $? "Installing rabbitmq"

systemctl enable rabbitmq-server &>>$LOGS_FILES
VALIDATE $? "enable rabbitmq"

systemctl start rabbitmq-server &>>$LOGS_FILES
VALIDATE $? "Start rabbitmq"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "created user and gain permissions"