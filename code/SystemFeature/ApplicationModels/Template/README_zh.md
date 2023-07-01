# template

### 介绍

本示例主要实现了基于UIExtension实现简单的分享功能。支持取消分享，点击“返回Share”按钮，返回调用方应用；支持完成分享，点击“留在UIExtension”按钮，留在当前分享Demo应用。

### 效果预览

| 应用主页面                                                   | 分享成功预览页面                                             |                       分享成功展开页面                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | :----------------------------------------------------------: |
| ![templateMain](./screenshots/zh/templateMain.jpeg) | ![templatePreview](./screenshots/zh/templatePreview.jpeg) | ![templateShare](./screenshots/zh/templateShare.jpeg) |

使用说明

1.使用Share应用点击“分享”按钮，点击的弹出本应用图标，跳转到当前应用；

2.当前应用通过UIExtension组件显示Share应用分享的信息及“返回Share”和“留在UIExtension”按钮；

3.点击“返回Share”按钮，返回Share应用；

4.点击“留在UIExtension”按钮，留在当前应用并显示Share应用分享的信息。

### 工程目录

```
entry/src/main/
|---ets
|  |---entryability
|  |  └---EntryAbility.ts   
|  |---model
|  |  └---Logger.ts
|  |---pages
|  |  |---Index.ets                          // EntryAbility页面
|  |  |---picker.ets                         // 自定义组件页面
|  |  └---UIExtenIndex.ets					 // UIExtension页面
|  └---uiextensionability
|     └---UIExtAbility.ts 
└---resources                                // 资源信息
```

### 具体实现

- 在Index.ets中加载TemplateBuilder自定义组件并显示分享信息,  源码参考[Index.ets](./entry/src/main/ets/pages/Index.ets)。
  - 在Index页面中根据是否通过分享应用拉起来显示不同画面效果，通过判断选择是否打开TemplateBuilder自定义组件。
- TemplateBuilder组件内容封装在picker.ets中，源码参考：[picker.ets](./entry/src/main/ets/pages/picker.ets)。
  - 在TemplateBuilder组件中包含UIExtAbility组件、及“返回Share”和“留在UIExtension”按钮。

### 相关权限

不涉及。

### 依赖

本应用需Share应用配合使用，Share应用地址：[Share](code/SystemFeature/ApplicationModels/Share)

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)才可编译运行。

4.本示例需要使用Full SDK编译。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/ApplicationModels/Template/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

