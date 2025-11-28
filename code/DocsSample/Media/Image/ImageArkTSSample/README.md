# Image开发指导(ArkTS)

### 介绍

此Sample为开发指南中图片**开发指导(ArkTS)**章节中部分示例代码的工程。包含图片编解码，图片接收，内存分配，以及图片Exif信息的相关操作。

### 效果预览

| index页面                         | 图片解码页面示例                                     | 图片编码页面示例                                     |
| --------------------------------- |----------------------------------------------|----------------------------------------------|
| ![Image](./screenshots/index.png) | ![Image](./screenshots/decodingPixelMap.png) | ![Image](./screenshots/encodingPixelMap.png) |

使用说明：

1.安装应用，弹出权限允许界面，点击“允许”按钮，弹出菜单后，根据需要点击按钮跳转到不同功能的界面。

2.从菜单页面，点击“跳转到图片解码页面”按钮，进入图片解码页面，首先选择解码资源类型，然后选择解码方式进行解码，在解码结束后点击“资源释放”按钮进行资源的释放。

3.从菜单页面，点击“跳转到多图解码页面”按钮，进入多图解码页面，首先选择解码资源类型，然后选择解码方式进行解码，在解码结束后点击“资源释放”按钮进行资源的释放。

4.从菜单页面，点击“跳转到内存申请页面”按钮，进入内存申请页面，首先选择内存申请方式进行解码，在解码结束后点击“资源释放”按钮进行资源的释放。

5.从菜单页面，点击“跳转到图片编码页面”按钮，进入图片编码页面，首先选择编码资源类型，然后选择编码方式进行编码，在编码结束后点击“资源释放”按钮进行资源的释放。

6.从菜单页面，点击“跳转到多图编码页面”按钮，进入多图编码页面，首先选择编码资源类型，然后选择编码方式进行编码，在编码结束后点击“资源释放”按钮进行资源的释放。

7.从菜单页面，点击“跳转到图片Exif信息编辑页面”按钮，进入Exif信息编辑页面，首先选择propertyKey的值，然后获取其Exif信息。在操作结束后点击“资源释放”按钮进行资源的释放。

8.从菜单页面，点击“跳转到图片Exif信息编辑页面”按钮，进入Exif信息编辑页面，首先选择propertyKey的值，然后输入要修改value值，点击"修改Exif信息"按钮修改Exif信息。在操作结束后点击“资源释放”按钮进行资源的释放。

9.从菜单页面，点击“跳转到图片接收页面”按钮，进入图片接收页面，可获取到新创建的Receiver的surfaceID,点击“触发相机"按钮，可触发"imageArrival"回调函数。

### 工程目录

```shell
├── AppScope
├── README.md
├── build-profile.json5
├── entry
│   ├── build-profile.json5
│   ├── hvigorfile.ts
│   ├── oh-package.json5
│   └── src
│       ├── main
│       │   ├── ets
│       │   │   ├── entryability
│       │   │   │   └── EntryAbility.ts
│       │   │   ├── entrybackupability
│       │   │   │   └── entrybackupability.ts
│       │   │   ├── pages
│       │   │   │   └── Index.ets  // 菜单页面
│       │   │   │   └── AllocateMemory.ets // 内存分配页面
│       │   │   │   └── DecodingPicture.ets // 多图解码页面
│       │   │   │   └── DecodingPixelMap.ets // 图片解码页面
│       │   │   │   └── EditExif.ets // Exif信息编辑页面
│       │   │   │   └── EncodingPicture.ets // 多图解码页面
│       │   │   │   └── EncodingPixelMap.ets // 图片编码页面
│       │   │   │   └── ImageReceiver.ets // receiver调用页面
│       │   │   └── tools
│       │   │       ├── CodecUtility.ets // 编解码相关接口
│       │   │       ├── components.ets    // 资源选择映射函数
│       │   │       └── ExifUtility.ets    // Exif相关接口
│       │   │       └── ReceiverUtility.ets    // receiver相关接口
│       │   ├── module.json5
│       │   └── resources
│       │       ├── base
│       │       ├── dark
│       │       ├── rawfile
│       └── ohosTest
│       │    ├── ets
│       │    │   ├── test
│       │    │   │   ├── Ability.test.ets
│       │    │   │   └── Codec.test.ets
│       │    │   │   ├── Exif.test.ets
│       │    │   │   └── List.test.ets
│       │    │   │   ├── Receiver.test.ets
│       │    ├── module.json5
│       └── test
│           ├── List.test.ets
│           ├── LocalUnit.test.ets
├── hvigor
│   ├── hvigor-config.json5
├── hvigorfile.ts
├── oh-package.json5
└── screenshots
```

### 具体实现

+ 图片编解码，多图编解码，内存申请等功能的接口调用均封装在CodecUtility中实现，源码参考[CodecUtility.ets](./entry/src/main/ets/tools/CodecUtility.ets)。 
+ Exif信息获取与修改功能的接口调用封装在ExifUtility中实现，源码参考[ExifUtility.ets](./entry/src/main/ets/tools/ExifUtility.ets)。
+ 图片接收功能的接口调用封装在ReceiverUtility中实现，源码参考[ReceiverUtility.ets](./entry/src/main/ets/tools/ReceiverUtility.ets)。

### 相关权限

相机相关权限，文件读写权限。

### 依赖

不涉及。

### 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API20版本SDK，版本号： 6.0.0.43 ；

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025；

4.  高等级APL特殊签名说明：无；

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/Image/ImageArkTSSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```