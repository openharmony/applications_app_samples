# 分布式数据对象多端协同 (DataObject)指南文档示例

### 介绍


本示例通过调用端拉起对端Ability后创建分布式数据对象并加入组网，被调用端被拉起后创建和恢复分布式数据对象。

### 效果预览

不涉及页面展示效果。

### 使用说明

1. 准备两台设备，一台作为发起端，一台作为接收端。

2. 使用IDE自动签名，编译，安装（两台设备都需要安装）。

3. 两台设备登录同一个华为账号，连接同一个wifi。

4. 发起端设备保存数据到分布式数据对象，并将分布式数据对象同步给接收端设备，对端能够感知到数据变化。

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

* 调用端调用startAbilityByCall接口拉起对端Ability：
    
    * 调用genSessionId接口创建一个sessionId，通过分布式设备管理接口获取对端设备networkId。

    * 组装want，并将sessionId放入want。

    * 调用startAbilityByCall接口拉起对端Ability。

* 调用端拉起对端Ability后创建分布式数据对象并加入组网：
    
    * 创建分布式数据对象实例。

    * 注册数据变更监听。

    * 设置同步sessionId加入组网。

* 被调用端被拉起后创建和恢复分布式数据对象：
    
    * 创建分布式数据对象实例。

    * 注册数据变更监听。

    * 从want中获取源端放入的sessionId，使用这个sessionId加入组网。


### 相关权限

ohos.permission.DISTRIBUTED_DATASYNC。

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
echo code/DocsSample/ArkData/DataObject/CrossDeviceCollaboration > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````