ibmcloud target --cf && read -p "输入你的app名称：" appname&&path=$(ibmcloud cf ssh ${appname} -c "path=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)"|grep path|sed -e 's/ //g'|sed -e 's/\path//g'|sed -e 's/\"//g'|sed -e 's/\://g'|sed -e 's/\,//g')&&id=$(ibmcloud cf ssh ${appname} -c "cat app/v2ray/config.json" |grep id|sed -e 's/ //g'|sed -e 's/\id//g'|sed -e 's/\"//g'|sed -e 's/\://g'|sed -e 's/\,//g')&&VMESSCODE=$(base64 -w 0 << EOF
  {path=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
     "v": "2",
     "ps": "bigfang",
     "add": "${appname}.us-south.cf.appdomain.cloud",
     "port": "443",
     "id": "${id}",
     "aid": "4",
     "net": "ws",
     "type": "none",
     "host": "",
     "path": "${path}",
     "tls": "tls"
  }
EOF
)

echo address:${appname}.us-south.cf.appdomain.cloud
echo ID:${id}
echo port:443
echo alterID:64
echo net:ws
echo path:${path}
echo tls:${tls}
echo "恭喜你找回了你的vmess"
echo "配置链接："
echo vmess://${VMESSCODE}