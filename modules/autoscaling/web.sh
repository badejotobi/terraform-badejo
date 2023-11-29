#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<html><center><h1>Welcome to Our Webserver: Created by Oluwatobi</h1></center></html>" > /var/www/html/index.html