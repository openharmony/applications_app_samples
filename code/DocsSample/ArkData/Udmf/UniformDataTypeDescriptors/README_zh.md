# 标准化数据类型 (ArkTS)指南文档示例

### 介绍

本示例以媒体类文件的归属类型查询场景为例，提供基本的开发步骤。针对文件扩展名，可使用getUniformDataTypesByFilenameExtension()方法获取对应UTD数据类型，并打印对应UTD数据类型的具体属性。针对MIMEType，可使用getUniformDataTypesByMIMEType()查询对应UTD数据类型，并打印对应UTD数据类型的具体属性。针对文件后缀，可使用getUniformDataTypesByFilenameExtension()方法获取对应UTD数据类型。针对UTD数据类型，可使用getTypeDescriptor()方法查询对应的MIMEType列表。

### 效果预览

| 桌面                                |
|-----------------------------------|
| ![image.PNG](screenshots/image.PNG) |

### 使用说明

1. 在主界面，点击uniformTypeDescriptorTest按钮，在控制台打印数据类型相等、存在归属关系。

2. 在主界面，点击getMimeTypeByFilenameExtensions按钮，在控制台打印对应mimeTypes类型。

3. 在主界面，点击getFilenameExtensionByMimeType按钮，在控制台打印对应文件后缀名。

### 工程目录
```
entry/src/
|   |--- main/
|       |---ets/
|           |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|           |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|           |---pages/index.ets                 // entry主应用入口页面及接口调用实现
```

### 具体实现

* 主UI界面，功能包括获取并打印UTD数据类型，确认数据类型是否存在归属关系及查询对应的MIMEType列表，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。
    * 针对文件扩展名，使用getUniformDataTypesByFilenameExtension()、getUniformDataTypesByMIMEType()方法获取对应UTD数据类型，并打印对应UTD数据类型的具体属性。
    * 针对MIMEType，使用getUniformDataTypesByMIMEType()查询对应UTD数据类型，并打印对应UTD数据类型的具体属性。
    * 根据上述步骤中查询到的标准数据类型与表示音频数据的已知标准数据类型做比较查询，确认是否存在归属关系。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.53，镜像版本号：OpenHarmony_6.0.0.53。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 5, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkData/Udmf/UniformDataTypeDescriptors > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````