#!/usr/bin/bash
#author： wtf
#date: 2021-03-31
#adb调试钉钉：
## 1、需要安装adb调试神器
## 2、目前需要打开钉钉的自动打卡，并且保证移动设备连接至当前主机
#仅供互相学习，不保证成功，请勿他用，后果自负！！！

#包名
packageName=com.alibaba.android.rimet
#APP内页面:首页
pageName="/.biz.LaunchHomeActivity"
#打卡界面
#TODO:目前还有问题，权限问题导致没法打开这个页面
dingtalk="/com.alibaba.lightapp.runtime.ariver.TheOneActivityMainTask"

#打开APP: $1设备名称 $2APP名字
startApp() {
    `adb -s $1 shell am start -n $2`
    echo "${1}已打开"
}
#关闭APP
stopApp() {
    `adb -s $1 shell am force-stop $2`
    echo "${1}已关闭"
}

#查看设备
#返回结果
#List of devices attached
#10.0.17.185:35897	offline
devices=`adb devices`
deviceArr=(${devices// / })

for i in ${!deviceArr[@]}
do
    #小于4就跳过，因为adb devices会有一行描述
    if [ $i -lt 4 ]
    then
        continue
    fi
    #取奇数，拿到设备标识，偶数下标是设备的状态
    if [ `expr $i % 2` -gt 0 ]
    then
        continue
    fi
    #处理每一个设备
    device=${deviceArr[$i]}
    #fork子进程处理每一个设备
    (
        startApp $device "$packageName$pageName"
        #停10s，防止没有打成功
        sleep 10s
        stopApp $device "$packageName"
        echo "${device}已完成"
    )&
done
wait
sleep 10
exit 0







