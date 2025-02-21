# NFC标签读写开发指南

### 介绍

本示例通过使用[NFC标签读写开发指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/connectivity/nfc/nfc-tag-access-guide.md)中各场景的开发示例，展示在工程中，帮助开发者更好地理解NFC标签读写功能并合理使用。该工程中展示的代码详细描述可查如下链接：
[NFC标签读写开发指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/connectivity/nfc/nfc-tag-access-guide.md)

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
entry/src/main/ets/   # 前台读取标签
|---entryability
|   |---EntryAbility.ets
|---entrybackupability
|   |---EntryBackupAbility.ets        
|---pages
|   |---Index.ets
entry1/src/main/ets/  # 后台读取标签
|---entryability
|   |---EntryAbility.ets
|---entrybackupability
|   |---EntryBackupAbility.ets        
|---pages
|   |---Index.ets
```

### 具体实现

#### 前台读取标签

1. 在module.json5文件中声明NFC标签读取的权限，以及声明NFC标签特定的action。
2. import需要的tag模块和其他相关的模块。
3. 判断设备是否支持NFC能力。
4. 调用tag模块中前台优先的接口，使能前台应用程序优先处理所发现的NFC标签功能。
5. 获取特定技术类型的NFC标签对象。
6. 执行读写接口完成标签数据的读取或写入数据到标签。
7. 退出应用程序NFC标签页面时，调用tag模块退出前台优先功能。

#### 后台读取标签

1. 在module.json5文件中声明NFC标签读取的权限，声明NFC标签特定的action，以及声明本应用程序的能够处理的NFC标签技术类型。
2. import需要的tag模块和其他相关的模块。
3. 获取特定技术类型的NFC标签对象。
4. 执行读写接口完成标签数据的读取或写入数据到标签。

### 相关权限

[ohos.permission.NFC_TAG](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionnfc_tag)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.57。

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/NFC/NFCReadAndWrite/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````