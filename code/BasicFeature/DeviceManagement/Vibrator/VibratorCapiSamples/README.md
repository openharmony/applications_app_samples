## vibrator capi接口hap

### 介绍

本样例展示了vibrator模块capi接口的使用样例，包含在时间间隔内震动、自定义震动以及停止震动接口

本示例用到了vibrator相关接口操作[@kit.SensorServiceKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-sensor-service-kit/vibrator_8h.md)

### 效果预览

依次介绍sample具有什么功能，怎样使用这些功能，以及使用后会达到什么效果；示例如下：

1. 在主界面，点击playVibrationInDuration按钮可以控制马达在指定时间内持续振动和停止马达振动；
2. 在主界面，点击playVibrationCustom按钮可以播放自定义振动序列与停止马达震动。

工程目录

```
├── entry
│   └── src
│       └── main
│           ├── cpp                                 // C++代码区
│           │   ├── CMakeLists.txt                  // CMAKE配置文件
│           │   ├── oh_vibrator_capi.cpp            // Native业务代码实现
│           │   └── types
│           │       └── libentry                    // C++接口导出
│           │           ├── Index.d.ts
│           │           └── oh-package.json5
│           ├── ets                                 // ArkTS代码区
│           │   └── pages
│           │       └── Index.ets                   // 主页
```

### 具体实现

本样例展示了vibrator模块capi接口的使用样例，包含在时间间隔内震动、自定义震动以及停止震动接口，该功能全部接口已封装在oh_vibrator_capi.cpp，源码参考：[oh_vibrator_capi.cpp](./entry/src/main/cpp/oh_vibrator_capi.cpp)


### 相关权限

附上使用到的权限和链接，示例如下：

[ohos.permission.VIBRATE](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568;

2.本示例为Stage模型，仅支持API20版本SDK，SDK版本号(API Version 20 Beta),镜像版本号(6.0Beta);

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.848, built on Sept 25, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init  
git config core.sparsecheckout true  
echo code/BasicFeature/DeviceManagement/Sensor/VibratorCapiSamples/ > .git/info/sparse-checkout  
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git  
git pull origin master
```