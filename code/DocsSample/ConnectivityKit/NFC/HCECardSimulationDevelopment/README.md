# HCE卡模拟开发指南

### 介绍

本示例通过使用[HCE卡模拟开发指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/connectivity/nfc/nfc-hce-guide.md)中各场景的开发示例，展示在工程中，帮助开发者更好地理解HEC功能并合理使用。该工程中展示的代码详细描述可查如下链接：
[HCE卡模拟开发指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/connectivity/nfc/nfc-hce-guide.md)

### 效果预览
|启动界面|
|-------|
|<img src="./screenshots/image.jpeg" width="360;" /> |

### 使用说明

1.启动应用
2.应用停留在启动界面
3.输出预期日志，功能启动

### 工程目录
entry/src/main/ets/   # HCE应用前台刷卡
|---entryability
|   |---EntryAbility.ets
|---entrybackupability
|   |---EntryBackupAbility.ets        
|---pages
|   |---Index.ets
entry1/src/main/ets/  # HCE应用后台刷卡
|---entry1ability
|   |---Entry1Ability.ets
|---entry1backupability
|   |---Entry1BackupAbility.ets        
|---pages
|   |---Index.ets
```

### 具体实现

#### HCE应用前台刷卡
1. 在module.json5文件中声明NFC卡模拟权限，以及声明HCE特定的action。
2. import需要的NFC卡模拟模块和其他相关的模块。
3. 判断设备是否支持NFC能力和HCE能力。
4. 使能前台HCE应用程序优先处理NFC刷卡功能。
5. 订阅HCE APDU数据的接收。
6. 完成HCE刷卡APDU数据的接收和发送。
7. 退出应用程序NFC刷卡页面时，退出前台优先功能。

#### HCE应用后台刷卡
1. 在module.json5文件中声明NFC卡模拟权限，声明HCE特定的action，声明应用能够处理的AID。
2. import需要的NFC卡模拟模块和其他相关的模块。
3. 判断设备是否支持NFC能力和HCE能力。
4. 订阅HCE APDU数据的接收。
5. 完成HCE刷卡APDU数据的接收和发送。
6. 退出应用程序时，退出订阅功能。

### 相关权限

[ohos.permission.NFC_CARD_EMULATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionnfc_card_emulation)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.57。

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ConnectivityKit/NFC/HCECardSimulationDevelopment/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````