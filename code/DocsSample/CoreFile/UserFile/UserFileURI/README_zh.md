# 用户文件uri介绍

### 介绍

本示例主要展示了有关用户文件uri的功能，使用DocumentViewPicker接口 、AudioViewPicker接口、fileAccess模块、fs模块、photoAccessHelper模块、userFileManager模块、createFileAccessHelper等，实现了获取文档类uri、获取媒体文件uri、通过uri复制文件的功能。该工程中展示的代码与权限等详细描述可查如下链接。

- [用户文件uri介绍](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/user-file-uri-intro.md)

### 效果预览

|主页|
|:------------------------------:|
|<img src="PageImg\UserFileURI.jpeg" alt="主页" width="400" />|

使用说明:

1. 在主界面，可以选择点击ReadDocumentUri、ReadMediaUri、CopyAFile按钮使用对应的功能。
2. 点击ReadDocumentUri按钮，将在指定目录创建一个文件，在日志中打印文件的uri，重命名该文件，再次打印该文件的uri，成功后将输出“ReadDocumentUriSuccess”到主页文本框，在Deveco日志中搜索“rename success, renameUri”，有对应的日志。
3. 点击ReadMediaUri按钮，拉起PhotoAccessHelper的PhotoViewPicker选择已有媒体文件或拍摄一个媒体文件，读取该媒体文件的uri已经基本信息，并输出“ReadMediaUriSuccess”到主页文本框，在Deveco日志中搜索“PhotoViewPicker.select successfully”，有对应的日志。
4. 点击CopyAFile按钮，复制指定文件到指定目录，并输出”CopyAFileSuccess“到主页文本框，在Deveco日志中搜索“copyFile success, fileUr“，有对应的日志。
5. 点击SelectDocumentFile按钮，可以调用Picker选择查看创建的文档类文件与复制的文档类文件，直观查看创建和复制结果。

### 工程目录

```
├──entry/src/main
|	├──ets
|	|	├──common
|	|	|	└──Logger.ts 		        // 日志打印封装类
|	|	|	└──PermissionUtils.ets 		// 权限申请封装类
|	|	├──entryability
|	|	|	└──EntryAbility.ets 		// 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	└──pages   						// 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录
```

### 具体实现

* 文档类uri获取方式：
    * 通过[文件选择器（FilePicker）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md#ohosfilepicker-选择器)的DocumentViewPicker接口选择或保存文件，返回选择或保存的文件uri。
    * 通过[文件选择器（FilePicker）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md#ohosfilepicker-选择器)的AudioViewPicker接口选择或保存文件，返回选择或保存的文件uri。
    * 通过[fileAccess模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileAccess-sys.md)获取文件uri，使用获取到的文件uri进行重命名操作。
    * 通过[fileAccess模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileAccess-sys.md)获取文档类目录下的文件得到对应文件的FileInfo对象，此对象中就包含对应文件或者目录的uri属性，此模块中的接口为系统接口，使用此模块需要注意应用是否为系统应用。支持获取文件uri的目录有：
      - 外部存储目录
      - Docs目录
      - Download目录
      - Desktop目录
      - Documents目录
      - Share共享盘目录

* 媒体文件uri使用方式：
    * 通过[photoAccessHelper模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)的PhotoViewPicker选择媒体文件，返回选择的媒体文件文件的uri。
    * 通过[photoAccessHelper模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)模块中的getAssets或createAsset接口获取媒体文件对应文件的uri。
    * 通过[userFileManager模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-userFileManager-sys.md)中的getPhotoAssets、getAudioAssets、createAudioAsset或createPhotoAsset接口获取媒体文件对应文件的uri。
    * normal等级的应用使用此类uri可以通过[photoAccessHelper模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)模块进行进一步处理。
    * system_basic等级及以上的应用使用此类uri的方式除了上述通过[photoAccessHelper模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)外还可以通过[userFileManager模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-userFileManager-sys.md)进行进一步处理。
    * 若normal等级的应用也可以通过临时授权的方式使用[photoAccessHelper模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)的PhotoViewPicker得到的uri使用photoAccessHelper.getAssets接口获取对应uri的PhotoAsset对象。这种方式获取的对象可以调用getThumbnail获取缩略图和使用get接口读取PhotoKeys中的部分信息。
* 用户复制文件到指定目录：
    * 通过[fileAccess模块](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileAccess-sys.md)的createFileAccessHelper接口创建fileAccessHelper helper。
    * 获取源文件的srcUri。
    * 获取目的路径的destUri。
    * 获取备用名 fileName。
    * 使用helper.copyFile(srcUri, destUri, fileName) 进行文件操作。

### 相关权限

[ohos.permission.FILE_ACCESS_MANAGER](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionfile_access_manager)

[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionget_bundle_info_privileged)

[ohos.permission.READ_IMAGEVIDEO](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionread_imagevideo)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API16版本SDK，版本号：5.1.0.47，镜像版本号：OpenHarmony5.1.0.47。

3.本示例需要使用DevEco Studio （5.0.3.910）及以上版本才可编译运行。

4.本示例相关权限为system_basic级别，需要配置高权限签名，可参考[申请使用受控权限](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/declare-permissions-in-acl.md)。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/UserFile/UserFileURI > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

