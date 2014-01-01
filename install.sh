#!/bin/sh

# Eray Diler - 30 Dec 2013
#
# Script for Aws-EC2 to install LAMP + Wordpress + rmate

# Advice user to run script with sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Install rmate
# after typing <ssh -R 52698:localhost:52698 awshost> awshost:user@example.com in the local machine
# https://github.com/textmate/rmate/
mkdir ~/bin
curl -Lo ~/bin/rmate https://raw.github.com/textmate/rmate/master/bin/rmate
chmod a+x ~/bin/rmate
export PATH="$PATH:$HOME/bin"

# Installs the updates, without confirmation with -y option 
yum update -y

# Install the Apache web server, MySQL, and PHP software packages
yum groupinstall -y "Web Server" "MySQL Database" "PHP Support"

# Install the php-mysql package
yum install -y php-mysql

# Start the Apache web server.
service httpd start

# configure the Apache web server to start at each system boot
chkconfig httpd on

# The chkconfig command does not provide any confirmation message when you successfully enable a service. You can verify that httpd is on by running the following command.
chkconfig --list httpd

# Apache httpd serves files that are kept in a directory called the Apache document root. The Amazon Linux AMI Apache document root is /var/www/html, which is owned by root by default.
ls -l /var/www

# To allow ec2-user to manipulate files in this directory, you need to modify the ownership and permissions of the directory. There are many ways to accomplish this task; in this tutorial, you add a www group to your instance, and you give that group ownership of the /var/www directory and add write permissions for the group. Any members of that group will then be able to add, delete, and modify files for the web server.

# To set file permissions
# Add the www group to your instance.
groupadd www
# Add your user (in this case, ec2-user) to the www group.
usermod -a -G www ec2-user
# Important
# You need to log out and log back in to pick up the new group. You can use the exit command, or close the terminal window.
# Log out and then log back in again and verify your membership in the www group.
# Log out.
 echo "exit here"
# Reconnect to your instance and then run the following command to verify your membership in the www group.
groups
ec2-user wheel www
# Change the group ownership of /var/www and its contents to the www group.
chown -R root:www /var/www
# Change the directory permissions of /var/www and its subdirectories to add group write permissions and to set the group ID on future subdirectories.
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} +
# Recursively change the file permissions of /var/www and its subdirectories to add group write permissions.
find /var/www -type f -exec sudo chmod 0664 {} +

chmod a+x ec2-setup/test.sh
chmod a+x ec2-setup/remove.sh

echo "end of script relogin now"