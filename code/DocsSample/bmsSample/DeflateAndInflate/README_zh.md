# 压缩与解压文档示例

### 介绍

本示例通过调用zlib的api接口，测试压缩功能。

### 效果预览

| 桌面                              |
|---------------------------------|
|![img.png](screenshots/img.png) |

### 使用说明

1. 编译，安装。

2. 通过自动测试框架可进行测试及维护。

### 工程目录
```
AppScope/
|   |---resources/                                    // 工程级的资源目录
|   |--- app.json5                                    // 应用的全局配置信息
entry/src/
|   |--- main/
|        |--- module.json5                            // entry模块配置hap类型："type": "entry"
|             |---ets/
|                 |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|                 |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|                 |---pages/index.ets                 // 创建一个测试文件data.txt，并写入测试数据
|                 |---pages1/index.ets                 // 采用接口zlib.compressFile()将文件data.txt压缩并归档到data.zip中，采用接口zlib.decompressFile()将data.zip解压到应用沙箱目录下
|                 |---pages2/index.ets                 // 针对一个已知大小的缓冲区中的数据，使用接口compress()将其压缩到一个目的缓冲区中，使用接口compressBound()计算压缩目的缓冲区大小的上限值，使用接口uncompress()对存储压缩数据的缓冲区进行解压。由于解压时无法获取解压后原始数据的大小，为了确认解压后目的缓冲区的大小，需要在压缩前获取原始数据的大小并保存
|                 |---pages3/index.ets                 // 针对一个未知大小的缓冲区中的数据，使用接口deflate()将从一个原始输入流中读取的数据进行压缩，使用接口inflate()将从一个压缩输入流中读取的数据进行解压
|                 |---pages4/index.ets                 // 采用gzip格式，针对一个未知大小的缓冲区中的数据，使用接口deflate()将从一个原始输入流中读取的数据进行压缩，使用接口inflate()将从一个压缩输入流中读取的数据进行解压
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：tablet（平板或者平板模拟器）。

2.本示例为Stage模型，支持API19版本SDK，版本号：5.1.1.212，镜像版本号：OpenHarmony_5.1.1.212。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.840, built on September 5, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/bmsSample/DeflateAndInflate > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````