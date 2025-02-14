# 管理外置存储设备（仅对系统应用开放）

### 介绍

本示例主要展示了基于外置存储设备具备可插拔属性，使用卷设备管理，实现设备插拔事件的监听及挂载功能。该工程中展示的代码详细描述可查如下链接。

- [卷设备管理](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-volumemanager-sys.md)
- [管理外置存储设备](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/manage-external-storage.md)

### 效果预览

|主页|
|--------------------------------|
|<img src="PageImg\ManagingExternalStorage.jpeg" style="zoom: 33%;" width="400" />|

使用说明:

1. 在主界面，点击SubscribeBroadcastEvents按钮订阅广播事件。
2. 点击ReceiveBroadcastNotifications按钮接受广播通知。
3. 将携带的u盘插入到开发板。
4. 切换到Deveco日志，筛选到“No filter”，查询“volumeManager getVolumeById successfully”，出现以下类似日志：

```
volumeManager getVolumeById successfully, the volume state is 2, %{public}s
```

### 工程目录

```
├──entry/src/main
|	├──ets
|	|	├──common
|	|	|	└──Logger.ts 		        // 日志打印封装类
|	|	├──entryability
|	|	|	└──EntryAbility.ets 		// 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	└──pages   						// 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录
```

### 具体实现

* 申请ohos.permission.STORAGE_MANAGER权限。
  
* 订阅广播事件。 需订阅的事件如下：
    * 卷设备移除：“usual.event.data.VOLUME_REMOVED”
    * 卷设备卸载：“usual.event.data.VOLUME_UNMOUNTED”
    * 卷设备挂载：“usual.event.data.VOLUME_MOUNTED”
    * 卷设备异常移除：“usual.event.data.VOLUME_BAD_REMOVAL”
    * 卷设备正在弹出：“usual.event.data.VOLUME_EJECT”
* 收到广播通知后获取卷设备信息。

### 相关权限

[ohos.permission.STORAGE_MANAGER](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionstorage_manager)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API16版本SDK，版本号：5.1.0.47，镜像版本号：OpenHarmony5.1.0.47。

3.本示例需要使用DevEco Studio （5.0.3.910）及以上版本才可编译运行。

4.本示例相关权限为system_basic级别，需要配置高权限签名，可参考[申请使用受控权限](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/declare-permissions-in-acl.md)。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/UserFile/ManagingExternalStorageDevices > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```