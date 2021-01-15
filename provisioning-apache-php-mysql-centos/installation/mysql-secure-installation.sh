#!/bin/bash

## The installer generated a temporary password for MySQL root user and copied to log file.
## You can find this password using the below command.
MYSQL_NOW_PASSWORD=$(sudo grep "A temporary password" /var/log/mysqld.log  | perl -nle 'm/localhost: (.*)/; print $1;' )

# Not required in actual script
MYSQL_NEW_PASSWORD=Cl3ar$ki3$

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter password for user root:\"
send \"$MYSQL_NOW_PASSWORD\r\"
expect \"New password:\"
send \"$MYSQL_NEW_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$MYSQL_NEW_PASSWORD\r\"
expect \"Change the password for root ? ((Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"New password:\"
send \"$MYSQL_NEW_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$MYSQL_NEW_PASSWORD\r\"
expect \"Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

# Create blog database
mysql -u root -p -e "create database blog;"
expect "Enter password: "
send $MYSQL_NEW_PASSWORD