#!/bin/sh

# Advice user to run script with sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Start the MySQL server so that you can run mysql_secure_installation.
service mysqld start

# Run mysql_secure_installation
echo -e "\nn\ny\ny\ny\ny" | mysql_secure_installation

# Install Wordpress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
ls

DB_HOST="localhost"  # The host or IP of the mysql database
DB_NAME="wordpressDB"  # The name of the new database
DB_USER="wordpressUser"  # The name of the new user
DB_ADMIN="root"      # The name of the root user
WP_HOST="localhost"  # The host or IP of the WordPress installation
DB_PASS="96198596"           # The password for the new database
DB_PASS_2="96198596"         # Used to verify password

mysql -u 'root' -p -h "$DB_HOST" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$WP_HOST';
FLUSH PRIVILEGES;"

cd wordpress/
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASS/" wp-config.php
mkdir /var/www/html/blog
mv * /var/www/html/blog
cd ..

echo "Don't forget copy the keys from https://api.wordpress.org/secret-key/1.1/salt/"

# Use the chkconfig command to ensure that the httpd and mysqld services start at every system boot.
chkconfig httpd on
chkconfig mysqld on
# Verify that the MySQL server (mysqld) is running.
# service mysqld status
# mysqld (pid  4746) is running...
# If the mysqld service is not running, start it.
# [ec2-user wordpress]$ sudo service mysqld start
# Starting mysqld:                                           [  OK  ]
# Verify that your Apache web server (httpd) is running.
service httpd status
# httpd (pid  502) is running...
# If the httpd service is not running, start it.
# [ec2-user wordpress]$ sudo service httpd start
# Starting httpd:                                            [  OK  ]
# Verify that the php and php-mysql packages are installed. Your output may look slightly different, but look for the Installed Packages section.
yum list installed php php-mysql
# Loaded plugins: priorities, security, update-motd, upgrade-helper
# amzn-main                                                | 2.1 kB     00:00
# amzn-updates                                             | 2.3 kB     00:00
# Installed Packages
# php.x86_64                       5.3.27-1.0.amzn1                  @amzn-updates
# php-mysql.x86_64                 5.3.27-1.0.amzn1                  @amzn-updates
# If either of these packages are not listed as installed, install them with the following command and then restart the httpd service.
# [ec2-useryum install -y php php-mysql
# [ec2-user wordpress]$ sudo service httpd restart