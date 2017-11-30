#!/bin/bash

### BEGIN description
# This is a quick adaptation of the nginx for the development of the upstream_server, for user unperceived traffic guidance
# Author: Jerry Zhu <jerry@whmall.com>
### END 

#Config file path of NGINX
NGINX_CONF=/opt/nginx/conf/nginx.conf

#Server IP address information
#declare -r SERVER_IP1="192.168.10.1"
declare -r SERVER_IP2="192.168.10.2"
declare -r SERVER_IP3="192.168.10.3"

echo -e  "\e[1;31m=========欢迎来到生产环境，请做出你的神圣且谨慎的选择!!!!==============\e[0m"


#Wait for the user to make a choice
cat << EOF
1) 用户流量全部到SERVER02
2) 用户流量全部到SERVER03
3) 用户流量均匀分配到SERVER02&SERVER03
4) Quit
=======================================================================
EOF

read -p "Enter your choice(ID): " option

case $option  in

1)	
	sed -i "s@[[:space:]]\?#\?server $SERVER_IP3@#server $SERVER_IP3@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP3@#server $SERVER_IP3@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP2@server $SERVER_IP2@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP2@server $SERVER_IP2@g" $NGINX_CONF
	service nginx configtest && service nginx reload && echo "用户流量已经全部分配到SERVER02!!!!!" || echo -e "\e[1;31m你要破坏世界和平吗？！！\e[0m"
;;

2)
	sed -i "s@[[:space:]]\?#\?server $SERVER_IP2@#server $SERVER_IP2@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP2@#server $SERVER_IP2@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP3@server $SERVER_IP3@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP3@server $SERVER_IP3@g" $NGINX_CONF
	service nginx configtest && service nginx reload && echo "用户流量已经全部分配到SERVER03!!!!!" || echo -e "\e[1;31m你要破坏世界和平吗？！！\e[0m"
;;

3)
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP2@server $SERVER_IP2@g" $NGINX_CONF
	sed -i "s@[[:space:]]\?#\+server $SERVER_IP3@server $SERVER_IP3@g" $NGINX_CONF
	service nginx configtest && service nginx reload && echo "用户流量已经均匀分配到SERVER02&SERVER03!!!"
;;
					
4)
	echo "缓兵之计，以退为进,深思熟虑，运筹帷幄。" 
	exit 0
;;

*)
	echo "骚年，出招吧！别选错了！！"
	exit 1
esac
