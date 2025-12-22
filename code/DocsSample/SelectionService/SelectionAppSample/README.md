#  划词应用开发示例

## 介绍

 本示例通过提供[划词服务指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/basic-services/selectionInput)中ArkTS场景的开发示例，帮助开发者更好地理解划词服务模块代码的使用。该工程中展示的代码详细描述可查如下链接：

1. [实现一个划词应用](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/selectionInput/selection-services-application-guide-sys.md)。

## 效果预览

| 菜单面板 |
|-------|
| ![image](screenshots/MenuPanel.png) |

### 使用说明

1. 在任意一个应用内通过鼠标双击、三击或单击滑动的方式选中一段文字。

2. 按下ctrl键可触发划词，弹出菜单面板。

3. 在弹出的菜单面板内点击click to show MAIN_PANEL按钮，可以弹出主面板。

## 工程目录

```
entry/src/main
 │── ets
 │   ├── entryability
 │   ├── entrybackupability
 │   ├── extensionability
 │       └──SelectionExtensionAbility.ets    // 划词ExtensionAbility
 │   ├── extensionability
 │       └──SelectionModel.ets               // 划词内容管理
 │   ├── pages
 │       ├── Index.ets          // UI页面
 │       ├── MainPanel.ets      // 主面板
 │       ├── MenuPanel.ets      // 菜单面板
```

### 具体实现

1. 在[SelectionExtensionAbility.ets](entry/src/main/ets/extensionability/SelectionExtensionAbility.ets)实现了一个划词ExtensionAbility，通过监听划词事件来创建和弹出菜单面板。
2. 在[Ability.test.ets](entry/src/ohosTest/ets/test/Ability.test.ets)文件中，提供了创建和移动面板的自动化测试用例。

## 相关权限

不涉及

## 依赖

不涉及

## 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568，2in1;

2. 本示例支持API version 20及以上版本的SDK;

3. 本示例需要使用DevEco Studio 6.0.0 Release（6.0.0.868）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

    git init
    git config core.sparsecheckout true
    echo code/BasicFeature/DataManagement/SelectionService/ > .git/info/sparse-checkout
    git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
    git pull origin master
