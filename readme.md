# 免费申请IBM VPS一年免费继续用

自从谷歌2020年8月份开始从原来365天的免费试用的正常变更为90天的试用后，看看是否有其他更好的替代薅羊毛方案！

今天我们讲3个方面的内容

1. 我们利用开源免费的Cloud Foundry项目来搭建V2ray；
2. IBM Cloud Foundry 10天没有操作的话就是关机，所以利用Github来每周开关机一次避免关机；
3.  同时利用cloudflare worker项目来给V2ray加速；

完成第一部分 就可以使用了，如果进阶可以继续完成第二 第三部分
让我们开始吧！

### 1. 我们利用开源免费的Cloud Foundry项目来搭建V2ray

##### 1.1. 申请IBM免费VPS
> 地址：https://cloud.ibm.com/

##### 1.2. V2ray一键安装代码

```
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/CCChieh/IBMYes/master/install.sh && chmod +x install.sh  && ./install.sh

```

> 注意事项：
>> 1. 记住填写的 应用名称 建议写：bigfang 
>> 2. 内存大小选择256m
>> 3. 一键安装完成后 保存生成VMESS连接


### 2. 利用Github创建每周开关机一次任务

##### 2.1. 项目地址
> https://github.com/CCChieh/IBMyes
在项目里点击Fork，这样就复制程序到自己的Github里面

##### 2.2. 建立4项secret

> IBM_ACCOUNT // IBM Cloud的登录邮箱和密码
>> your@email.com
>> password

> IBM_APP_NAME // 应用的名称

> REGION_NUM // 区域编码

> RESOURSE_ID // 资源组ID


