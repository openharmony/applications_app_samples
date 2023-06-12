# 蜂窝数据

### 介绍

本示例通过获取SIM卡相关信息，展示打开本应用时网络信息。

本示例使用 [@Builder](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/arkts-builder.md) 在一个自定义组件内快速生成多个布局内容。

本示例使用 [SystemCapability.Telephony.CellularData系统能力](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-telephony-data.md) 获取SIM卡信息及网络信息。

### 效果预览

|主页|
|--------------------------------|
|![](screenshots/device/index.png)|

使用说明：

1.默认移动数据的SIM卡背景色显示为蓝色。

2.若已经开启移动数据，则显示开启，否则显示为关闭。

3.若已经开启漫游服务，则显示开启，否则显示为关闭。

4.显示打开本应用时数据流类型及连接状态。

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---AbilityStage.ts
|---common
|   |---NetWork.ets                    // 网络连接
|---MainAbility
|   |---MainAbility.ts
|---model
|   |---NetworkMobile.ts               // 蜂窝数据
|   |---Logger.ts                      // 日志工具
|---pages
|   |---Index.ets                      // 首页
```
### 具体实现

* 该示例使用蜂窝数据接口，getDefaultCellularDataSlotId方法获取默认移动数据的SIM卡，isCellularDataEnabled方法检查蜂窝数据业务是否启用，isCellularDataRoamingEnabled方法检查蜂窝数据业务是否启用漫游，getCellularDataFlowType方法获取蜂窝数据业务的上下行状态，getCellularDataState方法获取分组交换域（PS域）的连接状态等方法获取SIM卡相关信息，展示打开本应用时网络信息。
* 源码链接：[NetWork.ets](entry/src/main/ets/common/NetWork.ets)，[NetworkMobile.ts](entry/src/main/ets/model/NetworkMobile.ts)
* 接口参考：[@ohos.telephony.data](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-telephony-data.md)

### 依赖

不涉及。

### 相关权限

网络服务：[ohos.permission.GET_NETWORK_INFO](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionget_network_info)

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：仅支持部分机型。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

4.本示例需设备支持SIM卡功能，且插入SIM卡。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Telephony/MobileNetwork/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```