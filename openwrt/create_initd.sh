#!/bin/sh

# 创建 OpenWrt sing-box 服务脚本

cat > /etc/init.d/sing-box << 'EOF'
#!/bin/sh /etc/rc.common

START=99
STOP=10

start_service() {
    procd_open_instance
    
    procd_set_param command /root/singbox/just_run.sh
    procd_set_param respawn
    procd_close_instance
}

stop_service() {
    killall sing-box
}
EOF

chmod +x /etc/init.d/sing-box
/etc/init.d/sing-box enable

echo "sing-box 服务已创建并启用"
echo "使用 /etc/init.d/sing-box start 启动服务"
echo "使用 /etc/init.d/sing-box stop 停止服务"
echo "使用 /etc/init.d/sing-box restart 重启服务"
echo "使用 /etc/init.d/sing-box enable 开机自启动"
echo "使用 /etc/init.d/sing-box disable 取消开机自启动"
