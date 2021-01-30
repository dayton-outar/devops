#!/bin/bash
# from https://chromium.woolyss.com/
# and https://gist.github.com/addyosmani/5336747
# and https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md
# and https://geekflare.com/install-chromium-ubuntu-centos/
yum update

# Download Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

yum install -y google-chrome-stable_current_x86_64.rpm

ln -s /usr/bin/google-chrome-stable /usr/bin/chrome

chrome --version