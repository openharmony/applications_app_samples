# 驱动开发服务

### 介绍

本示例主要展示了通过DriverDevelopmentKit开发套件中SCSI DDK开发驱动服务，使用[@ohos.driver.deviceManager](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-driverdevelopment-kit/js-apis-driver-deviceManager.md) 、[@ohos.app.ability.DriverExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-driverdevelopment-kit/js-apis-app-ability-driverExtensionAbility.md) 、[@ohos.rpc](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ipc-kit/js-apis-rpc.md)、[SCSI DDK](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-driverdevelopment-kit/capi-usb-ddk-api-h.md)
等接口，实现了整个SCSI存储设备驱动功能，包括SCSI存储设备UI参数设置界面及驱动服务端。其中UI参数界面包括按键设置、区域设置、关于界面、保存按钮、tokenID界面，驱动服务端通过客户端绑定拉起，驱动服务端主要给UI参数界面提供接口及与物理设备通信;

### 效果预览

| 主页(设备参数)                       | 常用命令                                | 通用命令                              |
|--------------------------------|-------------------------------------|-----------------------------------|
| ![image](screenshots/main.png) | ![image](screenshots/usual_cmd.png) | ![image](screenshots/com_cmd.png) |

使用说明

1. 安装该示例应用后，当目标设备插入时，扩展外设驱动服务SA会拉起DriverExtensionAbility相关进程（即：驱动服务端）
2. 在主界面绘制完成后，会调用deviceManager的绑定接口，绑定驱动服务端，成功后主界面会显示“设备已连接”；
3. 主界面会读取SCSI存储设备的基本信息，包括制造商，产品标识，产品版本，容量等；
4. 常用命令界面可以使用SCSI的常用命令，包括Inquery等，通过常用命令与物理设备通信；
5. 通用命令界面可以构建通用命令，与物理设备使用通用命令通信；
6. 退出按钮，退出驱动界面。

### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets
|---components
|   |---ComCommandComponent.ets            //“通用命令”部件页面构造
|   |---DevParamsComponent.ets             //“设备参数”部件页面构造
|   |---SendCommandComponent.ets           //“常用命令”部件页面构造
|---DriverAbility
|   |---driver.ts                          //主要重载了继承驱动扩展能力DriverExtensionAbility，Onit初始化USB接口等
|---entryability
|   |---EntryAbility.ets                   //界面ability
|---pages
|   |---Index.ets                          //应用首页
|---tool
|   |---GlobalContext.ets                  //用于上下文存储单例对象工具
|   |---RpcTool.ets                        //主要封装了扩展外设相关接口，实现相关功能，如：查询设备，绑定设备，连接远程对象等
|---utils
|   |---DevParams.ets                      //设备信息结构
|   |---RequestCode.ets                    //请求码
entry/src/main/cpp
|---types
|   |---libentry                           //创建native c++工程，自动生成的文件目录
|---hello.cpp                              //主要封装了SCSI存储驱动相关接口，实现相关功能，如：发送Inquery命令等功能
```

### 具体实现

* 驱动UI界面，功能包括查询设备列表、绑定设备驱动服务端、与设备驱动服务端通信，源码参考：[Index.ets](code/DocsSample/DriverDevelopmentKit/ScsiPeripheralDemo/entry/src/main/ets/pages/Index.ets)
    * 使用deviceManager.queryDevices来获取设备列表;
    * 通过deviceManager.bindDeviceDriver来绑定设备驱动服务端，通过返回值拿到驱动服务端实例;
    * 通过服务端实例调用sendMessageRequest与设备驱动服务端通信，并获取到服务端回应，将回应数据打印到主界面;

* 驱动服务端，与驱动UI界面通信，源码参考：[driver.ts](code/DocsSample/DriverDevelopmentKit/ScsiPeripheralDemo/entry/src/main/ets/driverability/driver.ts)
    * 当物理设备插入后，UI界面通过bindDeviceDriver接口获取到驱动服务端实例，再通过服务端实例与服务端通信；
    * 驱动服务拉起后，会调用DriverExtAbility中onInit方法，可以在此方法中通过Napi接口调用CAPI，初始化USB DDK等
    * 驱动UI界面通过deviceManager调用绑定接口，会调用DriverExtAbility中onConnect返回服务端实例
    * 驱动UI界面通过服务端实例与服务端通信，服务端通过Napi接口调用CAPI，与物理设备通信

### 相关权限

[ohos.permission.ACCESS_EXTENSIONAL_DEVICE_DRIVER](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md)    
[ohos.permission.ACCESS_DDK_SCSI_PERIPHERAL](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/restricted-permissions.md)

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568;
2. 本示例为Stage模型，仅支持API18版本SDK，SDK版本号(API Version 18),镜像版本号(5.1Release)
3. 本示例需要使用DevEco Studio 版本号(6.0Release)版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/DriverDevelopmentKit > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```