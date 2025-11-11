#  剪贴板指南Sample 

## 介绍

 本示例通过使用[剪贴板指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/basic-services/pasteboard)中ArkTS场景的开发示例，展示开发步骤在工程中，帮助开发者更好地理解剪贴板模块代码合理使用。该工程中展示的代码详细描述可查如下链接：

1. [使用剪贴板进行复制粘贴](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/use_pasteboard_to_copy_and_paste.md)。

2. [使用剪贴板进行延迟复制粘贴](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/pasteboard-time-lapse-copy-and-paste.md)。

3. [申请访问剪贴板权限](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/get-pastedata-permission-guidelines.md)。

## 效果预览

| 主页 |
|-------|
| ![image](screenshots/UI.PNG) |

### 使用说明

1. 在主界面，可以点击文本框进行输入。

2. 输入文本后点击复制按钮进行剪贴板数据写入。

3. 第一次点击粘贴时，会弹出授权请求对话框，用户授权后，粘贴的内容将在文本框显示。

## 工程目录

```
entry/src/main
 │── ets
 │   ├── entryability
 │   ├── entrybackupability
 │   ├── pages
 │       ├── Index.ets            // UI页面
 │       ├── PasteboardModel.ets  // 开发步骤示例代码
 ├── resources
 │   └── module.json5              // 声明所需的权限

```

## 相关权限

1.使用[安全控件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/pastebutton.md)访问剪贴板内容的应用。

2.申请ohos.permission.READ_PASTEBOARD允许应用访问剪贴板。

## 依赖

不涉及

## 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568，Phone;

2. 本示例支持API20版本SDK，版本号：6.0.0.49;

3. 本示例需要使用DevEco Studio 5.1.1 Release（5.1.1.840）及以上版本才可编译运行。

4. 本示例涉及调用系统权限的接口，需要配置允许权限列表，可以参考[申请访问剪贴板权限](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/get-pastedata-permission-guidelines.md)配置相关权限。

## 下载

如需单独下载本工程，执行如下命令：

    git init
    git config core.sparsecheckout true
    echo code/BasicFeature/DataManagement/pasteboard/ > .git/info/sparse-checkout
    git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
    git pull origin master
