# SetWindowSystemBarEnable简介

### 介绍

在看视频、玩游戏等场景下，用户往往希望隐藏状态栏、导航栏等不必要的系统窗口，从而获得更佳的沉浸式体验。此时可以借助窗口沉浸式能力（窗口沉浸式能力都是针对应用主窗口而言的），达到预期效果。

### 效果预览

| 桌面                                     | 主窗口                                    | 交互                                     |
|----------------------------------------|----------------------------------------|----------------------------------------|
| ![image](screenshots/screenshot_1.jpg) | ![image](screenshots/screenshot_2.jpg) | ![image](screenshots/screenshot_3.jpg) |

### 使用说明

1. 点击页面交互

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
|   |---resources
|   |---module.json5                       
|---ohosTest
|   |---ets 
|   |   |---test
|   |   |   |---Ability.test.ets           // 自动化测试代码
```

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/SetWindowSystemBarEnable > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```