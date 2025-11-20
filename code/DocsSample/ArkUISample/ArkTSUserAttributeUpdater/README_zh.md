# 属性更新器 (AttributeUpdater)

## 介绍

本工程主要实现了[属性更新器 (AttributeUpdater)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-user-defined-extension-attributeUpdater.md)指南文档中示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

使用说明：
1. 该工程可以选择在模拟器和开发板上运行。
2. 点击构建，即可在生成的应用中点击对应的按钮，观察自定义占位节点的不同应用。
3. 进入”DocsSample/ArkUISample/ArkTSUserAttributeUpdater/entry/src/ohosTest/ets/test/UserAttributeUpdaterAbility.test.ets“文件，可以对本项目进行UI的自动化测试。

## 工程目录

```
ArkTSUserAttributeUpdater
├──entry/src/main
│  ├──ets  // ets代码区
|  |  ├──common
|  |  |  ├──logger.ts               // 日志类
│  │  ├──entryability
|  |  |  └──EntryAbility.ets        // 程序入口类
|  |  ├──entrybackupability
│  │  │  └──EntryBackupAbility.ets   
│  │  └──pages                      // 页面文件
│  │     └──Index.ets               // 主界面
│  │     └──AttModifier.ets        // 通过modifier修改属性界面
│  │     └──AttUpdate.ets          // 通过update更新属性界面
│  │     └──common.ets             // 接口定义样例
|  ├──resources         		   // 资源文件目录
```

## 具体实现

1. 通过modifier直接修改属性
   组件初始化完成之后，开发者可以通过AttributeUpdater实例的attribute属性方法，获取到属性对象。通过属性对象直接修改属性，会立即触发组件属性的更新。。
2. 通过modifier更新组件的构造参数
   可以通过AttributeUpdater实例的updateConstructorParams方法，直接更新组件的构造参数。



## 相关权限

无。

## 依赖

不涉及。

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568等。
2. 本示例支持API20版本SDK，版本号：6.0.0.33。
3. 本示例已支持使DevEco Studio 6.0.0 Release 编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkTSUserAttributeUpdater/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```