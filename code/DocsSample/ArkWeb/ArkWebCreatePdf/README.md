## 使用Web组件保存前端页面为PDF

### 介绍

1. 本示例通过Web组件的createPdf方法，为应用提供了保存前端页面为PDF的功能。
2. 本工程主要实现了对以下指南文档中[使用Web组件保存前端页面为PDF](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/web/web-pdf-preview.md)示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

### callback方式保存PDF

#### 介绍

1. 通过callback方式调用createPdf接口，获取到的result通过pdfArrayBuffer接口取得PDF二进制数据流，最后使用fileIo方法将二进制数据流保存为PDF文件。

#### 效果预览

| callback方式保存PDF                                                      |
|-----------------------------------------------------------|
| <img src="./screenshots/callbackPage.png" width="360;" /> |

##### 使用说明

1. 当网页加载完成后，可以在Ark侧页上调用createPdf接口，最后把网页保存成pdf文件。


##### 保存结果

|                       保存结果                        |
|:-------------------------------------------------:|
| <img src="./screenshots/savePdfResult.png" width="360;" /> |


### Promise方式保存PDF

#### 介绍

1. 通过Promise方式调用createPdf接口，获取到的result通过pdfArrayBuffer接口取得PDF二进制数据流，最后使用fileIo方法将二进制数据流保存为PDF文件。

#### 效果预览

| Promise方式保存PDF                                           |
|----------------------------------------------------------|
| <img src="./screenshots/promisePage.png" width="360;" /> |

##### 使用说明

1. 当网页加载完成后，可以在Ark侧页上调用createPdf接口，最后把网页保存成pdf文件。


##### 保存结果

|                       保存结果                        |
|:-------------------------------------------------:|
| <img src="./screenshots/savePdfResult.png" width="360;" /> |


### 工程目录

```
├── entry
│   └── src
│       └── main
│           ├── ets                                 // ArkTS代码区
│           │   ├── entryability
│           │   │   └── EntryAbility.ets            // 入口类
│           │   ├── entrybackupability
│           │   │   └── EntryBackupAbility.ets      // 备份恢复框架
│           │   └── pages
│           │       └── Index.ets                   // 主页
|           |       |── WebCreatePdfCallback.ets    //callback方式保存网页
|           |       |── WebCreatePdfPromise.ets     //Promise方式保存网页
│           └── resources                           // 应用资源文件
```

### 具体实现

* 本示例通过通过createPdf生成实例后，调用pdfArrayBuffer方法获取二进制数据流，再使用fileIo方法将二进制数据流保存为PDF文件。用户可以将前端页面内容保存为PDF以便分享或保存。例如，生成报告、发票等，方便用户保存和传输。

### 相关权限

[ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行。
2. 本示例支持API14版本SDK，SDK版本号(API Version 20 Release)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0Release)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/ArkWebCreatePdf > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```