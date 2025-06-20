#!/bin/sh

# 创建 OpenWrt sing-box 服务脚本

cat > /etc/init.d/sing-box << 'EOF'
#!/bin/sh /etc/rc.common

START=99
STOP=10
USE_PROCD=1

start_service() {
    procd_open_instance sing-box
    procd_set_param command /root/singbox/just_run.sh
    procd_set_param respawn ${respawn_threshold:-3600} ${respawn_timeout:-5} ${respawn_retry:-5}
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}

stop_service() {
    procd_kill sing-box
}

service_triggers() {
    procd_add_reload_trigger "sing-box"
}

reload_service() {
    stop
    start
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
