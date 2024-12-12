#!/bin/bash


echo "----------------------------------------------------------"
echo "|          Updating and Installing dependencies           |"
echo "----------------------------------------------------------"

sudo apt update -y

sudo apt install apache2 -y

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs -y

sudo apt update -y

sudo npm install -g corepack -y

corepack enable

corepack prepare yarn@stable --activate --yes

sudo yarn global add pm2 -y

echo "----------------------------------------------------------"
echo "|      Do you want to create an .env file?             |"
echo "----------------------------------------------------------"

read -p "yes/no: " ans

if [[ "$ans" == "no" ]]; then
 echo "Make changes to backend/.env "
elif [[ "$ans" == "yes" ]]; then

cd backend
sudo vim backend/.env

echo "----------------------------------------------------------"
echo "|            Installing NPM and Dotenv                    |"
echo "----------------------------------------------------------"

sudo npm install
npm run build
sudo cp -r build/* /var/www/html


echo "----------------------------------------------------------"
echo "|            Installing MySQL Server                      |"
echo "----------------------------------------------------------"

sudo apt install mysql-server -y
mysql -h db-tier-mysql.mysql.database.azure.com -u azureuser -p <db_setup.sql

else
 echo 
 echo "Enter Valid Answer"
fi 

#end
