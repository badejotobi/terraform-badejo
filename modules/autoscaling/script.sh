#!/bin/bash
sudo yum update -y
#installing our webserver
sudo yum -y install git
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
#setting the right permission for out apache
sudo usermod -aG apache ec2-user
sudo chown -R ec2-user:apache /var/www/html
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo amazon-linux-extras install epel -y 
#download sql and php server
sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm 
sudo yum install mysql-community-server
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
#Download the social media web



