#!/bin/bash

set -e

echo "========== apoolminer 自动安装并注册为服务 =========="

INSTALL_DIR="/opt/apoolminer"
TAR_FILE="/tmp/apoolminer_linux_xmr_v3.0.0.tar.gz"
DOWNLOAD_URL="https://github.com/apool-io/xmrminer/releases/download/v3.0.0/apoolminer_linux_xmr_v3.0.0.tar.gz"
SERVICE_FILE="/etc/systemd/system/apoolminer.service"
ACCOUNT="CP_sawwb8p0ec"
POOL="xmr.hk.apool.io:3334"

# 安装依赖
echo "安装必要组件..."
sudo apt update && sudo apt install -y wget tar

# 下载
echo "下载 apoolminer..."
wget -O "$TAR_FILE" "$DOWNLOAD_URL"

# 解压到指定目录
echo "解压到 $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo tar -zxf "$TAR_FILE" -C "$INSTALL_DIR" --strip-components=1
sudo chmod +x "$INSTALL_DIR/run.sh"

# 写入配置文件
echo "写入 miner.conf..."
sudo tee "$INSTALL_DIR/miner.conf" > /dev/null <<EOF
algo=xmr
account=${ACCOUNT}
pool=${POOL}
EOF

# 创建 systemd 服务
echo "创建 systemd 服务文件..."
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Apool XMR Miner
After=network.target

[Service]
WorkingDirectory=$INSTALL_DIR
ExecStart=/bin/bash run.sh
Restart=always
RestartSec=5
User=root
Nice=10

[Install]
WantedBy=multi-user.target
EOF

# 启动服务
echo "启用并启动 apoolminer 服务..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable apoolminer
sudo systemctl start apoolminer
