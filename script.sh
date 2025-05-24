#!/bin/bash

sudo apt update -y
sudo apt install -y git postgresql docker.io unzip jq

sudo systemctl start docker
sudo systemctl enable docker


sudo usermod -aG docker ubuntu


sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sleep 10
cd /home/ubuntu
sudo -u ubuntu git clone https://github.com/adniyaYousaf/Adniya-Full-Stack-Project.git

cd Adniya-Full-Stack-Project 
sudo -u ubuntu git pull

#Get the secret JSON from AWS:
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id db_user --region eu-north-1 --query SecretString --output text)

#Extract values using jq and format the URL:
USERNAME=$(echo "$SECRET_JSON" | jq -r '.username')
PASSWORD=$(echo "$SECRET_JSON" | jq -r '.password')
HOST=$(echo "$SECRET_JSON" | jq -r '.host')
PORT=$(echo "$SECRET_JSON" | jq -r '.port')

DATABASE_URL="postgres://$USERNAME:$PASSWORD@$HOST:$PORT"
echo "DATABASE_URL=$DATABASE_URL" > .env
echo "POSTGRES_PASSWORD=$PASSWORD" >> .env

sudo docker-compose down -v
sudo docker-compose up -d --build
