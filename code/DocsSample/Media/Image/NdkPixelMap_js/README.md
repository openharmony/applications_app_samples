# NdkPixelMap_js

## 介绍

本示例专注于PixelMap功能的演示，实现简单的图片解码、图像变换、PixelMap数据处理以及编码功能。

## 效果预览

| 主界面                                                   | 图片解码显示                                             |
| -------------------------------------------------------- | -------------------------------------------------------- |
| ![NdkPixelMap_js_1](./screenshots/NdkPixelMap_js_1.jpeg) | ![NdkPixelMap_js_2](./screenshots/NdkPixelMap_js_2.jpeg) |

| PixelMap处理结果                                         | 图片编码保存                                             |
| -------------------------------------------------------- | -------------------------------------------------------- |
| ![NdkPixelMap_js_3](./screenshots/NdkPixelMap_js_3.jpeg) | ![NdkPixelMap_js_4](./screenshots/NdkPixelMap_js_4.jpeg) |

使用说明：

1. 启动应用，进入主界面。
2. 在主界面，可以点击图片解码、图像变换、处理PixelMap数据、图片编码进入对应功能界面。
3. 进入图片解码界面，显示已解码完成的图片。
4. 进入图像变换界面，点击IMAGE按钮，调用TestGetImageInfo、TestAccessPixels、TestUnAccessPixels接口。
5. 进入处理PixelMap数据界面，点击PixelMap按钮，调用Transform接口，展示处理后的结果图片。
6. 进入图片编码界面，点击图片编码按钮，将图片编码并保存为文件。

## 工程目录

```
NdkPixelMap_js
entry/src/main/cpp/
├── types
│   └── libentry 
│       └── Index.d.ts (声明Napi接口，供ts调用)
├── CMakeLists.txt (CMake编译配置文件)
├── hello.cpp (C++源码)
└── napi_init.cpp (初始化Napi接口)
entry/src/main/ets/
├── common 
│   └── Logger.ts (logger日志类)
├── pages
│   └── Index.ets (首页导航界面)
├── pixelmap
│   └── pages
│       ├── DecodeImages.ets (图片解码)
│       ├── EncodeImages.ets (图片编码)
│       ├── ProcessPixelMapData.ets (处理PixelMap数据)
│       └── TransfromImages.ets (图像变换)
entry/src/main/resources/
└── rawfile
    └── example.jpg(图片资源)
entry/src/ohos/ets/
├── test
│   ├── Ability.test.ets (UI测试代码)
│   └── List.test.ets (测试套件列表)
└── utils 
	└── RecourceUtil.ets (将资源文件转化为字符串类型)
```

## 具体实现

+ 图片解码功能在hello中实现，源码参考hello.cpp：
    + 初始化ResourceManager：通过OH_ResourceManager_InitNativeResourceManager完成。
    + 加载Raw文件：使用OHResourceManager_OpenRawFile接口实现。
    + 构建ImageSource：通过OH_ImageSource_Create接口创建ImageSource。
    + 获取PixelMap：调用OH_ImageSource_CreatePixelMap接口生成位图对象。
    + 读取图片尺寸：调用OH_ImageSource_GetImageInfo获取图片宽度高度。
+ 图像变换功能在hello中实现，源码参考hello.cpp:
    + 获取图片信息：通过OH_GetImageInfo接口完成。
    + 锁定像素数据：通过OH_AccessPixels接口，获取PixelMap对象中数据内存地址，并将其锁定。
    + 释放像素数据：通过OH_UnAccessPixels接口，释放PixelMap对象中数据内存地址
+ 处理PixelMap数据功能在hello中实现，源码参考hello.cpp:
    + 获取PixelMap：调用OH_PixelMap_InitNativePixelMap接口初始化NativePixelMap。
    + 处理PixelMap：调用OH_PixelMap_SetOpacity、OH_PixelMap_Scale、OH_PixelMap_Translate、OH_PixelMap_Rotate、OH_PixelMap_Flip等接口设置透明度、缩放、偏移、旋转、翻转。
+ 图片编码功能在hello中实现，源码参考hello.cpp:
    + 图片编码：创建编码器对象，设置参数，获取文件描述符，调用OH_ImagePacker_PackToFile保存PixelMap到文件。

## 相关权限

不涉及。

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
echo code/DocsSample/Media/Image/NdkPixelMap_js/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```