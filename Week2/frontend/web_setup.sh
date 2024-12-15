#!/bin/bash
sudo apt-get update
sudo apt install npm -y
npx create-react-app -y 
npm install axios -y
npm install react-dom -y
npm install react-scripts -y
sudo apt install nginx -y
sudo service nginx stop
#Rename the default config of nginx
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.old


