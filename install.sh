#!/bin/sh
read -p "请输入应用程序名称:" appname
read -p "请设置你的容器内存大小(默认256):" ramsize
if [ -z "$ramsize" ];then
	ramsize=256
fi
rm -rf cloudfoundry
mkdir cloudfoundry
cd cloudfoundry

echo '<!DOCTYPE html> '>>index.php
echo '<html> '>>index.php
echo '<body>'>>index.php
echo '<?php '>>index.php
echo 'echo "Hello World!"; '>>index.php
echo '?> '>>index.php
echo '<body>'>>index.php
echo '</html>'>>index.php

wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip -d v2ray1 v2ray-linux-64.zip
cd v2ray1
chmod 777 *
cd ..
rm -rf v2ray-linux-64.zip
mv $HOME/cloudfoundry/v2ray1/v2ray $HOME/cloudfoundry/v2ray
mv $HOME/cloudfoundry/v2ray1/v2ctl $HOME/cloudfoundry/v2ctl
rm -rf $HOME/cloudfoundry/v2ray1
uuid=`cat /proc/sys/kernel/random/uuid`
path=`echo $uuid | cut -f1 -d'-'`
echo '{"inbounds":[{"port":8080,"protocol":"vmess","settings":{"clients":[{"id":"'$uuid'","alterId":64}]},"streamSettings":{"network":"ws","wsSettings":{"path":"/'$path'"}}}],"outbounds":[{"protocol":"freedom","settings":{}}]}'>$HOME/cloudfoundry/config.json
echo 'applications:'>>manifest.yml
echo '- path: .'>>manifest.yml
echo '  command: '/app/htdocs/v2ray'' >>manifest.yml
echo '  name: '$appname''>>manifest.yml
echo '  random-route: true'>>manifest.yml
echo '  memory: '$ramsize'M'>>manifest.yml
ibmcloud target --cf
ibmcloud cf push
domain=`ibmcloud cf app $appname | grep routes | cut -f2 -d':' | sed 's/ //g'`
vmess=`echo '{"add":"'$domain'","aid":"64","host":"","id":"'$uuid'","net":"ws","path":"/'$path'","port":"443","ps":"IBMVPS","tls":"tls","type":"none","v":"2"}' | base64 -w 0`
cd ..
    echo "别高兴太早，到这一步未必说明下面的vmess连接就可以用！"
    echo "请注意如果出现2个或者3个红色的FAILED就说明你的VMESS连接是无法连接外网的。这个时候需要去排查问题，可以通过这个影片去仔细看看可能能找到答案 https://bit.ly/2ZjVCkN"
    echo "或者观看YouTube影片 IBM Cloud VPS 详细分享：https://bit.ly/3ibq1JI"
    echo "如果你看到只有一个红色的Failed 那么恭喜你大概率你的Vmess连接有效！Vmess导入客户端后，请务必将域名中bigfang更改为你的应用程序名称！请务必根据在cloudflare中加速"
    echo "我的电报：bigfangfang"
    echo "电报群交流群：https://t.me/dafangbigfang 群里有很多小伙伴都会帮你"
    echo "电报频道：https://t.me/dafangbigfangC"
    echo "感谢 @CCChieh "
    echo ""
    echo 地址: $domain
    echo UUID: $uuid
    echo path: /$path
    echo "配置链接："
    eecho vmess://$vmess

