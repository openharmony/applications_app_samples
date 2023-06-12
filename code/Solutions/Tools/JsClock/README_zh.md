# 时钟

### 介绍

本示例实现一个简单的时钟应用。本示例不涉及接口。

### 效果预览
|主页|
|---|
|![](screenshots/device/Clock.png)|

使用说明

1.安装hap包。

2.在桌面上找到hap包打开。

3.展示时钟页面。

### 工程目录

```
entry/src/main/js/default        
|---common                               // 定义钟表组件用到的图片资源
|   |---clock_bg.png                     
|   |---hour_hand.png                    
|   |---minute_hand.png                  
|   |---second_hand.png                  
|---pages
|   |---index.css                        // 时钟首页页面样式
|   |---Index.hml                        // 时钟首页页面结构,包含钟表动画及下面的电子时间
|   |---Index.js                         // 定义实时刷新时间逻辑
```


#### 相关概念

TextClock：TextClock组件通过文本将当前系统时间显示在设备上。支持不同时区的时间显示，最高精度到秒级。

### 具体实现

1、在首页设置一个定时器（timer），定时调用接口从index.js刷新最新消息通知，更新首页通知列表,[源码](entry/src/main/js/default/pages/index/index.js )参考;

2、捕捉用户动作，当用户离开首页时（onHide事件）定时器注销（clearInverval）定时器;

3、当用户回到小程序首页时（onShow事件），重新设置一个定时器（timer）setInterval，定时从index.js刷新最新消息通知。  

4、实现动画样式：通过transform设置平移/旋转/缩放的属性。时钟的指针使用rotate设置x轴和y轴两个维度参数，rotate可以传入具体角度值。指针旋转角度通过计算得出。  
例如："transform : rotate\(\{\{ second \* 6 \}\}deg\)", 秒针1秒转动6度。  



### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

3.如果安装本示例报错为error：install sign info inconsistent，则有可能本应用被设置为系统预置应用，已安装在系统中，此时需使用命令进行替换安装，并在替换安装后对设备进行重启操作，具体命令如下：

hdc shell mount -o rw,remount /

hdc file send ./entry-default-signed.hap /system/app/ohos.samples.clock/Clock_Demo.hap

hdc shell  reboot

等设备重启后即可完成应用的替换安装，无需其他操作。  

如果操作完仍报错，  
1.将main/config.json中 "bundleName":"ohos.samples.clock1",  
2.JsCLock/build-profile.json5中"signingConfigs"：[]中签名对象删除，并重新系统签名运行，即可安装成功。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/Solutions/Tools/JsClock/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````