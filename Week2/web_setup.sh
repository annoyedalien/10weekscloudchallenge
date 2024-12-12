#!/bin/bash

sudo apt update -y


echo "----------------------------------------------------------"
echo "|          Updating and Installing dependencies           |"
echo "----------------------------------------------------------"

sudo apt install apache2 -y

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs -y

sudo apt update -y

sudo npm install -g corepack -y

corepack enable

corepack prepare yarn@stable --activate --yes

sudo yarn global add pm2 -y


echo "----------------------------------------------------------"
echo "|      Do you want make changes to config.js file?        |"
echo "----------------------------------------------------------"

read -p "yes/no: " ans

if [[ "$ans" == "no" ]]; then
 echo "Make changes to client/src/pages/config.js "
elif [[ "$ans" == "yes" ]]; then

cd client
sudo nano src/pages/config.js


sudo npm install
npm run build
sudo cp -r build/* /var/www/html


else
 echo 
 echo "Enter Valid Answer"
fi 
