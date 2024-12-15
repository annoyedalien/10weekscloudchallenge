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

mysql -h mysql-serverdemo.mysql.database.azure.com -u mysqladmin -p <db_setup.sql


