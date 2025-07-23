#!/bin/bash

# 切换到 root 用户
sudo -i

# 更新包列表并安装 wget 和 unzip
apt update
apt install -y wget unzip

# 下载压缩包到 /root 目录
wget -O /root/apool.zip https://github.com/jianjia8/cs/raw/refs/heads/main/apool.zip
if [ $? -ne 0 ]; then
    echo "错误：下载 apool.zip 失败，请检查网络或 URL 是否正确。"
    exit 1
fi

# 验证文件是否为 ZIP 格式
file /root/apool.zip | grep -q "Zip archive"
if [ $? -ne 0 ]; then
    echo "错误：下载的文件不是有效的 ZIP 文件。"
    exit 1
fi

# 解压到 /root 目录
unzip /root/apool.zip -d /root
if [ $? -ne 0 ]; then
    echo "错误：解压 apool.zip 失败，请检查文件完整性。"
    exit 1
fi

# 给 /root/apool 目录及其所有子文件添加可执行权限
chmod -R +x /root/apool

# 查找 bao.sh 的路径
bao_PATH=$(find /root/apool -name "bao.sh" -type f)
if [ -z "$bao_PATH" ]; then
    echo "错误：未找到 bao.sh 文件，请检查 /root/apool 目录内容："
    ls -R /root/apool
    exit 1
fi

# 执行 baohou.sh 脚本
echo "找到 baohou.sh，路径为：$bao_PATH，正在执行..."
bash "$bao_PATH"
if [ $? -ne 0 ]; then
    echo "错误：执行 bao.sh 失败，请检查脚本内容或依赖。"
    exit 1
fi
