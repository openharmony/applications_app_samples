# 音乐播放器项目

### 介绍

音乐播放器应用使用 fileIo 获取指定音频文件，并通过 AudioPlayer 完成了音乐的播放、暂停、上一曲、下一曲功能；并使用 DeviceManager 完成了分布式设备列表的显示和分布式能力完成了音乐播放状态的跨设备分享。

音乐播放器应用为 TV 形态的分布式音乐播放器应用，适配电视端遥控器交互和大屏界面展示。

使用说明：

1. **音乐播放**，点击**播放**、**暂停**、**上一曲**、**下一曲**按钮可以对音乐进行操作。
2. **跨设备分享**，组网并且双端均已授权条件下，点击**分享**按钮，选择设备，拉起对端设备上的音乐，并将本端的播放状态同步到对端上。
3. **跨设备停止分享**，分享成功前提条件下，点击**停止分享**按钮，将对端设备拉起的音乐应用停止退出。

### 截图预览
| 首页                              |
|--------------------------------------|
|![](./screenshots/device/distributedMusicPlayer.png)|

### 工程目录
```text
entry/src/main/ets/
|---Application
|   |---AbilityStage.ets                 // 应用生命周期入口
|---MainAbility
|   |---MainAbility.ets                  // 主 Ability
|---common
|   |---MusicSharedDefinition.ets        // 定义音乐播放器状态
|   |---MusicConstants.ets               // 音乐常量定义
|   |---DeviceDialog.ets                 // 分布式设备列表弹窗
|   |---EventUtil.ets                    // 事件工具
|   |---PointerUtil.ets                  // 指针工具
|---const
|   |---Type.ets                         // 类型常量定义
|---model
|   |---MusicPlayer.ets                  // 播放器模块
|   |---KvStoreModel.ets                 // KVStore 对象操作类
|   |---RemoteDeviceModel.ets            // 远程设备操作类
|   |---Music.ets                        // 音乐数据模型
|   |---PlayState.ets                    // 播放状态模型
|   |---ButtonModel.ets                  // 按钮状态模型
|---pages
|   |---Index.ets                        // 首页
|---serviceability
|   |---ServiceAbility.ets               // 服务 Ability（后台拉起）
|---utils
|   |---Utils.ets                        // 工具类
|   |---Preferences.ets                  // 偏好设置管理
|   |---Logger.ets                       // 日志工具
|   |---Log.ets                          // 日志记录
```

### 具体实现

在分布式音乐播放器中，分布式设备管理包含了分布式设备搜索、分布式设备列表弹窗、远端设备拉起三部分。
首先在分布式组网内搜索设备，然后把设备展示到分布式设备列表弹窗中，最后根据用户的选择拉起远端设备。

通过 SUBSCRIBE_ID 搜索分布式组网内的远端设备，详见 registerDeviceListCallback 模块 [源码参考](entry/src/main/ets/model/RemoteDeviceModel.ets)。

使用 @CustomDialog 弹出分布式设备列表弹窗，参考 [DeviceDialog.ets](entry/src/main/ets/common/DeviceDialog.ets)。

通过 startAbility(deviceId) 方法拉起远端设备的包，参考 [MainAbility.ets](entry/src/main/ets/MainAbility/MainAbility.ets)。

(1) 管理分布式数据库
创建一个 KVManager 对象实例，用于管理分布式数据库对象。通过 distributedData.createKVManager(config)，并通过指定 Options 和 storeId，创建并获取 KVStore 数据库，并通过 Promise 方式返回，此方法为异步方法，例如 `this.kvManager.getKVStore(STORE_ID, options).then((store) => {})`。

(2) 订阅分布式数据变化
通过订阅分布式数据库所有（本地及远端）数据变化实现数据协同，参考 [KvStoreModel.ets](entry/src/main/ets/model/KvStoreModel.ets)。

(1) 分布式设备管理器绑定应用包
`deviceManager.createDeviceManager('ohos.samples.distributedmusicplayer')`，参考 [RemoteDeviceModel.ets](entry/src/main/ets/model/RemoteDeviceModel.ets)。

(2) 初始化播放器
构造函数中通过 `@ohos.multimedia.media` 组件对播放器进行实例化，并调用播放器初始化函数，通过播放器的 on 函数，监听 error、finish、timeUpdate。

(3) 同步当前播放数据
播放器通过调用 selectedIndexChange()，将当前播放的资源、时间、以及播放状态同步给选中的设备。

(4) 接收当前播放数据
播放器通过在 aboutToAppear() 时调用 `this.restoreFromWant()`，KvStoreModel 组件获取播放列表，MusicPlayer 组件重新加载播放器状态和资源。

通过 ServiceAbility 实现后台远程服务通信，支持分布式音乐播放的后台拉起，参考 [ServiceAbility.ets](entry/src/main/ets/serviceability/ServiceAbility.ets)。

### 相关权限

| 权限名                                   | 权限说明                     |
|---------------------------------------|--------------------------|
| ohos.permission.DISTRIBUTED_DATASYNC | 允许不同设备间的数据交换           |
| ohos.permission.START_ABILITIES_FROM_BACKGROUND | 允许音乐服务后台拉起音乐页面       |
| ohos.permission.START_INVISIBLE_ABILITY | 允许应用进行调用，无论 Ability 是否可见 |
| ohos.permission.ACCESS_SERVICE_DM | 允许访问分布式设备管理服务          |
| ohos.permission.READ_AUDIO | 允许读取音频文件               |
| ohos.permission.WRITE_AUDIO | 允许写入音频文件               |
| ohos.permission.INTERNET | 允许访问网络                 |
| ohos.permission.FILE_ACCESS_MANAGER | 允许访问文件管理               |
| ohos.permission.VIBRATE | 允许控制振动                 |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED | 允许获取 Bundle 信息         |

### 依赖

- 测试框架：Hypium（`entry/src/ohosTest`）

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568、大屏 TV 设备。

2. 本示例完整功能必须双端授予允许使用分布式协同能力，否则在只有发起端授权条件下，发起端会弹框提示错误。

3. 本示例为 Stage 模型，已适配 API version 12 版本 SDK，SDK 版本号 (API Version 12 Release)，镜像版本号 (5.0 Release)。

4. 本示例需要使用 DevEco Studio 版本号 (5.0 Release) 及以上版本才可编译运行。

5. 本示例需要使用 `@ohos.distributedDeviceManager` 系统权限的系统接口。使用 Full SDK 时需要手动从镜像站点获取，并在 DevEco Studio 中替换，具体操作可参考[替换指南](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)。

6. 本示例中需要使用特殊安装，需要将本示例加入到白名单中再进行安装。详细内容如下：
```json
{
    "bundleName": "ohos.samples.distributedmusicplayer",
    "app_signature" : [],
    "allowAppUsePrivilegeExtension": true
}
```

### 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/SystemFeature/TV/TVDistributedMusicPlayer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
