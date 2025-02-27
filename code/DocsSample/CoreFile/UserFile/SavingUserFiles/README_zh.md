# 保存用户文件

### 介绍

本示例主要展示了有关保存用户文件的功能，使用PhotoViewPicker、PhotoAccessHelper、@ohos.file.picker（选择器）、@ohos.file.fs （文件管理）、fs.openSync、fs.writeSync、AudioViewPicker等，实现了保存文件的功能。该工程中展示的代码与接口等详细描述可查如下链接。

- [保存用户文件](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/save-user-file.md)

### 效果预览

|主页|
|--------------------------------|
|<img src="PageImg\SavingUserFiles.jpeg" alt="首页" style="zoom:50%;" width="400" />|

使用说明:

1. 在主界面，然后点击SaveDocument按钮，选择保存的路径并确认，成功后返回成功结果到页面文本框，并在日志中输出“write data to file succeed and size is:”内容。
2. 点击ReadFiles按钮，选择指定文件夹下的文档类文件，将选择成功结果输出到页面文本框中，并在日志中输出“readSync data to file succeed and buffer size is:”内容，验证保存文件是否成功。
3. 点击SaveAudioFiles按钮，选择保存文件的路径，成功将保存成功结果返回到页面文本框中，并在日志中输出“write data to file succeed and size is:”内容。

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

* 保存文档类文件：
    * 导入[@ohos.file.picker（选择器）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md#ohosfilepicker-选择器)模块和[@ohos.file.fs （文件管理）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-fs.md)模块。
    * 创建文档保存选项实例。
    * 创建文件选择器DocumentViewPicker实例。调用save()接口拉起FilePicker界面进行文件保存。
    * 待界面从FilePicker返回后，使用基础文件API的fs.openSync接口，通过URI打开这个文件得到文件描述符(fd)。
    * 通过(fd)使用基础文件API的fs.writeSync接口对这个文件进行编辑修改，编辑修改完成后关闭(fd)。
* 保存音频类文件：
    * 导入[@ohos.file.picker（选择器）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md#ohosfilepicker-选择器)模块、[@ohos.file.fs （文件管理）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-fs.md)模块、[PhotoAccessHelper](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper.md)模块。
    * 创建音频保存选项实例。
    * 创建音频选择器AudioViewPicker实例。调用save()接口拉起FilePicker界面进行文件保存。
    * 待界面从FilePicker返回后，可以使用基础文件API的fs.openSync接口，通过URI打开这个文件得到文件描述符(fd)。
    * 通过(fd)使用基础文件API的fs.writeSync接口对这个文件进行编辑修改，编辑修改完成后关闭(fd)。

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API16版本SDK，版本号：5.1.0.47，镜像版本号：OpenHarmony5.1.0.47。

3.本示例需要使用DevEco Studio （5.0.3.910）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/UserFile/SavingUserFiles > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```