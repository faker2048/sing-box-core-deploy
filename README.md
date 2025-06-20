

## 一键脚本：(请自行安装curl和bash，如果缺少的话)
```
# 无镜像加速
bash <(curl -sL https://raw.githubusercontent.com/faker2048/sing-box-core-deploy/refs/heads/main//init.sh)
# 带加速
bash <(curl -sL https://gh-proxy.com/https://raw.githubusercontent.com/faker2048/sing-box-core-deploy/refs/heads/main//init.sh)
```
- 初始化运行结束，会创建一个文件夹 /root/singbox, 并把要用到的脚本都拷贝进去了。
- 请手动将 sing-box 配置文件放在 /etc/sing-box/config.json
## 

```
cd /root/singbox
./create_initd.sh
```