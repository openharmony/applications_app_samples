# 鼠标光标设置（ArkTS）

## 介绍

本工程主要实现了对以下指南文档[鼠标光标开发指导](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/device/input/pointerstyle-guidelines.md)
中示例代码片段的工程化，通过该工程可以设置光标的隐藏和显示，设置光标样式为取色器样式和默认样式。

## 效果预览

| ![](screenshot/pointer.png) |
|-----------------------------|

使用说明：

1. 安装编译生成的hap包,打开应用。
2. 点击对应按键显示和隐藏光标。
3. 点击对应按钮设置光标的样式为取色器样式和默认样式。
4. 进入"DocsSample/input/ArkTSPointer/entry/src/ohosTest/ets/test/Ability.test.ets"文件，可以对本项目进行UI的自动化测试。

## 工程目录

```
ArkTSPointer
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
echo code/DocsSample/input/ArkTSPointer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```

