#!/bin/sh
read -p "请输入应用程序名称:" appname
read -p "请设置你的容器内存大小(默认256):" ramsize
if [ -z "$ramsize" ];then
	ramsize=256
fi
pause "xxx ok"
rm -rf cloudfoundry
mkdir cloudfoundry
cd cloudfoundry
mkdir Godeps
echo '{'>>Godeps/Godeps.json
echo '	"ImportPath": "main",'>>Godeps/Godeps.json
echo '	"GoVersion": "go1",'>>Godeps/Godeps.json
echo '	"Deps": []'>>Godeps/Godeps.json
echo '}'>>Godeps/Godeps.json
echo 'package main'>>main.go
echo 'func main() {'>>main.go
echo '}'>>main.go
echo '#!/bin/bash'>>start.sh
echo 'cd v2ray'>>start.sh
echo './v2ray&'>>start.sh
echo 'sleep 9d'>>start.sh
echo 'kill -9 $(ps -ef|grep v2ray|grep -v grep|awk "'"{print \$2}"'")'>>start.sh
echo 'web: ./start.sh'>Procfile
wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip -d v2ray v2ray-linux-64.zip
cd v2ray
chmod 777 *
cd ..
rm -rf v2ray-linux-64.zip
uuid=`cat /proc/sys/kernel/random/uuid`
path=`echo $uuid | cut -f1 -d'-'`
echo '{"inbounds":[{"port":8080,"protocol":"vmess","settings":{"clients":[{"id":"'$uuid'","alterId":64}]},"streamSettings":{"network":"ws","wsSettings":{"path":"/'$path'"}}}],"outbounds":[{"protocol":"freedom","settings":{}}]}'>v2ray/config.json
echo 'applications:'>>manifest.yml
echo '- path: .'>>manifest.yml
echo '  name: '$appname''>>manifest.yml
echo '  random-route: true'>>manifest.yml
echo '  memory: '$ramsize'M'>>manifest.yml
chmod 777 start.sh
ibmcloud target --cf
ibmcloud cf push
domain=`ibmcloud cf app $appname | grep routes | cut -f2 -d':' | sed 's/ //g'`
vmess=`echo '{"add":"'$domain'","aid":"64","host":"","id":"'$uuid'","net":"ws","path":"/'$path'","port":"443","ps":"IBM_Cloud","tls":"tls","type":"none","v":"2"}' | base64 -w 0`
cd ..
echo 容器已经成功启动
echo 地址: $domain
echo UUID: $uuid
echo path: /$path
echo vmess://$vmess
