# 旋转策略应用

## 介绍

本工程主要实现了对以下指南文档[旋转体验实例](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/windowmanager/window-rotation.md)
中示例代码片段的工程化，通过该工程可体验将屏幕方向转化为窗口方向，以作为setPreferredOrientation()接口参数，设置旋转策略。

## 效果预览

| ![](screenshots/example.png) |
|----------------------------------|

使用说明：

1. 安装编译生成的hap包,打开应用。
2. 获取当前屏幕方向，并转换为setPreferredOrientation()可接受的旋转策略。
3. 应用旋转到当前屏幕方向。

## 工程目录

```
ConvertOrientationAndRotationSample
├──entry/src/main/ets
│  │  ├──entryability
│  │  │  ├──EntryAbility.ets
|  |  ├──entrybackupability
|  |  |  ├──EntryBackupAbility.ets
│  │  ├──pages
│  │     ├──Index.ets               // 主界面
```

## 相关权限

不涉及。

## 依赖

不涉及。

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：华为手机、平板。
2. 本示例API Version 23及以上版本SDK。
3. 本示例已支持使DevEco Studio 6.0.2 Release (构建版本：6.0.2.650)编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/ConvertOrientationAndRotationSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```

