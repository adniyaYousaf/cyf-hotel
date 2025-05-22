#!/bin/bash

sudo apt update -y
sudo apt install -y git
sudo apt install -y docker.io

sudo systemctl start docker
sudo systemctl enable docker

sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

if [ ! -d "Adniya-Full-Stack-Project" ]; then
  git clone https://github.com/adniyaYousaf/Adniya-Full-Stack-Project.git
fi

cd Adniya-Full-Stack-Project
git pull

sudo docker-compose down -v
sudo docker-compose up -d --build

