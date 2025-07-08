#!/bin/bash

echo "========== apoolminer 自动安装脚本 =========="

# 安装 wget、tar
echo "安装必要组件..."
sudo apt update && sudo apt install -y wget tar

# 下载 apoolminer
echo "下载 apoolminer..."
wget -O apoolminer_linux_xmr_v3.0.0.tar.gz https://github.com/apool-io/xmrminer/releases/download/v3.0.0/apoolminer_linux_xmr_v3.0.0.tar.gz

# 解压
echo "解压文件..."
tar zxf apoolminer_linux_xmr_v3.0.0.tar.gz

# 进入目录
cd apoolminer_linux_xmr_v3.0.0 || exit 1

# 自动生成 miner.conf
echo "生成 miner.conf..."
cat <<EOF > miner.conf
algo=xmr
account=CP_sawwb8p0ec
pool=xmr.hk.apool.io:3334
EOF

echo "配置文件已生成："
cat miner.conf

# 启动挖矿
echo "启动挖矿..."
bash run.sh
