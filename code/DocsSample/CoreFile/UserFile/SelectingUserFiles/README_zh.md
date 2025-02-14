# 选择用户文件

### 介绍

本示例主要展示了通过文件选择器（FilePicker）拉起对应的应用访问，相关文件。根据用户文件的常见类型，选择器（FilePicker）分别提供以下选项：

- PhotoViewPicker：适用于图片或视频类型文件的选择与保存（该接口在后续版本不再演进）。请使用PhotoAccessHelper的PhotoViewPicker来选择图片文件。请使用[安全控件创建媒体资源](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/media/medialibrary/photoAccessHelper-savebutton.md#使用安全控件保存媒体库资源)。
- DocumentViewPicker：适用于文件类型文件的选择与保存。DocumentViewPicker对接的选择资源来自于FilePicker, 负责文件类型的资源管理，文件类型不区分后缀，比如浏览器下载的图片、文档等，都属于文件类型。
- AudioViewPicker：适用于音频类型文件的选择与保存。AudioViewPicker目前对接的选择资源来自于FilePicker。

该工程中展示的代码与权限等详细描述可查如下链接。

- [选择用户文件](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/select-user-file.md)

### 效果预览

|主界面|
|--------------------------------|
|<img src="PageImg\SelectingUserFiles.jpeg" alt="主页" style="zoom: 33%;" width="400" />|

| Picker                                                       |
| ------------------------------------------------------------ |
| <img src="PageImg\AudioPicker.jpeg" alt="Picker页面" style="zoom:33%;" width="400" /> |

使用说明:

1. 在主界面，可以SelectDocument按钮，拉起FilePicker应用，选择指定目录下的文档类文件，将读取成功的结果输出到文本框，并将文档类文件有关数据输出到日志，搜索”readSync data to file succeed and buffer size is“有对应日志。
2. 在主界面，可以SelectAudio按钮，拉起AudioFilePicker应用，出现如上Picker页面即可。

### 工程目录

```
├──entry/src/main
|	├──ets
|	|	├──common
|	|	|	└──Logger.ts 		        // 日志打印封装类
|	|	├──entryability
|	|	|	└──EntryAbility.ets 		// 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	└──pages   						// 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录
```

### 具体实现

* 选择文档类文件：
    * 导入[@ohos.file.picker（选择器）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md#ohosfilepicker-选择器)模块和[@ohos.file.fs （文件管理）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-fs.md)模块。
    * 创建文件类型、文件选择选项实例。
    * 创建文件选择器DocumentViewPicker实例。调用select()接口拉起FilePicker应用界面进行文件选择。
    * 待界面从FilePicker返回后，使用基础文件API的fs.openSync接口通过uri打开这个文件得到文件描述符(fd)。
    * 通过fd使用基础文件API的fs.readSync接口读取文件内的数据。
* 选择音频类文件：
    * 导入[@ohos.file.picker（选择器）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md#ohosfilepicker-选择器)模块、[@ohos.file.fs （文件管理）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-fs.md)模块、[PhotoAccessHelper](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)模块。
    * 创建音频类型文件选择选项实例。
    * 创建音频选择器AudioViewPicker实例。调用select()接口拉起FilePicker应用界面进行文件选择。
    * 待界面从FilePicker返回后，可以使用基础文件API的fs.openSync接口通过uri打开这个文件得到文件描述符(fd)。
    * 通过fd使用基础文件API的fs.readSync接口读取文件内的数据。

### 相关权限

[ohos.permission.FILE_ACCESS_MANAGER](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionfile_access_manager)

[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionget_bundle_info_privileged)

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
echo code/DocsSample/CoreFile/UserFile/SelectingUserFiles > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

