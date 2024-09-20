#!/bin/bash
# from https://chromium.woolyss.com/
# and https://gist.github.com/addyosmani/5336747
# and https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md
# and https://geekflare.com/install-chromium-ubuntu-centos/
apt-get update
apt-get install -y libappindicator1 fonts-liberation libasound2 libatk-bridge2.0-0 libatspi2.0-0 libdrm2 libgtk-3-0 libnspr4 libnss3 libx11-xcb1 libxkbcommon0 xdg-utils
apt-get -y --fix-broken install
apt-get install -y wget
CURRENT_DIRECTORY=$PWD
cd ~
# Download Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# Install Chrome
dpkg -i google-chrome*.deb
google-chrome-stable --version
ln -s /usr/bin/google-chrome-stable /usr/bin/chrome
cd $CURRENT_DIRECTORY
unset $CURRENT_DIRECTORY
chrome --version