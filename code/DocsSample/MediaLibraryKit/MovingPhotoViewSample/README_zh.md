# 使用MovingPhotoView播放动态照片示例

## 简介

本示例展示了如何使用MovingPhotoView组件播放动态照片文件。MovingPhotoView组件可用于图库类应用中，提供动态照片的播放功能。

本示例使用的核心包包括：
- [@kit.MediaLibraryKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/medialibrary/Readme-CN.md) - 提供photoAccessHelper模块用于访问和管理媒体资源
- [@kit.AbilityKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/Readme-CN.md) - 提供Ability相关能力

## 使用说明

1. 启动应用后，将自动加载预置的动态照片资源；
2. 动态照片加载完成后，MovingPhotoView组件将显示动态照片的静态图片；
3. 长按动态照片区域，将触发动态照片的播放；
4. 点击"start"按钮，手动开始播放动态照片；
5. 点击"stop"按钮，停止动态照片播放；
6. 点击"静音"按钮，切换静音/非静音播放模式。

## 工程目录

```
entry/src/main/ets/
├─entryability
│  └─EntryAbility.ets                              # 应用入口
├─entrybackupability
│  └─EntryBackupAbility.ets                        # 备份能力
└─pages
   └─Index.ets                                     # MovingPhotoView演示页面
entry/src/main/resources/
├─rawfile
│  ├─moving_photo.jpg                              # 预置动态照片图片
│  └─moving_photo.mp4                              # 预置动态照片视频
└─base
   ├─element
   │  ├─string.json                                # 字符串资源
   │  ├─float.json                                 # 尺寸资源
   │  └─color.json                                 # 颜色资源
   ├─media
   │  └─layered_image.json                         # 分层图标
   └─profile
      ├─main_pages.json                            # 页面路由配置
      └─backup_config.json                         # 备份配置
entry/src/ohosTest/ets/
├─test
│  ├─MovingPhotoView.test.ets                     # MovingPhotoView测试用例
│  ├─Ability.test.ets                             # Ability测试用例
│  └─List.test.ets                                # 测试用例列表
```

## 具体实现

### 1. 导入MovingPhotoView组件

根据API版本选择导入方式，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)

- **API version 21及之前版本**：需要手动导入MovingPhotoViewAttribute
- **API version 22及之后版本**：编译工具链自动导入MovingPhotoViewAttribute

### 2. 加载预置动态照片资源

应用启动时自动加载rawfile中的预置动态照片，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)

- 在aboutToAppear中将rawfile资源复制到应用沙箱目录
- 使用MediaAssetManager.loadMovingPhoto加载应用沙箱的动态照片对象
- 预置资源位于entry/src/main/resources/rawfile/moving_photo.jpg和moving_photo.mp4

### 3. 创建动态照片控制器

创建MovingPhotoViewController用于控制播放状态，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)

- 使用new MovingPhotoViewController()创建控制器
- 通过controller.startPlayback()开始播放
- 通过controller.stopPlayback()停止播放

### 4. 创建MovingPhotoView组件

配置MovingPhotoView组件属性和事件，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)

- 设置movingPhoto属性绑定动态照片对象
- 设置controller属性绑定控制器
- 使用muted()设置静音播放
- 使用objectFit()设置视频显示模式
- 使用onStart()监听播放开始事件
- 使用onFinish()监听播放结束事件
- 使用onStop()监听播放停止事件
- 使用onError()监听错误事件

## 约束与限制

1. 当前不支持动态属性设置；
2. 当前不支持设置ArkUI通用属性expandSafeArea；
3. 该组件长按触发播放时组件区域放大为1.1倍；
4. 同时开启的AVPlayer个数不建议超过3个，超过3个可能会出现视频播放卡顿现象。

## 相关权限

- ohos.permission.READ_IMAGEVIDEO - 读取媒体资源时需要
- ohos.permission.WRITE_IMAGEVIDEO - 修改或删除媒体资源时需要

## 依赖

无

## 约束与限制

1. 本示例仅支持标准系统上运行；
2. 本示例支持API22版本SDK，版本号：6.0.2；
3. 本示例需要使用DevEco Studio 6.0.0 Canary1及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo MediaLibraryKit/MovingPhotoViewSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/HarmonyOS_Samples/guide-snippets.git
git pull origin master
```