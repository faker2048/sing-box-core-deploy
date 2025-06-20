#!/bin/bash

set -e


# 创建配置目录
mkdir -p /etc/sing-box
mkdir -p /root/singbox

# 复制脚本到目标目录
SCRIPTS=(
    "openwrt/create_initd.sh"
    "openwrt/just_run.sh"
    "openwrt/restart_initd.sh"
    "openwrt/check_status.sh"
)

for script in "${SCRIPTS[@]}"; do
    filename=$(basename "$script")
    curl -sL "https://gh-proxy.com/https://raw.githubusercontent.com/faker2048/sing-box-core-deploy/refs/heads/master/$script" -o "/root/singbox/$filename"
done

chmod +x /root/singbox/*.sh

# 清理临时文件
rm -rf /tmp/sing-box* /tmp/sing-box-*

echo "安装完成！"
echo "请将配置文件放在 /etc/sing-box/config.json"
echo "然后运行: cd /root/singbox && ./create_initd.sh"
