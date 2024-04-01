# 分布式音乐播放

### 介绍

本示例使用fileIo获取指定音频文件，并通过AudioPlayer完成了音乐的播放完成了基本的音乐播放、暂停、上一曲、下一曲功能；并使用DeviceManager完成了分布式设备列表的显示和分布式能力完成了音乐播放状态的跨设备迁移。

本示例用到了与用户进行交互的Ability的能力接口[@ohos.ability.featureAbility](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-ability-featureAbility.md)

文件存储管理能力接口[@ohos.fileio](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileio.md)

屏幕属性接口[@ohos.display](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-display.md#displaygetdefaultdisplaydeprecated)

管理窗口能力接口[@ohos.window](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/js-apis-window.md)

分布式数据管理接口[@ohos.data.distributedData](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkdata/js-apis-distributed-data.md)

音视频相关媒体业务能力接口[@ohos.multimedia.media](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-kit/js-apis-media.md)

分布式设备管理能力接口(设备管理)，实现设备之间的kvStore对象的数据传输交互[@ohos.distributedDeviceManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-distributedservice-kit/js-apis-distributedDeviceManager.md)

### 效果预览
| 首页                              |
|--------------------------------------|
| ![](./screenshots/device/music2.png) |

使用说明

1.**音乐播放**，点击**播放**、**暂停**、上**一曲**、下**一曲**按钮可以对音乐进行操作。

2.**跨设备迁移播放**，组网条件下，点击**流转**按钮，选择设备，拉起对端设备上的音乐，本端退出。


#### 相关概念

音频播放：媒体子系统包含了音视频相关媒体业务，通过AudioPlayer实现音频播放的能力。

数据流转：分布式数据管理为应用程序提供不同设备间数据库的分布式协同能力。通过调用分布式数据各个接口，应用程序可将数据保存到分布式数据库中，并可对分布式数据库中的数据进行增/删/改/查等各项操作。

### 工程目录
```
entry/src/main/ets/
|---pages/index
|   |---index.css                           // 首页样式
|   |---index.hml                           // 首页结构
|   |---index.js                            // 首页逻辑
|---model                                  
|   |---PlayerModel.js                      // 播放器模块
|   |---KvStoreModel.js                     // kvstore对象操作类
|   |---RemoteDeviceModel.js                // 远程设备操作类
|---common/media                            // 存放播放器图片资源                                                                
```

### 具体实现
在分布式音乐播放器中，分布式设备管理包含了分布式设备搜索、分布式设备列表弹窗、远端设备拉起三部分。  
首先在分布式组网内搜索设备，然后把设备展示到分布式设备列表弹窗中，最后根据用户的选择拉起远端设备。
#### 分布式设备搜索
通过SUBSCRIBE_ID搜索分布式组网内的远端设备，详见registerDeviceListCallback_(callback) {}模块[源码参考](entry/src/main/js/MainAbility/model/RemoteDeviceModel.js )。
#### 分布式设备列表弹窗
使用continueAbilityDialog弹出分布式设备列表弹窗，参考首页。
#### 远端设备拉起
通过startAbility(deviceId)方法拉起远端设备的包，[源码参考](entry/src/main/js/MainAbility/pages/index/index.js )。
#### 分布式数据管理
(1) 管理分布式数据库  
创建一个KVManager对象实例，用于管理分布式数据库对象。通过distributedData.createKVManager(config)，并通过指定Options和storeId，创建并获取KVStore数据库，并通过Promise方式返回，此方法为异步方法，例如this.kvManager.getKVStore(STORE_ID, options).then((store) => {})  
(2) 订阅分布式数据变化  
通过订阅分布式数据库所有（本地及远端）数据变化实现数据协同[源码参考](entry/src/main/js/MainAbility/model/KvStoreModel.js )。

#### 跨设备播放操作
(1)分布式设备管理器绑定应用包
deviceManager.createDeviceManager('ohos.samples.distributedmusicplayer') [源码参考](entry/src/main/js/MainAbility/model/RemoteDeviceModel.js )。  
(2) 初始化播放器
构造函数中通过'@ohos.multimedia.media'组件对播放器进行实例化，并调用播放器初始化函数，通过播放器的on函数，监听error、finish、timeUpdate  
(3) 同步当前播放数据
播放器通过onRadioChange(),将当前播放的资源、时间、以及播放状态同步给选中的设备。  
(4) 接收当前播放数据
播放通过onNewRequest()，调用this.restoreFromWant(), featureAbility获取want参数，kvstore组件获取播放列表，playerModel组件重新加载播放器状态和资源。


### 相关权限

允许不同设备间的数据交换：[ohos.permission.DISTRIBUTED_DATASYNC](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissiondistributed_datasync)

允许系统应用获取分布式设备的认证组网能力：[ohos.permission.ACCESS_SERVICE_DM](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionaccess_service_dm)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.992, built on July 14, 2022)才可编译运行。

3.如果安装本示例报错为error：install sign info inconsistent，则有可能本应用被设置为系统预置应用，已安装在系统中，此时需使用命令进行替换安装，并在替换安装后对设备进行重启操作，具体命令如下：

hdc shell mount -o rw,remount /

hdc file send ./entry-default-signed.hap /system/app/com.ohos.distributedmusicplayer/Music_Demo.hap

hdc shell  reboot

等设备重启后即可完成应用的替换安装，无需其他操作。

4.本示例需要使用@ohos.distributedDeviceManager系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SuperFeature/DistributedAppDev/JsDistributedMusicPlayer/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```