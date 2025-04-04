# Form Kit开发示例

### 介绍

[Form Kit（卡片开发服务）](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/form)
提供一种界面展示形式，可以将应用的重要信息或操作前置到服务卡片（简称“卡片”），以达到服务直达、减少跳转层级的体验效果。卡片常用于嵌入到其他应用（当前被嵌入方即卡片使用方只支持系统应用，例如桌面）中作为其界面显示的一部分，并支持拉起页面、发送消息等基础的交互能力。

本Sample为卡片提供方的代码，即提供卡片的显示内容、控件布局以及控件点击处理逻辑。主要包含以下能力：

[FormMenu](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ohos-arkui-advanced-formmenu.md)
，该功能提供了将卡片添加至桌面的菜单，通过桌面访问该应用快捷卡片，可以直接访问该组件功能。在应用使用过程中，该组件作为留存和复访入口，可吸引用户将功能快捷添加到桌面。

[FormLink](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-formlink.md)
，该提供静态卡片交互组件，用于静态卡片内部和提供方应用间的交互。

### 效果预览

| 主页                         | 通过菜单添加卡片至桌面页面                      | 添加静态卡片并跳转到制定页面                     |
|----------------------------|------------------------------------|------------------------------------|
| ![](screenshots/index.png) | ![](screenshots/addFormByMenu.png) | ![](screenshots/addStaticCard.png) |

使用说明：

1.启动Form Sample应用，首页正常显示待添加卡片内容。

2.长按主页卡片内容，卡片内容上方显示菜单"添加到桌面"，点击"添加到桌面"，退出Form Sample应用到桌面，可看到"添加到桌面"卡片。

3.长按应用图标，显示菜单栏，点击"卡片"后进入应用卡片页面，选择静态卡片并点击"添加到桌面"，后可在桌面就看新添加静态卡片。点击静态卡片即可跳转到对应页面。


### 工程目录

```
entry/src/main/ets/                 
|---entryability
|   └---EntryAbility.ets
|---entryformability
|   └---EntryFormAbility.ets                       
|---logger
|   └---Logger.ts                      // 日志工具
└---pages
    |---AddFormByMenu.ets              // 使用Menu组件添加卡片到桌面
    |---Index.ets                      // 首页
    └---PageA.ets                      // 页面A
└---widget
    └---pages
        └---WidgetCard.ets
└---widget_static
    └---pages
        └---Widget_staticCard.ets      // 静态卡片
```

### 具体实现

卡片基础开发能力可通过官方指南文档中的[Form Kit](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/form/formkit-overview.md)
来完成。

本sample中功能主要参考[Menu](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-menu.md)
、[FormMenu](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ohos-arkui-advanced-formmenu.md)和[FormLink](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-formlink.md)
组件，完成功能开发。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API12版本SDK，SDK版本号（API Version 12 Release）。

3.本示例需要使用DevEco Studio版本号（DevEco Studio 5.0.0 Release）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/DocsSample/Form/ArkTSCardDocsSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
