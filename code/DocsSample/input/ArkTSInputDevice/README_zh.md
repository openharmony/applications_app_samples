# 物理键盘插入检测（ArkTS）

## 介绍

本工程主要实现了对以下指南文档[输入设备开发指导](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/device/input/inputdevice-guidelines.md)中示例代码片段的工程化，通过该工程可以添加对物理键盘插入的检测。

## 效果预览

| ![](screenshot/inputDevice.png) |
|---------------------------------|

使用说明：
1. 安装编译生成的hap包，在生成的应用中点击对应的按钮添加对物理键盘插入的检测。
2. 进行物理键盘热拔插，页面会实时刷新设备的物理键盘连接状态。
3. 进入"DocsSample/input/ArkTSInputDevice/entry/src/ohosTest/ets/test/InputDeviceAbility.test.ets"文件，可以对本项目进行UI的自动化测试。

## 工程目录

```
ArkTSInputDevice
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
 │   │       └── InputDeviceAbility.test.ets   // 自动化测试代码
```

### 具体实现

1. 在[Index.ets](entry/src/main/ets/pages/Index.ets)文件中，获取设备列表以及监听设备热插拔。
2. 在[InputDeviceAbility.test.ets](entry/src/ohosTest/ets/test/InputDeviceAbility.test.ets)文件中，通过自动化对获取设备列表以及监听设备热插拔进行测试。

## 相关权限

无。

## 依赖

不涉及。

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568等。
2. 本示例支持API20版本SDK，版本号：6.0.0.36。
3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年9月20日)编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/input/ArkTSInputDevice > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```

