###cd /vagrant

# Run the commands below to add required repositories
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Need this for automating mysql_secure_installation
yum -y install expect

# We can now enable PHP 7.4 Remi repository and install PHP 7.4 on CentOS 7
yum -y install yum-utils
yum-config-manager --enable remi-php74

# Update yum repositories
yum -y update

# Install Apache
yum install -y httpd

# Download MySQL installation file from Yum Repository
rpm -Uvh  https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm

# Install MySQL
yum install -y mysql-server

# Install PHP
yum install -y php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json

# Or try it like this
#yum install -y php php-{cli,fpm,mysqlnd,zip,devel,gd,mcrypt,mbstring,curl,xml,pear,bcmath,json}

# List installed packages
#yum list installed

# View enabled PHP modules
#php --modules

# Check versions
#php --version

# Check Apache version
#httpd -v

# Check MySQL version
#mysql -V

# Installing Composer
yum install -y php-zip wget unzip
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Find the Tests folder
## cd /vagrant/wp-content/plugins/yaptool/Tests

# Install PHP packages for PHP Unit Tests
composer update

## Start Servers
# Start Apache Web Server
systemctl enable httpd.service
systemctl start httpd.service
# Start MySQL Database Server
systemctl enable mysqld.service
systemctl start mysqld.service