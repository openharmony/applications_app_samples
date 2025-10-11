# 应用文件访问（ArKTS）和设置分布式文件数据等级

## 介绍

本实例主要介绍几种常用文件操作的示例，如创建、读写、删除、移动、复制、获取属性、设置数据安全等级等操作。



- [ 应用文件访问(ArkTS)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/app-file-access.md)
- [设置分布式文件数据等级
  ](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/file-management/set-security-label.md)

## 效果预览

| 应用成功启动界面                                          | 文件访问结果                                          |
|---------------------------------------------------|-------------------------------------------------|
| <img src="./screenshots/start.png" width = "400"> | <img src="./screenshots/end.png" width = "400"> |

使用说明：
1.在主界面中通过点击相应的按钮，应用可以完成相应的功能，完成的反馈将如日志的形式出现在主界面的上半部分。

## 工程目录

```
//应用文件访问
FileSample
├──entry/src/main
|	├──ets
|	|	├──entryability
|	|	|	└──EntryAbility.ets         // 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	└──pages                        // 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录	
```

## 具体实现

- 在应用开始访问文件之前，使用UIAbilityContext[获取UIAbility的上下文信息](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/application-models/uiability-usage.md)，然后调用Context的相关接口获取应用的沙箱文件路径。

- 文件的新建、读写、内容复制、查看文件列表、文件流的使用、文件哈希流的使用的功能函数都集成在fileFs.ets文件中，源码参考：fileFs.ets。

- 使用fs.openSync、fs.writeSync、fs.readSync、fs.closeSync分别用来来创建文件夹、打开文件、写文件、读文件、关闭文件，文件接口请参考：[ohos.file.fs](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-fs.md)

## 相关权限

无

## 依赖

不涉及

## 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.58，镜像版本号：OpenHarmony 5.0.2.58。

3.本示例需要使用DevEco Studio 6.0.0 Release (构建版本：6.0.0.858，构建 2025年9月24日)及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/FileAilFileSample > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

