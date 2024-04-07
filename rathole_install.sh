run_count=$(ps -ef |grep rathole |grep -v "grep" |grep -v "rathole_install.sh" |wc -l)
if [ $run_count -ne 0 ]; then
    echo "rathole["$(ps -ef | grep "rathole" | grep -v grep | awk '{print $2}')"] 运行中，退出脚本！"
    exit 0
fi
mkdir -p /tmp/rathole
cd /tmp/rathole
get_arch=$(uname -m)
if [[ $get_arch =~ "x86_64" ]];then
    wget https://cdn.jsdelivr.net/gh/moll33er/rathole/rathole-x86_64 -O rathole # x86-64
elif [[ $get_arch =~ "mips" ]];then
    wget https://cdn.jsdelivr.net/gh/moll33er/rathole/rathole-mipsle -O rathole # mipsle
else
    echo "不支持的系统版本，已退出！"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "下载失败，请重试！"
    exit 1
fi
chmod +x ./rathole
cat > server.toml << EOF
[server]
bind_addr = "0.0.0.0:2333"
default_token = "moller33..."

[server.services.game-udp]
type = "udp"
bind_addr = "0.0.0.0:38444"

[server.services.web]
type = "tcp"
bind_addr = "0.0.0.0:5202"
EOF
/tmp/rathole/rathole /tmp/rathole/server.toml &
