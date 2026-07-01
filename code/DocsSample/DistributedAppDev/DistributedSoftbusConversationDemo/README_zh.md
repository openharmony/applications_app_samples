# 分布式软总线会话

### 介绍

本示例主要展示了分布式软总线会话相关的功能，使用[@ohos.distributedServiceKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-distributedservice-kit/js-apis-conversation-sys.md)
中 conversation 接口，实现了包括获取可信设备列表、注册/注销会话消息监听、跨设备发送消息等功能。

### 使用说明

1. 进入应用后会自动申请分布式数据同步和访问 UDID 的权限，授权后方可使用相关功能。
2. 在主界面，点击 **Get Trusted Devices** 按钮，获取当前组网环境下的可信设备列表，设备信息（设备名称、networkId、设备类型、是否为附近设备）会输出到日志中。
3. 点击 **Register Listener** 按钮，注册会话消息监听器，用于接收其他设备发送的消息；点击 **Unregister Listener** 按钮，注销已注册的监听器。
4. 点击 **Send Message** 按钮，向指定设备（需将源码中的 deviceId 替换为目标设备的 networkId 或 UDID）发送一条测试消息。接收端需已注册监听器，收到的消息内容会输出到日志中。

### 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets                       // 程序入口类
|---entrybackupability
|   |---EntryBackupAbility.ets                 // 备份能力
|---pages
    |---Index.ets                              // 主界面
```

### 具体实现

获取可信设备列表、注册/注销会话监听、跨设备发送消息等功能均在 Index 页面中实现，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)

    * 获取可信设备列表：调用 conversation.getTrustedDevices() 获取组网环境下的可信设备列表，返回 DeviceNodeInfo 数组，包含设备名称、networkId、设备类型、是否为附近设备等信息；
    * 注册会话监听器：调用 conversation.registerConversationListener(bundleName, abilityName, callback) 注册消息回调，当其他设备向本设备发送消息时，会触发回调接收消息；
    * 注销会话监听器：调用 conversation.unregisterConversationListener(bundleName, abilityName) 注销已注册的监听器；
    * 发送消息：调用 conversation.postConversationData(deviceId, bundleName, abilityName, data) 向指定设备发送 ArrayBuffer 类型的消息数据。

### 相关概念

分布式软总线会话：基于分布式软总线提供的会话能力，可实现跨设备的数据传输。应用通过注册监听器接收来自其他设备的消息，并可通过 postConversationData 接口向指定设备发送消息，实现设备间的实时通信。

### 相关权限

- 允许不同设备间的数据交换：[ohos.permission.DISTRIBUTED_DATASYNC](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissiondistributed_datasync)

E:\lihongyi\docs\zh-cn\application-dev\
- 允许获取设备 UDID：[ohos.permission.sec.ACCESS_UDID](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-enterprise-apps.md#ohospermissionsecaccess_udid)

### 约束与限制

1. 本示例需要组网测试，使用两台及以上设备登录同一账号并组网后进行验证。

2. 本示例仅支持标准系统上运行，支持设备：RK3568。

3. 本示例仅支持 Stage 模型，依赖 API 26.1.0 及以上版本 SDK。

4. 本示例需要使用 DevEco Studio 版本号(5.0 Release)及以上版本才可编译运行。

5. 本示例中发送消息功能需要将 Index.ets 中的 deviceId 替换为目标设备的 networkId 或 UDID（可通过 getTrustedDevices 获取），bundleName 和 abilityName 需与接收端应用保持一致。

6. 本示例使用的 conversation 接口为系统接口（@systemapi），需要配置系统应用签名，可以参考[特殊权限配置方法](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/hapsigntool-overview.md)
，把配置文件中的"app-feature"字段信息改为"hos_system_app"。

7. 本示例涉及权限 ohos.permission.DISTRIBUTED_DATASYNC 和 ohos.permission.sec.ACCESS_UDID，需在 module.json5 中声明并在运行时动态申请。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/DistributedAppDev/DistributedSoftbusConversationDemo > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
