#!/bin/sh

# 加载环境变量文件
if [ -f /etc/sing-box/run_env ]; then
    export $(cat /etc/sing-box/run_env | xargs)
fi

/usr/bin/sing-box run -c /etc/sing-box/config.json