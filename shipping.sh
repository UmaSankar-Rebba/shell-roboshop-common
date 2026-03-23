#!/bin/bash

source ./common.sh
USER_CHECK
APP_SETUP
JAVA_SETUP
SYSTEM_CTL

dnf install mysql -y &>>$LOGS_FILES
VALIDATE $? "installing mysql"

mysql -h $MYSQL_HOST -uroot -pRoboshop@1 -e 'use cities'
if [ $? -ne 0 ]; then

    mysql -h $MYSQL_HOST -uroot -pRoboshop@1 < /app/db/schema.sql &>>$LOGS_FILES
    mysql -h $MYSQL_HOST -uroot -pRoboshop@1 < /app/db/app-user.sql &>>$LOGS_FILES
    mysql -h $MYSQL_HOST -uroot -pRoboshop@1 < /app/db/master-data.sql &>>$LOGS_FILES
    VALIDATE $? "Loaded data into MySQL"
else
    echo -e "data is already loaded ... $Y SKIPPING $N"
fi
APP_RESTART