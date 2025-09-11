#!/bin/bash
# Update and install Nginx
apt update -y
apt install -y nginx

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Create a custom index page
echo "welcome to nginx page " > /var/www/html/index.html
