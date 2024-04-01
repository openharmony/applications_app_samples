# 分布式数据管理

### 介绍

本示例展示了在eTS中分布式数据管理的使用，包括KVManager对象实例的创建和KVStore数据流转的使用。  

通过设备管理接口[@ohos.distributedDeviceManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-distributedservice-kit/js-apis-distributedDeviceManager.md) ，实现设备之间的kvStore对象的数据传输交互，该对象拥有以下能力[详见](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-distributedservice-kit/js-apis-distributedDeviceManager.md) ;  
1、注册和解除注册设备上下线变化监听  
2、发现周边不可信设备  
3、认证和取消认证设备  
4、查询可信设备列表  
5、查询本地设备信息，包括设备名称，设备类型和设备标识  
6、发布设备发现

### 效果预览
|首页|
|-------|
|![main](screenshots/devices/main.png)|

使用说明

1.两台设备组网。

2.在一台界面中点击右上角的流转按钮，在弹窗中选择对端设备拉起对端设备上的应用。

3.拉起对端设备后，在界面中点击"+"按钮新增笔记卡片，点击每个卡片右上角的"X"按钮可以删除此卡片，可以看到对端设备和当前设备界面数据保持一致。

4.操作对端设备，当前设备界面也会保持和对端设备界面显示一致。

### 工程目录
```
entry/src/main/ets/
|---pages
|   |---index.ets                           // 首页
|---model                                  
|   |---DeviceDataModel.ets                 // 设备数据定义
|   |---KvStoreModel.ets                    // kvstore对象操作类
|   |---NoteDataModel.ets                   // 笔记数据定义
|   |---RemoteDeviceModel.ets               // 远程设备操作类
|---common                                  
|   |---BasicDataSource.ets                 // 笔记数据源操作                              
|   |---Dialog.ets                          // 设备管理对话框
|   |---NoteItem.ets                        // 笔记组件
|   |---TitleBar.ets                        // title组件                             
```

### 具体实现
#### 管理kvStore
1、页面初始化时获取此应用所需能力：引入@ohos.data.distributedKVStore初始化kvstore数据库并对使用kvstore.on数据change进行监听，通过appstorge判断获取相应的key判断是否是分布式节点，[源码](entry/src/main/ets/pages/Index.ets) 。
2、如果是分布式节点，如果数据发生变化，处理数据并使用.noteDataSource()进行reload数据。  
3、页面通过kvStore对象进行增删改查会触发其他已连接设备的kvStore.on监听。
#### 管理分布式设备（节点）
1、创建设备管理对象，并指定参数kvstore应用包deviceManager.createDeviceManager("ohos.samples.kvstore", (error, value) => {})  
2、获取可信设备列表，"this.deviceManager.getTrustedDeviceListSync())"  。
3、监听设备状态，"this.deviceManager.on('deviceStateChange', (data) => {})"，从而对可信设备列表管理。


### 相关权限

允许不同设备间的数据交换：[ohos.permission.DISTRIBUTED_DATASYNC](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissiondistributed_datasync) 。

允许系统应用获取分布式设备的认证组网能力：[ohos.permission.ACCESS_SERVICE_DM](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionaccess_service_dm)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

3.本示例已适配API version 9版本FULL SDK，版本号：3.2.11.9,使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md) 。

4.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

3.本示例需要使用[@ohos.distributedDeviceManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-distributedservice-kit/js-apis-distributedDeviceManager.md) 系统权限的系统接口。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SuperFeature/DistributedAppDev/Kvstore/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```