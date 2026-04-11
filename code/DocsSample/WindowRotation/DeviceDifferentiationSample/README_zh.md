# 旋转策略应用

## 介绍

本工程主要实现了对以下指南文档[旋转体验实例](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/windowmanager/window-rotation.md)
中示例代码片段的工程化，通过该工程在单一策略（如：follow_desktop）无法满足需求时，根据断点机制设置旋转策略，消除设备差异化。

## 效果预览

| ![](screenshot/example.gif) |
|----------------------------------|

使用说明：

1. 安装编译生成的hap包,打开应用。
2. 应用启动时，根据断点机制设置旋转策略。

## 工程目录

```
DeviceDifferentiation
├──entry/src/main/ets
│  │  ├──entryability
│  │  │  ├──EntryAbility.ts
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

1. 本示例支持标准系统上运行，支持设备：default。
2. 本示例支持API23版本SDK，版本号：6.1.0.26。
3. 本示例已支持使DevEco Studio 6.0.2 Release (构建版本：6.0.2.650)编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/InputKit/NDKInputEventMonitor > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```

