# 图片编辑

### 介绍

本示例使用 [TextArea](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-textarea.md)
实现多文本输入，使用 [@ohos.app.ability.common](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-common.md)
依赖系统的图库引用，实现在相册中获取图片，使用 [@ohos.multimedia.image](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-image.md)
生成pixelMap，使用pixelMap的scale()，crop()，rotate()接口实现对图片的缩放，裁剪，旋转功能。
使用[@ohos.effectKit](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-effectKit.md)
生成effectKit,使用effectKit.getHighestSaturationColor()
接口实现对图片的高亮调节。添加文字/贴纸，利用组件的组合编辑素材大小和位置，再使用OffscreenCanvasRenderingContext2D进行离屏绘制保存。

### 效果预览

| 编辑删除                                            | 图片调整                                                | 图片标记                                            | 
|-------------------------------------------------|-----------------------------------------------------|-------------------------------------------------|
| ![edit.jpeg](screenshots%2Fdevices%2Fedit.jpeg) | ![adjust.jpeg](screenshots%2Fdevices%2Fadjust.jpeg) | ![crop.jpeg](screenshots%2Fdevices%2Fmark.jpeg) |

| 图片裁剪                                            | 图片缩放                                              | 图片旋转                                                | 
|-------------------------------------------------|---------------------------------------------------|-----------------------------------------------------|
| ![crop.jpeg](screenshots%2Fdevices%2Fcrop.jpeg) | ![scale.jpeg](screenshots%2Fdevices%2Fscale.jpeg) | ![rotato.jpeg](screenshots%2Fdevices%2Frotato.jpeg) |

| 图片亮度调节                                              | 图片添加贴纸                                                | 图片添加文字                                          |  图片色域调节                                              |
|-----------------------------------------------------|-------------------------------------------------------|-------------------------------------------------|-----------------------------------------------------|
| ![toning.jpeg](screenshots%2Fdevices%2Ftoning.jpeg) | ![sticker.jpeg](screenshots%2Fdevices%2Fsticker.jpeg) | ![text.jpeg](screenshots%2Fdevices%2Ftext.jpeg) | ![colorSpace.jpeg](screenshots%2Fdevices%2FcolorSpace.jpeg) |


使用说明：

1. 发表评价页面点击添加图片/照片，页面跳转到图片选择页面；
2. 进入图片选择页面后，选择需要显示的图片；
3. 选中图片后，页面会跳转到发表评价页面，点击图片跳转到图片编辑删除页面，点击编辑进入到编辑功能页；
4. 调整菜单有裁剪、缩放、旋转、调色功能；
5. 标记菜单有添加文字、添加贴纸功能；
6. 编辑完成后，点击撤回按钮图片会还原到上一个编辑状态；
7. 图片编辑完成后，点击保存，页面会跳转到发表评价页面，显示相关照片；
8. 点击返回按钮，退出应用。

### 工程目录

```
entry/src/main/ets/
|---pages
|   |---EditImages.ets                       // 图片编辑
|   |---GetPictrues.ets                      // 图片选择
|   |---Index.ets                            // 首页
|   |---UpadatePages.ets                     // 编辑删除界面
photomodify/src/main/ets/components
|---featrue
|   |---ComputeFeature.ets                   // 计算功能
|   |---PixelMapQueue.ets                    // PixelMap队列
|---model
|   |---AdjustData.ets                       // 功能数据
|   |---AdjustModels.ets                     // 功能模型
|   |---MaterialData.ets                     // 素材数据
|   |---MaterialModels.ets                   // 素材模型
|---pages
|   |---EditImage.ets                        // 图片编辑
|   |---InputTextDialog.ets                  // 输入框弹窗
|   |---MaterialEdit.ets                     // 素材编辑组件
|   |---ScalePhotoPage.ets                   // 图片缩放
|   |---ColorSpacePage.ets                   // 色域修改
|   |---UpdatePage.ets                       // 编辑删除界面
|---util     
|   |---CoordinatesUtil.ets                  // 转换坐标系    
|   |---CopyObj.ets                          // 对象克隆     
|   |---ImageUtil.ets                        // 图片宽高处理                    
|   |---Logger.ets                           // 日志工具
|   |---MediaUtil.ts                         // 媒体帮助类
|   |---SvgUtil.ts                           // svg操作帮助类
```

### 具体实现

+ 图片选择功能在GetPictures中实现，源码参考[GetPictures.ets](entry%2Fsrc%2Fmain%2Fets%2Fpages%2FGetPictures.ets):
    + 图片选择：首先使用startAbilityForResult()启动系统图库应用，然后将选择的图片用select数组保存路径，展示到页面便于选择，选择完跳转到首页，点击一张图片，进入到编辑删除界面。
+ 图片编辑功能在EditImage中实现，源码参考[EditImage.ets](photomodify%2Fsrc%2Fmain%2Fets%2Fcomponents%2Fpages%2FEditImage.ets):
    + 图片编辑：图片编辑权限需要使用[requestPermissionsFromUser](https://gitee.com/openharmony/docs/blob/monthly_20221018/zh-cn/application-dev/reference/apis/js-apis-inner-application-uiAbilityContext.md)
    申请，源码参考[MainAbility.ts](entry/src/main/ets/MainAbility/MainAbility.ts)
    ，首先根据选择图片获取到的uri打开图片文件，fileAsset.open选择‘rw'读写模式，然后使用image.createImageSource创建图片源实例，接下来使用createPixelMap创建PixelMap对象，便于处理图片，最后使用crop对图像进行裁剪处理，使用scale对图像进行缩放处理，rotate进行旋转处理。亮度调节使用effectKit.getHighestSaturationColor()
    接口实现对图片的高亮调节。添加文字/贴纸，编辑模式下，使用组件组合（Image、Shape、Text）进行交互完成素材大小和位置选择；编辑确认后，再使用OffscreenCanvasRenderingContext2D进行离屏绘制，保存为新的pixelMap。

### 相关权限

[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.MEDIA_LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568;
2. 本示例为Stage模型，已适配API version 11版本SDK，SDK版本号(API Version 11 4.1.3.5),镜像版本号(4.1.3.5);
3. 本示例需要使用DevEco Studio 版本号(3.1.0.501)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/Image/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
