# 访问和管理动态照片资源示例

## 简介

本示例展示了如何访问和管理动态照片资源，将图像和视频结合创建动态照片效果。动态照片由一张静态图片和一段短视频组成，可以为用户带来更生动的视觉体验。

本示例使用的核心包包括：
- [@kit.MediaLibraryKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/medialibrary/Readme-CN.md) - 提供photoAccessHelper模块用于访问和管理媒体资源
- [@kit.AbilityKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/Readme-CN.md) - 提供Ability相关能力
- [@kit.CoreFileKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/file-management/Readme-CN.md) - 提供文件系统访问能力
- [@kit.ArkData](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/database/Readme-CN.md) - 提供数据管理能力

## 效果预览

| 使用SaveButton保存        | 从媒体库获取                | 从应用沙箱加载                 | 导出/读取内容               |
| --------------------- | --------------------- | --------------------- | --------------------- |
| ![image](./assets/images/pic2.jpg) | ![image](./assets/images/pic3.jpg) | ![image](./assets/images/pic4.jpg) | ![image](./assets/images/pic5.jpg) |

## 使用说明

1. 启动应用后，在主界面可以看到四个功能选项；
2. 点击"使用SaveButton保存"按钮，可以将动态照片（图片+视频）保存到图库；
3. 点击"从媒体库获取"按钮，使用Picker从媒体库中选择已有的动态照片；
4. 点击"从应用沙箱加载"按钮，从应用沙箱目录中加载动态照片；
5. 点击"导出/读取内容"按钮，可以将动态照片的图片和视频组件导出到应用沙箱，或以ArrayBuffer形式读取内容；
6. 动态照片的视频时长不能超过10秒。

## 工程目录
```
entry/src/main/ets/
├─entryability
│  └─EntryAbility.ets                    # 应用入口
├─entrybackupability
│  └─EntryBackupAbility.ets              # 备份能力
└─pages
   ├─Index.ets                           # 主界面
   ├─Scene1.ets                          # 使用SaveButton保存动态照片场景
   ├─Scene2.ets                          # 从媒体库获取动态照片（Picker）场景
   ├─Scene3.ets                          # 从应用沙箱加载动态照片场景
   └─Scene4.ets                          # 导出/读取动态照片内容场景
entry/src/main/resources/                # 资源文件
```

## 具体实现

### 1. 使用SaveButton保存动态照片

使用SaveButton安全组件将动态照片保存到媒体库，源码参考：[Scene1.ets](entry/src/main/ets/pages/Scene1.ets)

- 准备动态照片资源：确保图片和视频文件存在于应用沙箱目录；
- 创建MovingPhoto对象：使用photoAccessHelper.createMovingPhoto()创建动态照片对象，传入图片URI和视频URI；
- 使用SaveButton组件：在界面中添加SaveButton组件，设置saveButtonOptions参数；
- 自动处理权限：SaveButton组件会自动处理保存动态照片所需的权限，无需手动申请。

### 2. 从媒体库获取动态照片

使用PhotoViewPicker从媒体库中选择动态照片，源码参考：[Scene2.ets](entry/src/main/ets/pages/Scene2.ets)

- 创建Picker实例：使用photoAccessHelper.PhotoViewPicker()创建选择器；
- 配置选择选项：设置PhotoSelectOptions，指定选择动态照片类型；
- 启动选择器：调用picker.select()打开媒体库选择界面；
- 获取选择结果：从返回的PhotoSelectResult中获取选中的动态照片URI。

### 3. 从应用沙箱加载动态照片

从应用沙箱目录加载动态照片资源，源码参考：[Scene3.ets](entry/src/main/ets/pages/Scene3.ets)

- 获取沙箱路径：使用context.filesDir获取应用沙箱目录路径；
- 准备资源文件：确保图片和视频文件已存在于沙箱目录；
- 创建MovingPhoto对象：使用photoAccessHelper.createMovingPhoto()加载沙箱中的动态照片；
- 显示动态照片：使用Image组件显示动态照片的静态图片部分。

### 4. 导出和读取动态照片内容

将动态照片的图片和视频组件分别导出或读取，源码参考：[Scene4.ets](entry/src/main/ets/pages/Scene4.ets)

- 获取图片数据：调用movingPhoto.getImageUri()获取图片URI，使用fs.readSync()读取图片数据；
- 获取视频数据：调用movingPhoto.getVideoUri()获取视频URI，使用fs.readSync()读取视频数据；
- 导出到沙箱：使用fs.writeSync()将图片和视频数据分别写入应用沙箱目录；
- 以ArrayBuffer读取：直接使用fs.readSync()将文件内容读取为ArrayBuffer格式。

## 相关权限

无需申请权限，SaveButton组件自动处理保存动态照片的权限。

注：本示例仅介绍访问和管理现有的动态照片。如需拍摄动态照片，请参考相机Kit相关文档。

## 依赖

无

## 约束与限制

1. 本示例仅支持标准系统上运行；
2. 本示例支持API23版本SDK，版本号：6.1.0.23；
3. 本示例需要使用DevEco Studio 6.0.0 Canary1（构建版本：6.0.0.63，构建于2025年10月30日）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo MediaLibraryKit/MovingPhotoSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```