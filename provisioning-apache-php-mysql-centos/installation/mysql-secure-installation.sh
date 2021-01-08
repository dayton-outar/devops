#!/bin/bash

## The installer generated a temporary password for MySQL root user and copied to log file.
## You can find this password using the below command.
MYSQL_NOW_PASSWORD=$(sudo grep "A temporary password" /var/log/mysqld.log  | perl -nle 'm/localhost: (.*)/; print $1;' )

# Not required in actual script
MYSQL_NEW_PASSWORD=Cl3ar$ki3$

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL_NOW_PASSWORD\r\"
expect \"Change the root password?\"
send \"$MYSQL_NEW_PASSWORD\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"