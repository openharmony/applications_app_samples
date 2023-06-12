# 图片显示

### 介绍

本示例展示从相册选择图片展示在商品评价页面。

本示例使用 [TextArea](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-textarea.md) 组件实现多文本输入，使用 [mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-mediaquery.md) 实现图片的获取，选择。 

### 效果预览
|主页| 打开相册                                       | 选中图片                                   | 发表评价                                 |
|--------------------------------|--------------------------------------------|----------------------------------------|--------------------------------------|
|![](screenshots/devices/zh/index.png) | ![](screenshots/devices/zh/not_choice.png) | ![](screenshots/devices/zh/choice.png) | ![](screenshots/devices/zh/show.png) |

使用说明：

1.点击添加图片/照片，页面跳转到图片选择页面。

2.进入图片选择页面后，选择需要显示的图片，选择的图片数量会显示在右上方，选择的图片会显示在下方。最多选择6张图片。

3.选定图片后点击下一步，页面会跳转回主页面，图片显示在主页。若不确定选择，点击添加图片/照片进行重新选择。

4.图片选择后，点击文本输入框，可以对商品进行评价。

5.点击返回按钮，退出应用。

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts                    
|---MainAbility
|   |---MainAbility.ts                    
|---pages
|   |---Index.ets                      // 首页
|   |---ChoicePhoto.ets                // 添加图片/照片
```

### 具体实现

* 本示例分为三个模块：
  * 发表评价页面模块：
    * 使用scroll，TextArea，Grid等组件开发发表评价页面
    * 源码链接：[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 参考接口：[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)

  * 选择图片/照片模块
    * 调用依赖中ChoicePhotos方法打开相册，mediaquery媒体查询相册，getMediaLibrary获取媒体库的实例，访问用户等个人媒体数据信息并选中图片
    * 源码链接：[ChoicePhotos.ets](imagelibrary/src/main/ets/components/pages/ChoicePhotos.ets)，[MainAbility.ts](entry/src/main/ets/MainAbility/MainAbility.ts)
    * 参考接口：[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)，[@ohos.promptAction](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-promptAction.md)，[@ohos.mediaquery](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-system-mediaquery.md)，[@ohos.multimedia.mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md)，[@ohos.abilityAccessCtrl](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-abilityAccessCtrl.md)
  
  * 提交模块
    * 选中图片后点击下一步按钮，回到发表评价页面，点击提交按钮进行提交
    * 源码链接：[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 参考接口：[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)

### 相关权限

允许应用读取用户外部存储中的媒体文件信息：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionread_media)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/ImageShow/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```