#!/bin/sh

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印标题
print_title() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}    Sing-Box Status Check${NC}"
    echo -e "${CYAN}================================${NC}"
}

# 打印分隔线
print_separator() {
    echo -e "${BLUE}--------------------------------${NC}"
}

# 检查版本
check_version() {
    echo -e "${PURPLE}📦 Sing-Box Version:${NC}"
    if command -v sing-box >/dev/null 2>&1; then
        version=$(sing-box version 2>/dev/null | head -n1)
        echo -e "   ${GREEN}✓${NC} $version"
    else
        echo -e "   ${RED}✗${NC} Sing-box not installed"
    fi
}

# 检查进程状态
check_process() {
    echo -e "${PURPLE}🔄 Process Status:${NC}"
    if pgrep -f "sing-box" >/dev/null; then
        pid=$(pgrep -f "sing-box")
        echo -e "   ${GREEN}✓${NC} Running (PID: $pid)"
        
        # 检查内存使用
        if [ -f /proc/$pid/status ]; then
            mem=$(grep VmRSS /proc/$pid/status | awk '{print $2 " " $3}')
            echo -e "   ${CYAN}📊${NC} Memory Usage: $mem"
        fi
    else
        echo -e "   ${RED}✗${NC} Not running"
    fi
}

# 检查服务状态
check_service() {
    echo -e "${PURPLE}⚙️  Service Status:${NC}"
    if [ -f /etc/init.d/sing-box ]; then
        echo -e "   ${GREEN}✓${NC} Init script exists"
        
        # 检查服务状态
        if /etc/init.d/sing-box status >/dev/null 2>&1; then
            echo -e "   ${GREEN}✓${NC} Service is active"
        else
            echo -e "   ${YELLOW}⚠${NC} Service inactive"
        fi
        
        # 检查开机自启
        if ls /etc/rc.d/S*sing-box >/dev/null 2>&1; then
            echo -e "   ${GREEN}✓${NC} Auto-start enabled"
        else
            echo -e "   ${YELLOW}⚠${NC} Auto-start disabled"
        fi
    else
        echo -e "   ${RED}✗${NC} Init script not found"
    fi
}

# 检查配置文件
check_config() {
    echo -e "${PURPLE}📄 Configuration:${NC}"
    if [ -f /etc/sing-box/config.json ]; then
        echo -e "   ${GREEN}✓${NC} Config file exists"
        size=$(du -h /etc/sing-box/config.json | cut -f1)
        echo -e "   ${CYAN}📏${NC} File size: $size"
        
        # 简单的JSON语法检查
        if command -v jsonlint >/dev/null 2>&1; then
            if jsonlint /etc/sing-box/config.json >/dev/null 2>&1; then
                echo -e "   ${GREEN}✓${NC} JSON syntax valid"
            else
                echo -e "   ${RED}✗${NC} JSON syntax error"
            fi
        fi
    else
        echo -e "   ${RED}✗${NC} Config file not found"
    fi
}

# 检查端口占用
check_ports() {
    echo -e "${PURPLE}🌐 Port Status:${NC}"
    if [ -f /etc/sing-box/config.json ]; then
        # 尝试从配置文件中提取端口（简单方法）
        ports=$(grep -o '"listen"[[:space:]]*:[[:space:]]*"[^"]*"' /etc/sing-box/config.json 2>/dev/null | grep -o '[0-9]\+' | head -3)
        if [ -n "$ports" ]; then
            for port in $ports; do
                if netstat -ln 2>/dev/null | grep ":$port " >/dev/null; then
                    echo -e "   ${GREEN}✓${NC} Port $port is listening"
                else
                    echo -e "   ${YELLOW}⚠${NC} Port $port not listening"
                fi
            done
        else
            echo -e "   ${YELLOW}⚠${NC} Could not detect ports from config"
        fi
    else
        echo -e "   ${RED}✗${NC} Config file not available"
    fi
}

# 检查系统资源
check_system() {
    echo -e "${PURPLE}💻 System Resources:${NC}"
    
    # 内存使用
    mem_info=$(free | grep Mem)
    mem_total=$(echo $mem_info | awk '{print int($2/1024)"MB"}')
    mem_used=$(echo $mem_info | awk '{print int($3/1024)"MB"}')
    mem_percent=$(echo $mem_info | awk '{printf "%.1f", ($3/$2)*100}')
    echo -e "   ${CYAN}💾${NC} Memory: $mem_used/$mem_total (${mem_percent}%)"
    
    # 负载
    if [ -f /proc/loadavg ]; then
        load=$(cat /proc/loadavg | cut -d' ' -f1-3)
        echo -e "   ${CYAN}⚡${NC} Load Average: $load"
    fi
}

# 显示最近日志
check_logs() {
    echo -e "${PURPLE}📋 Recent Logs:${NC}"
    if command -v logread >/dev/null 2>&1; then
        logs=$(logread | grep -i sing-box | tail -3)
        if [ -n "$logs" ]; then
            echo "$logs" | while read line; do
                echo -e "   ${YELLOW}📝${NC} $line"
            done
        else
            echo -e "   ${YELLOW}⚠${NC} No recent logs found"
        fi
    else
        echo -e "   ${YELLOW}⚠${NC} Logread not available"
    fi
}

# 主函数
main() {
    print_title
    echo
    
    check_version
    print_separator
    
    check_process
    print_separator
    
    check_service
    print_separator
    
    check_config
    print_separator
    
    check_ports
    print_separator
    
    check_system
    print_separator
    
    check_logs
    
    echo
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}Status check completed at $(date)${NC}"
    echo -e "${CYAN}================================${NC}"
}

main
