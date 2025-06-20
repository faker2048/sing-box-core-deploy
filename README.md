# Sing-Box 核心部署工具

## 特点

- 只封装 init.d 和基础命令
- 不修改防火墙配置

## 一键安装

前置要求：`curl` 和 `bash`

```bash
# 标准安装
bash <(curl -sL https://raw.githubusercontent.com/faker2048/sing-box-core-deploy/refs/heads/main/init.sh)

# 镜像加速
bash <(curl -sL https://gh-proxy.com/https://raw.githubusercontent.com/faker2048/sing-box-core-deploy/refs/heads/main/init.sh)
```

## 使用说明

初始化完成后：
- 脚本文件在：`/root/singbox/`
- 配置文件放在：`/etc/sing-box/config.json`

创建系统服务：
```bash
cd /root/singbox
./create_initd.sh
```
