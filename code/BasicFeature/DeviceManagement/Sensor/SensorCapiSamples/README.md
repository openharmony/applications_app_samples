## sensor capi接口hap

### 介绍

本样例展示了sensor模块capi接口的使用样例，包含订阅、去订阅、获取传感器信息以及各种实例的创建与销毁等接口功能

本示例用到了传感器相关接口操作[@kit.SensorServiceKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-sensor-service-kit/_sensor.md)

### 效果预览

依次介绍sample具有什么功能，怎样使用这些功能，以及使用后会达到什么效果；示例如下：

1. 在主界面，点击getSensorInfos按钮可以处理获取所有Sensor_Info信息，以及每个传感器的名称、类型、分辨率等等属性信息；
2. 在主界面，点击subscriber按钮可以处理订阅传感器的流程，以SENSOR_TYPE_ACCELEROMETER传感器为例。

工程目录

```
├── entry
│   └── src
│       └── main
│           ├── cpp                                 // C++代码区
│           │   ├── CMakeLists.txt                  // CMAKE配置文件
│           │   ├── oh_sensor_capi.cpp              // Native业务代码实现
│           │   └── types
│           │       └── libentry                    // C++接口导出
│           │           ├── Index.d.ts
│           │           └── oh-package.json5
│           ├── ets                                 // ArkTS代码区
│           │   └── pages
│           │       └── Index.ets                   // 主页
```

### 具体实现

本样例展示了sensor模块capi接口的使用样例，包含订阅、去订阅、获取传感器信息以及各种实例的创建与销毁等接口功能，该功能全部接口已封装在oh_sensor_capi.cpp，源码参考：[oh_sensor_capi.cpp](./entry/src/main/cpp/oh_sensor_capi.cpp)


### 相关权限

附上使用到的权限和链接，示例如下：

[ohos.permission.ACCELEROMETER](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md)

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
echo code/BasicFeature/DeviceManagement/Sensor/SensorCapiSamples/ > .git/info/sparse-checkout  
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git  
git pull origin master
```