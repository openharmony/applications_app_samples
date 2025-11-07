# 分布式数据对象跨端迁移 (DataObject)指南文档示例

### 介绍


本示例通过迁移发起端创建分布式数据对象并保存数据到接收端，接收端创建分布式数据对象并注册恢复状态监听，实现跨设备数据迁移。

### 效果预览

不涉及页面展示效果。

### 使用说明

1. 准备两台设备，一台作为发起端，一台作为接收端。

2. 使用IDE自动签名，编译，安装（两台设备都需要安装）。

3. 两台设备登录同一个华为账号，连接同一个wifi。

4. 发起端设备保存数据到分布式数据对象，并将分布式数据对象同步给接收端设备。

### 工程目录
```
entry/src/
|   |--- main/
|       |---ets/
|           |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|           |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|           |---pages/index.ets                 // entry主应用入口页面及接口调用实现
```


### 具体实现

* 迁移发起端在onContinue接口中创建分布式数据对象并保存数据到接收端：
    
    * 调用create接口创建并得到一个分布式数据对象实例。

    * 调用genSessionId接口创建一个sessionId，调用setSessionId接口设置同步的sessionId，并将这个sessionId放入wantParam。

    * 从wantParam获取接收端设备networkId，使用这个networkId调用save接口保存数据到接收端。

* 接收端在onCreate和onNewWant接口中创建分布式数据对象并注册恢复状态监听：
    
    * 调用create接口创建并得到一个分布式数据对象实例。

    * 调用genSessionId接口创建一个sessionId，调用setSessionId接口设置同步的sessionId，并将这个sessionId放入wantParam。

    * 从wantParam获取接收端设备networkId，使用这个networkId调用save接口保存数据到接收端。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.53，镜像版本号：OpenHarmony_6.0.0.53。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 5, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkData/DataObject/CrossDeviceMigration > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````