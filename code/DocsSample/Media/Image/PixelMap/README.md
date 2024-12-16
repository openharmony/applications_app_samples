# PixelMap

## 介绍

本示例根据媒体->Image Kit(图片处理服务)->[图片开发指导(ArkTS)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/media/image/image-decoding.md)进行开发。 

本示例利用Image组件展示位图，同时使用@kit.ImageKit进行图片处理。

## 效果预览

| 图片缩放                                     | 垂直翻转                                     |
| -------------------------------------------- | -------------------------------------------- |
| ![pixelmap_1](./screenshots/pixelmap_1.jpeg) | ![pixelmap_2](./screenshots/pixelmap_2.jpeg) |

| 位图操作全部                                 | 文件操作界面                                 |
| -------------------------------------------- | -------------------------------------------- |
| ![pixelmap_3](./screenshots/pixelmap_3.jpeg) | ![pixelmap_4](./screenshots/pixelmap_4.jpeg) |


使用说明：

1. 仿照手机中的编辑图片功能。使用tabbar组件将12个功能按钮分为了四个版块：

   剪切板块：裁剪、缩放、移动。

   翻转板块：顺时针旋转、垂直翻转、水平翻转。

   调色板块：位图操作部分、位图操作全部、设置透明度。

   文件操作板块：保存图片、打开图片、编辑EXIF信息。

2. 左右滑动导航栏，切换为不同的板块。

3. 点击对应的功能按钮，中间的图片发生对应变化。

4. 点击右上角的重置按钮，图片重置为初始状态。

5. 点击返回按钮，退出应用。

## 工程目录

```
PixelMap
entry/src/main/ets/
├── common 
│   ├── Decode.ets (图片解码)
│   ├── EditingEXIF.ets (编辑EXIF信息)
│   ├── Encode.ets (图片编码)
│   └── Logger.ets (logger日志)
├── pages
│   └── Index.ets (图片编辑界面)
├── utils 
│   └── DisPlayInfoUtil.ets (获取图片的长宽信息，用于适配不同的屏幕大小)
entry/src/main/resources/
└── base
    └── media
        └── image.jpg(图片资源)
entry/src/ohosTest/ets/
├── test
│   ├── Ability.test.ets (UI测试代码)
│   └── List.test.ets (测试套件列表)
└── utils 
	└── RecourceUtil.ets (将资源文件转化为字符串类型)
```

## 具体实现

+ 图片解码功能在Decode模块中实现，源码参考Decode.ets：
    + 获取图片源：使用createImage接口创建ImageSource实例，该接口支持四种参数类型：沙箱路径文件路径、文件描述符、资源文件的ArrayBuffer和资源文件的RawFileDescriptor。
    + 创建位图：createPixelMap接口创建PixelMap对象，可自定义解码参数DecodingOptions。
+ 图片编辑在Index模块中实现，源码参考index.ets:
    + 编辑图片：先调用解码接口获取PixelMap，随后利用crop、scale、rotate进行裁剪、缩放、旋转等操作。处理后，调用getImageInfo，以刷新图片显示。
    + 位图操作：使用pixelMap的readPixels接口读取像素信息，修改像素后，使用writePixels接口修改pixelMap，完成位图操作。
+ 图片编码功能在Encode模块中实现源码参考Encode.ets:
    + 图片编码：接收imageSource或pixelMap参数，通过imagePackerApi接口打包图片为ArrayBuffer，再使用fs.write将ArrayBuffer写入文件。

## 相关权限

不涉及

## 依赖

不涉及。

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API14版本SDK，版本号：5.0.2.57；
   
3. 本示例已支持使DevEco Studio 5.0.1 Release (构建版本：5.0.5.306，构建 2024年12月6日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/Image/PixelMap/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```