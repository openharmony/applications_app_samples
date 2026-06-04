# setWindowMask简介

### 介绍

在Stage模型下，应用窗口内创建子窗口，使用子窗口调用setWindowMaskWithApha设置掩码，子窗显示为三角形（异形窗口），将子窗口左上部分变为透明且不可交互，同时子窗阴影和圆角都消失。

### 效果预览

| 交互效果                                              |
|------------------------------------------------------|
| ![image](screenshots/setWindowMaskWithAlphaDemo.gif) |

### 使用说明

1. 应用打开后，通过“Create Sub Window”按钮可创建子窗，“Destroy Sub Window”可销毁子窗。
2. 通过“setWindowMask for Sub Window”按钮设置子窗为异形窗口。
3. 通过“Create Test Window”可创建测试窗口，用于验证异形子窗左上部分不可交互，通过“Destroy Test Window”按钮可销毁测试窗口。

### 工程目录

```
entry/src/main/ets/
|---main
|   |---ets
|   |   |---entryability
|   |   |   |---EntryAbility.ets           // 创建主窗口
|   |   |---entrybackupability
|   |   |---pages
|   |   |   |---Index.ets                  // 主窗口页面
|   |   |   |---Page_EmptyWindows.ets      // 子窗口页面
|   |---resources
|   |---module.json5                       
|---ohosTest
|   |---ets 
|   |   |---test
|   |   |   |---Ability.test.ets           // 自动化测试代码
```

### 具体实现

创建主窗口的方法在EntryAbility中实现，源码参考：[EntryAbility.ets](entry/src/main/ets/entryability/EntryAbility.ets)


目标页面在Index中实现，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)
- 使用“Create Sub Window”按钮可创建子窗，“Destroy Sub Window”可销毁子窗。
- 使用“setWindowMask for Sub Window”按钮设置子窗为异形窗口。
- 使用“Create Test Window”可创建测试窗口，用于验证异形子窗左上部分不可交互，使用“Destroy Test Window”按钮可销毁测试窗口。


### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：华为手机、平板、PC。

2.本示例为Stage模型，支持API Version 26.0.0及以上版本SDK。

3.本示例需要使用DevEco Studio 6.0.0 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/EventDistribution/setWindowMask > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```