# 按键拦截监听（ArkTS）

## 介绍

本工程主要实现了对以下指南文档[输入监听开发指导](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/device/input/inputmonitor-guidelines.md)
中示例代码片段的工程化，通过该工程可以添加和取消对音量上下键的拦截监听。

## 效果预览

| ![](screenshot/inputConsumer.png) |
|-----------------------------------|

使用说明：

1. 安装编译生成的hap包,打开应用时会自动添加对音量上下键的拦截监听。
2. 使用音量上下键，按键事件会被拦截并在页面弹出提示，无法正常调节音量。
3. 点击对应按钮取消对音量上下键的拦截监听，再次使用音量上下键，可以正常调节音量。
4. 点击对应按钮重新添加对音量上下键的拦截监听，再次使用音量上下键，无法正常调节音量。
5. 进入"DocsSample/InputKit/ArkTSInputConsumer/entry/src/ohosTest/ets/test/Ability.test.ets"文件，可以对本项目进行UI的自动化测试。

## 工程目录

```
ArkTSInputConsumer
├──entry/src/main
│  ├──ets
│  │  ├──entryability
|  |  ├──entrybackupability
│  │  └──pages
│  │     └──Index.ets               // 示例代码
|  ├──resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       └── Ability.test.ets   // 自动化测试代码
```

### 具体实现

1. 在[Index.ets](entry/src/main/ets/pages/Index.ets)文件中，通过点击按钮取消监听音量按键上/下的监听。
2. 在[Ability.test.ets](entry/src/ohosTest/ets/test/Ability.test.ets)文件中，通过自动化对取消音量上/下键的监听测试。

## 相关权限

无。

## 依赖

不涉及。

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：Phone、Tablet。
2. 本示例支持API20版本SDK，版本号：6.0.0.36。
3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年9月20日)编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/InputKit/ArkTSInputConsumer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```

