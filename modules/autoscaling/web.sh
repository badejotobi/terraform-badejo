#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><center><h1>Welcome to Our Webserver: Created by Oluwatobi</h1></center></html>" > /var/www/html/index.html