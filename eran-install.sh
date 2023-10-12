#!/bin/bash
set -x

# Update and install:
sudo apt update
sudo apt remove yarn

# node sources
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
chmod a+r /etc/apt/keyrings/nodesource.gpg

#yarn sources
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# node sources
NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt-get update
apt --fix-broken install -y
apt-get install -y gnupg curl ca-certificates unzip wget git nodejs yarn

node -v

# Install Remote-Browser
cd ~
git clone https://github.com/bepsvpt-me/remote-browser.git
# git clone https://github.com/gmezone/remote-browser.git
cd remote-browser

sed -i 's/apt install xvfb/apt install -y xvfb/g' chrome-dependencies-installer.sh
# sed -i 's|https://account.microsoft.com/billing/redeem?lang=he-IL|http://ipinfo.io/json|g' stream-server/index.js
sudo ./chrome-dependencies-installer.sh
cp .env.example .env
#sed -i 's/HOST=localhost/HOST=/g' .env
sed -i 's|HttpServer.listen(PORT, HOST)|HttpServer.listen(PORT)|g' index.js
# npm install
yarn install
# Start pm2 instance
./node_modules/.bin/pm2 start ecosystem.config.cjs
# ./node_modules/.bin/pm2 save &
# ./node_modules/.bin/pm2 startup &
