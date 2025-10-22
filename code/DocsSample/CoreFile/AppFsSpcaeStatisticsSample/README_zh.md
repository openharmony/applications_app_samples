# 应用及文件系统空间统计

### 介绍

本示例主要展示了有关文件系统空间和应用空间统计的接口功能。使用ohos.file.statvfs、ohos.file.storageStatistics。实现了应用空间的查询功能。该工程中展示的代码与接口等详细描述可查如下链接。

- [应用及文件系统空间统计](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/file-management/app-fs-space-statistics.md)

### 效果预览

|主页|
|--------------------------------|
|<img src="PageImg\SavingUserFiles.jpeg" alt="首页" style="zoom:50%;" width="400" />|

使用说明:

1. 在主界面，然后点击getFreeSize按钮，界面下方显示“getFreeSize success”内容。
2. 在主界面，然后点击getCurrentBundleStats按钮，界面下方显示“getCurrentBundleStats success”内容。
3. 在主界面，然后点击getTotalSize按钮，界面下方显示“getTotalSize success”内容。
4. 在主界面，然后点击getTotalSizeSync按钮，界面下方显示“getTotalSizeSync success”内容。
5. 在主界面，然后点击storageGetFreeSize按钮，界面下方显示“storageGetFreeSize success”内容。
6. 在主界面，然后点击getFreeSizeSync按钮，界面下方显示“getFreeSizeSync success”内容。

### 工程目录

```
├──entry/src/main
|	├──ets
|	|	├──entryability
|	|	|	└──EntryAbility.ets 		// 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	└──pages   						// 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录
```

### 具体实现

- 使用[ohos.file.storageStatistics](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-storage-statistics.md)提供的功能获取文件系统空间和应用空间的大小。

### 相关权限

不涉及

## 依赖

不涉及

## 约束与限制

1.本示例仅支持标准系统上运行，支持设备：PC/2in1。

2.本示例为Stage模型，支持API12版本SDK，版本号：5.0.0。

3.本示例需要使用DevEco Studio 6.0.0 Release (构建版本：6.0.0.858，构建 2025年9月24日)及以上版本才可编译运行。

## 下载

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/NDKEnvironmentSample > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```