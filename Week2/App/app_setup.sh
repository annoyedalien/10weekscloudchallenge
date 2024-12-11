#!/bin/bash
sudo apt-get update
cd mkdir myapp ; cd myapp

git remote add -f origin https://github.com/annoyedalien/10weekscloudchallenge.git

git config core.sparseCheckout true
git sparse-checkout set Week2/App
git pull origin main


sudo apt install nodejs npm -y
sudo apt install mysql-server -y
mysql -h [MYSQL SERVER NAME].mysql.database.azure.com -u myadmin -p
CREATE DATABASE mydatabase;
USE mydatabase;

CREATE TABLE inputs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
exit





