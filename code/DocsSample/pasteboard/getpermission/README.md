#  剪贴板指南Sample

### 介绍

 本示例通过使用[剪贴板指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/basic-services/pasteboard)中申请访问剪贴板权限场景的开发示例，展示开发步骤在工程中，帮助开发者更好地理解剪贴板模块代码合理使用。该工程中展示的代码详细描述可查如下链接：

[申请访问剪贴板权限](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/get-pastedata-permission-guidelines.md)。

### 工程目录

```
entry/src/main/ets/
|---entryAbility
|   |---EntryAbility.ets             // 开发步骤示例代码
|---entrybackupability
|---pages|
|   |---Index.ets
```

### 相关权限

申请ohos.permission.READ_PASTEBOARD允许应用访问剪贴板。

### 依赖

不涉及

### 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568，Phone;

2. 本示例支持API20版本SDK，版本号：6.0.0.49;

3. 本示例需要使用DevEco Studio 5.1.1 Release（5.1.1.840）及以上版本才可编译运行。

4. 本示例涉及调用系统权限的接口，需要配置允许权限列表，可以参考[申请访问剪贴板权限](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/get-pastedata-permission-guidelines.md)配置相关权限。

### 下载

如需单独下载本工程，执行如下命令：

    git init
    git config core.sparsecheckout true
    echo code/BasicFeature/DataManagement/pasteboard/ > .git/info/sparse-checkout
    git remote add origin https://gitee.com/openharmony/applications_app_samples.git
    git pull origin master
