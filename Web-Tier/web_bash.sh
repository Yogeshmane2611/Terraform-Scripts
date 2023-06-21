#! /bin/bash

sudo apt update 
sudo apt install apache2 -y
systemctl start apache2
systemctl enable apache2 
sudo apt-get install php libapache2-mod-php php-mysql -y
sudo apt install git -y
sudo git clone https://github.com/Yogeshmane2611/Sign-up-page
sudo cp Sign-up-page/* /var/www/html/ 
systemctl restart apache2
