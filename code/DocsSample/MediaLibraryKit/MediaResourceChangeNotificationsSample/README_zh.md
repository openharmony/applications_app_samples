# 媒体资源变更通知示例

## 简介

本示例展示了如何使用[@kit.MediaLibraryKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/medialibrary/Readme-CN.md)中的photoAccessHelper模块来监听媒体资源的变化。通过注册监听器，应用可以实时响应媒体库中资源的增删改操作。

本示例使用的核心包包括：
- [@kit.MediaLibraryKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/medialibrary/Readme-CN.md) - 提供photoAccessHelper模块用于媒体资源访问和变更监听
- [@kit.ArkData](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/database/Readme-CN.md) - 数据共享和观察者模式支持

## 使用说明

1. 启动应用后，在主界面可以看到多个监听选项；
2. 点击"监听图片资源变化"按钮，可以为特定图片资源注册监听器；
3. 点击"监听相册资源变化"按钮，可以监听相册的变更；
4. 点击"监听全部资源变化"按钮，可以监听所有媒体资源的变化；
5. 点击"取消监听"按钮，可以注销已注册的监听器；
6. 当监听的资源发生变化时，应用会收到回调通知并显示变更信息。

## 工程目录
```
entry/src/main/ets/
├─entryability
│  └─EntryAbility.ets                                    # 应用入口
├─entrybackupability
│  └─EntryBackupAbility.ets                              # 备份能力
├─cancellisteninguriability
│  └─CancelListeningURIAbility.ets                       # 取消URI监听功能
├─registerformonitoringallassetsability
│  └─RegisterForMonitoringAllAssetsAbility.ets           # 监听所有资源变化功能
├─registerlistenertoalbumability
│  └─RegisterListenerToAlbumAbility.ets                  # 监听相册变化功能
├─registerlistenertophotoassetability
│  └─RegisterListenerToPhotoAssetAbility.ets             # 监听图片资源变化功能
└─pages
   └─Index.ets                                           # 主界面
entry/src/main/resources/
└─rawfile
   └─test.jpg                                            # 测试图片资源
entry/src/ohosTest/ets/
├─test
│  ├─CancelListeningURI.test.ets                         # 取消监听测试用例
│  ├─RegisterForMonitoringAllAssets.test.ets             # 监听所有资源测试用例
│  ├─RegisterListenerToAlbum.test.ets                    # 监听相册测试用例
│  ├─RegisterListenerToPhotoAsset.test.ets               # 监听图片资源测试用例
│  └─List.test.ets                                       # 测试用例列表
└─Provider.ets                                           # 测试数据提供者
```

## 具体实现

### 1. 注册URI变更监听

使用photoAccessHelper的registerChange接口来监听特定URI的变更，源码参考：[RegisterListenerToPhotoAssetAbility.ets](entry/src/main/ets/registerlistenertophotoassetability/RegisterListenerToPhotoAssetAbility.ets)

- 获取PhotoAccessHelper实例：使用photoAccessHelper.getPhotoAccessHelper()获取实例；
- 获取媒体资源：通过photoAccessHelper.getAssets()获取需要监听的媒体资源；
- 注册监听器：调用photoAccessHelper.registerChange()注册URI变更回调，当资源发生变化时接收通知；
- 处理变更通知：在回调函数中处理ChangeData对象，获取变更类型和变更的URI信息。

### 2. 监听相册变化

监听相册的创建、删除、重命名等操作，源码参考：[RegisterListenerToAlbumAbility.ets](entry/src/main/ets/registerlistenertoalbumability/RegisterListenerToAlbumAbility.ets)

- 获取相册对象：使用photoAccessHelper.getAlbums()获取相册列表；
- 注册相册监听：调用registerChange()并传入相册URI，设置forChildUris参数控制监听范围；
- forChildUris为true时监听相册内文件的变化，为false时仅监听相册本身的变化。

### 3. 监听所有媒体资源

使用DefaultChangeUri监听所有PhotoAsset的变化，源码参考：[RegisterForMonitoringAllAssetsAbility.ets](entry/src/main/ets/registerformonitoringallassetsability/RegisterForMonitoringAllAssetsAbility.ets)

- 使用默认URI：调用photoAccessHelper.DefaultChangeUri获取默认监听URI；
- 全局监听：注册DefaultChangeUri的监听器，forChildUris必须设置为true；
- 接收所有变更：任何PhotoAsset的增删改操作都会触发回调通知。

### 4. 注销监听器

使用unRegisterChange停止监听特定URI的变更，源码参考：[CancelListeningURIAbility.ets](entry/src/main/ets/cancellisteninguriability/CancelListeningURIAbility.ets)

- 注销特定回调：调用unRegisterChange()并传入URI和回调函数，注销指定的监听器；
- 注销所有回调：调用unRegisterChange()仅传入URI参数，注销该URI上的所有监听器；
- 防止内存泄漏：在不需要监听时及时注销监听器。

## 相关权限

- ohos.permission.READ_IMAGEVIDEO - 读取媒体资源时需要
- ohos.permission.WRITE_IMAGEVIDEO - 修改或删除媒体资源时需要

## 依赖

无

## 约束与限制

1. 本示例仅支持标准系统上运行；
2. 本示例支持API23版本SDK，版本号：6.1.0.23；
3. 本示例需要使用DevEco Studio 6.0.0 Canary1（构建版本：6.0.0.63，构建于2025年10月30日）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/DocsSample/MediaLibraryKit/MediaResourceChangeNotificationsSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```