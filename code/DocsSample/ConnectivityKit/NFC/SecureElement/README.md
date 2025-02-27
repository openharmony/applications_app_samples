# 安全单元访问开发指南

### 介绍

本示例通过使用[安全单元访问开发指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/connectivity/nfc/nfc-se-access-guide.md)中各场景的开发示例，展示在工程中，帮助开发者更好地理解HEC功能并合理使用。该工程中展示的代码详细描述可查如下链接：
[安全单元访问开发指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/connectivity/nfc/nfc-se-access-guide.md)

### 效果预览
|启动界面|
|-------|
|<img src="./screenshots/image.jpeg" width="360;" /> |

### 使用说明

1.启动应用
2.应用停留在启动界面
3.输出预期日志，功能启动

### 工程目录
```
entry/src/main/ets/ 
|---entryability
|   |---EntryAbility.ets
|---entrybackupability
|   |---EntryBackupAbility.ets        
|---pages
|   |---Index.ets
```

### 具体实现

#### 应用程序访问安全单元
1. import需要的安全单元模块。
2. 判断设备是否支持安全单元能力。
3. 访问安全单元，实现数据的读取或写入。

### 相关权限

不涉及

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
echo code/DocsSample/ConnectivityKit/NFC/SecureElement/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````