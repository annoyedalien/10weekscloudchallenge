#!/bin/bash

sudo apt-get update
sudo apt install npm -y
sudo apt install mysql-server -y
npm install express
npm install mysql
npm install cors
npm init -y

sudo npm install -g pm2
sudo npm install -y
echo "-----------------------------------------"
echo "|    Enter Password for MySQL Server     |"
echo "-----------------------------------------"
mysql -h mysql-serverdemo.mysql.database.azure.com -u mysqladmin -p <db_setup.sql

pm2 start backendapp.js
startup_as_process=$(pm2 startup | grep -o 'sudo env.*')
eval "$startup_as_process"
pm2 save

