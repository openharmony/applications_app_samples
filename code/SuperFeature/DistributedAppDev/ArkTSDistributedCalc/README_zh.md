# 分布式计算器

### 介绍

本示例使用分布式能力实现了一个简单的计算器应用，可以进行简单的数值计算，支持远程拉起另一个设备的计算器应用，两个计算器应用进行协同计算。

远程拉起：通过StartAbility实现远端应用的拉起。

协同计算：通过DistributedDataKit分布式数据框架实现异端应用的数据同步。  

本示例用到了媒体查询接口[@ohos.mediaquery](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/js-apis-mediaquery.md)。  

分布式设备管理能力接口(设备管理)，实现设备之间的kvStore对象的数据传输交互[@ohos.distributedHardware.deviceManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-distributedservice-kit/js-apis-distributedDeviceManager.md)。  

分布式数据管理接口[@ohos.data.distributedData](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkdata/js-apis-distributed-data.md)。  

### 效果预览
|首页|
|-------|
|![](./screenshots/device/calc.png)|

使用说明

1.点击桌面应用图标，启动应用。

2.点击应用右上角按钮，或者在界面任意位置滑动（上下左右滑动皆可）即可弹出设备选择框。

3.在设备选择框中点击对端设备名称，拉起对端应用。

4.对端应用启动后，可在任意一端中操作应用，两端应用可实现数据实时同步。

5.在设备选择框中选中本机即可关闭对端应用。

#### 相关概念

数据管理实例： 用于获取KVStore的相关信息。

单版本分布式数据库：继承自KVStore，不对数据所属设备进行区分，提供查询数据和同步数据的方法。

### 工程目录
```
entry/src/main/ets/
|---pages
|   |---index.ets                           // 首页
|---model                                  
|   |---Calculator.ts                       // 计算器模块
|   |---ImageList.ets                       // 计算器图片资源模块
|   |---KvStoreModel.ets                    // kvstore对象操作类
|   |---RemoteDeviceModel.ets               // 远程设备操作类
|---common                                    
|   |---ButtonComponent.ets                 // 按钮模块
|   |---ButtonComponentHorizontal.ets       // 水平按钮模块(用来定义样式)
|   |---DeviceDialog.ets                    // 分布式设备列表弹窗
|   |---InputComponent.ets                  // 输入数字显示模块 
|   |---TitleBarComponent.ets               // 菜单栏模块(包含远端设备拉起)                                                           
```

### 具体实现
在分布式计算器应用中，分布式设备管理包含了分布式设备搜索、分布式设备列表弹窗、远端设备拉起三部分。  
首先在分布式组网内搜索设备，然后把设备展示到分布式设备列表弹窗中，最后根据用户的选择拉起远端设备。
#### 分布式设备搜索
通过SUBSCRIBE_ID搜索分布式组网内的远端设备，详见startDeviceDiscovery(){}模块[源码参考](entry/src/main/ets/model/RemoteDeviceModel.ets )。
#### 分布式设备列表弹窗
使用@CustomDialog装饰器来装饰分布式设备列表弹窗，[源码参考](entry/src/main/ets/common/DeviceDialog.ets )。
#### 远端设备拉起
通过startAbility(deviceId)方法拉起远端设备的包，[源码参考](entry/src/main/ets/common/TitleBarComponent.ets )。
#### 分布式数据管理
(1) 管理分布式数据库  
创建一个KVManager对象实例，用于管理分布式数据库对象。通过distributedData.createKVManager(config)，并通过指定Options和storeId，创建并获取KVStore数据库，并通过Promise方式返回，此方法为异步方法，例如this.kvManager.getKVStore(STORE_ID, options).then((store) => {})，[源码参考](entry/src/main/ets/model/KvStoreModel.ets )。
(2) 订阅分布式数据变化  
通过订阅分布式数据库所有（本地及远端）数据变化实现数据协同，[源码参考](entry/src/main/ets/model/KvStoreModel.ets )。

#### 计算器模块
1、监听变化：通过this.listener.on('change', this.onLand)监听当前设备按钮状态，当改变时通过getContext(this).requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'])获取不同设备间的数据交换权限。  
2、判断设备状态：当AppStorage.Get('isRemote')==='isRemote'时，将isDistributed状态置为true。
3、订阅分布式数据变化： 通过kvStoreModel.setOnMessageReceivedListener(DATA_CHANGE, (value) => {}，其中根据isDistributed的值决定如何操作分布式计算器：为true时且输入的值不是EXIT状态把值放进expression中进行数据计算，当输入的值为空时，将expression的值置空。    
4、特殊功能按钮：
* 当用户点击C按钮，表达式和运算结果归0。 将this.expression = ''; this.result = '';[源码参考](entry/src/main/ets/pages/Index.ets ) 。
* 当用户点击“X”按钮后，删除运算表达式的最后一个字符。
* 当用户点击“=”按钮后，将调用calc(this.expression)对表达式进行数据计算。


### 相关权限

允许不同设备间的数据交换：[ohos.permission.DISTRIBUTED_DATASYNC](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissiondistributed_datasync)

允许系统应用获取分布式设备的认证组网能力：[ohos.permission.ACCESS_SERVICE_DM](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionaccess_service_dm)

### 依赖

不涉及

### 约束与限制

1.本示例只实现简单的加减乘除功能，后续开发者可基于当前框架考虑在calc页面中实现更多的功能，如开方、立方、三角函数等科学计算功能。

2.分布式计算功能使用的前提是分布式组网。

3.本示例已适配API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

4.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

5.本示例需要使用@ohos.distributedHardware.deviceManager系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SuperFeature/DistributedAppDev/ArkTSDistributedCalc/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```