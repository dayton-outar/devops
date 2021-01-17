cd /vagrant
# Copy all wordpress files into apache home directory
cp -r . /var/www/html

# Find apache home directory
cd /var/www/html

# Give web server guest user ownership of wp-contnent folder. For Debian/Ubuntu the guest user is www-data
chown -R apache wp-content

# Set permissions for folders to allow content to be created and modified in directory
# Meaning of the permission numbers: https://www.maketecheasier.com/file-permissions-what-does-chmod-777-means/
chmod 755 wp-content/plugins
chmod 755 wp-content/themes