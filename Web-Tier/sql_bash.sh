#!/bin/bash
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql
sudo echo "CREATE USER 'username'@'192.168.1.10' IDENTIFIED BY 'Admin@121';" | mysql -u root
sudo echo "GRANT ALL PRIVILEGES ON *.* TO 'username'@'192.168.1.10' WITH GRANT OPTION;" | mysql -u root
sudo echo "FLUSH PRIVILEGES;" | mysql -u root
sudo echo "CREATE DATABASE sample_website;" | mysql -u root
sudo echo "USE sample_website;" | mysql -u root
sudo echo "CREATE TABLE Persons (firstname varchar(255),lastname varchar(255),email varchar(255),password varchar(255),country varchar(255),gender varchar(255),phonenumber varchar(255));" | mysql -u root

sudo systemctl restart mysql
