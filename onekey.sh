#!/bin/bash
sudo apt update
sudo apt install unzip
curl -L -o apool.zip https://github.com/jianjia8/cs/raw/refs/heads/main/apool.zip
unzip apool.zip
find apool -type f -exec chmod +x {} \;
./apool/baohuo.sh