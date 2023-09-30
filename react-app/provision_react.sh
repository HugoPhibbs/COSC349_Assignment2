#!/bin/bash

sudo apt-get update
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh

nvm install 16.13.0
sudo apt-get install -y npm

npm config set strict-ssl false
npm install
npm run prod-start &