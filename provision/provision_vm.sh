#!/bin/bash

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt package index
sudo apt-get update

# Install docker
echo "Installing docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Delete old sql data, this is so recent mysql setup is used, otherwise mysql will use old data
sudo rm -rf /vagrant/mysql/mysql-data || 1

# Stop currently running containers, want to start fresh, sometimes old configuration is carried over
sudo docker compose -f /vagrant/provision/compose.yml down

# Run docker containers from compose
sudo docker compose -f /vagrant/provision/compose.yml up -d
