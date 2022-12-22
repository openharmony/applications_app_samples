# 文件管理（标题以特性命名）

### 介绍

需要介绍本sample的主要实现原理，如使用了什么API、有什么关键性的配置和实现等等，附上链接，后面需要加上应用的使用说明，示例如下：

本示例主要展示了文件管理相关的功能，使用[mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md)、[userFileManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-userfilemanager.md)、[fileio](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-fileio.md)等接口，实现了媒体库文件、应用沙箱内文件的添加和访问等功能;

使用说明：
1. 在主界面，可以点击图片、视频、文档、音频等按钮进入对应目录的文件列表浏览界面；
2. 在文件列表浏览界面，点击“+”按钮，可以添加文件；
3. 在文件列表浏览界面，长按列表项会出现删除图片，点击删除图标可以删除文件；
4. 在图片文件列表界面，点击图片可以进入图片预览界面；

### 效果预览

屏幕截屏或者视频，文件不超过4个，每张截屏图片不能太大，推荐占1/4页左右，每张图片附上图片标题，示例效果如下所示；

|主页|悬浮模式|列表|悬浮模式|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|![image](MultiDeviceAppDev/MusicAlbum/screenshots/device/img1.png)|![image](MultiDeviceAppDev/MusicAlbum/screenshots/device/img2.png)|![image](MultiDeviceAppDev/MusicAlbum/screenshots/device/index.png)|![image](MultiDeviceAppDev/MusicAlbum/screenshots/device/img2.png)|

### 相关权限

附上使用到权限和链接，示例如下：

[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

如果涉及依赖其他Sample，需要进行说明，并且附上链接；


### 约束与限制

描述一些设备、SDK版本、IDE版本、接口限制、签名等约束和限制，示例如下：

1. 本示例仅支持标准系统上运行，支持设备：RK3568;
2. 本示例仅支持API9版本SDK，版本号：3.2.7.5，本示例涉及使用系统接口：@ohos.multimedia.mediaLibrary中的deleteAsset接口，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)；
3. 本示例需要使用DevEco Studio 3.0 Release (Build Version: 3.0.0.993)才可编译运行；
4. 本示例涉及系统接口，需要配置系统应用签名，可以参考[特殊权限配置方法](https://docs.openharmony.cn/pages/v3.2Beta/zh-cn/application-dev/security/hapsigntool-overview.md/)，把配置文件中的“app-feature”字段信息改为“hos_system_app”。
