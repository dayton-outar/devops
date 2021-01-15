cd /vagrant
# Copy all wordpress files into apache home directory
cp -r . /var/www/html

# Find apache home directory
cd /var/www/html

# Give web server guest user ownership of wp-contnent folder. For Debian/Ubuntu the guest user is www-data
chown -R apache wp-content

# Set permissions for folders to allow content to be created and modified in directory
chmod 777 wp-content/plugins
chmod 777 wp-content/themes