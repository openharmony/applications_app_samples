# 图片处理

### 介绍

本示例使用 [TextArea](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-textarea.md) 实现多文本输入，使用 [@ohos.multimedia.mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md) 实现在相册中获取图片，使用 [@ohos.multimedia.image](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-image.md) 生成pixelMap，使用pixelMap的scale()，crop()，rotate()接口实现对图片的缩放，裁剪，旋转功能。

### 效果预览
|图片缩放|图片裁剪|图片旋转|
|-----|-----|-------|
|![](screenshots/devices/zh/scale.png)|![](screenshots/devices/zh/crop_choice.png)|![](screenshots/devices/zh/rotate.png)|

使用说明：
1. 发表评价页面点击添加图片/照片，页面跳转到图片选择页面。
2. 进入图片选择页面后，选择需要显示的图片，最多选择6张图片。
3. 选中图片后点击下一步，页面会跳转到图片编辑页面，点击缩放，页面会显示缩小，放大按钮，点击按钮，可对图片进行缩小，放大操作。点击裁剪，页面会跳出裁剪比例，点击想要裁剪的比例可以对图片进行裁剪。点击旋转可对图片进行旋转。
4. 图片编辑完成后，点击**确认**，页面会跳转到发表评价页面，显示相关照片。点击添加图片/照片可以对图片进行重新选择。
5. 点击返回按钮，退出应用。

### 工程目录
```
entry/src/main/ets/
|---pages
|   |---ChoicePhotos.ets                    // 图片选择
|   |---EditPages.ets                       // 图片编辑
|   |---Index.ets                           // 首页
photomodify/src/main/ets/components
|---pages
|   |---ChoicePhoto.ets                     // 图片选择
|   |---EditPage.ets                        // 图片编辑
|---util                                  
|   |---Logger.ts                           // 日志工具
```
### 具体实现
+ 图片选择功能在ChoicePhoto中实现，源码参考[ChoicePhoto.ets](photomodify/src/main/ets/components/pages/ChoicePhoto.ets):
  + 图片选择：首先使用getMediaLibrary获取媒体库实例，然后使用getFileAssets获取资源文件集，接着使用getAllObject获取文件检索结果中的所有文件资产，展示到页面便于选择，选择完跳转到图片编辑，传递目标图片的uri；
+ 图片编辑功能在EditPage中实现，源码参考[EditPage.ets](photomodify/src/main/ets/components/pages/EditPage.ets):
  + 图片编辑：图片编辑权限需要使用[requestPermissionsFromUser](https://gitee.com/openharmony/docs/blob/monthly_20221018/zh-cn/application-dev/reference/apis/js-apis-inner-application-uiAbilityContext.md)申请，源码参考[MainAbility.ts](entry/src/main/ets/MainAbility/MainAbility.ts)，首先根据选择图片获取到的uri打开图片文件，fileAsset.open选择‘rw'读写模式，然后使用image.createImageSource创建图片源实例，接下来使用createPixelMap创建PixelMap对象，便于处理图片，最后使用crop对图像进行裁剪处理，使用scale对图像进行缩放处理，rotate进行旋转处理。
### 相关权限

[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.MEDIA_LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制
1. 本示例仅支持标准系统上运行，支持设备：RK3568;
2. 本示例为Stage模型，已适配API10版本SDK，版本号：4.0.5.1;
3. 本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/Image/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```