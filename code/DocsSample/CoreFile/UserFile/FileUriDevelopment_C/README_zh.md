# FileUri开发指导(C/C++)

### 介绍

该工程提供了关于文件URI的基本操作，对外提供了URI与沙箱路径之间互相转换、远端URI判定、获取URI所在目录路径的URI等接口，方便用户将文件URI与沙箱路径相互转换。该工程中展示的代码详细描述可查如下链接。

- [FileUri开发指导(C/C++)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/native-fileuri-guidelines.md)

### 效果预览

|主页|
|--------------------------------|
|<img src="PageImg\FileUriDevelopment_c.jpeg" style="zoom:50%;" width="400" />|

使用说明:

1. 在主界面，点击GetUriFromPath接口按钮获取代码里指定文件路径对应的uri，并输出到文本框里。
2. 在主界面，点击GetPathFromUri接口按钮获取代码里指定uri对应的文件路径，并输出到文本框里。
3. 在主界面，点击GetFullDirectoryUri接口按钮获取代码里指定文件uri所在路径的uri，并输出到文本框里。
4. 在主界面，点击IsValidUri接口按钮判断代码里指定文件uri是否正确，并判断结果输出到文本框里。
5. 在主界面，点击GetFileName接口按钮获取uri中的文件名称，并输出到文本框里。
6. 切换到Deveco日志页面，搜索”HiAppEvent eventInfo“，出现以下日志。

```
HiAppEvent eventInfo.WatcherType=OnTrigger: /data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: file://com.samples.fileuridevelopment_c/data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: file://com.samples.fileuridevelopment_c/data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: /data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: file://com.samples.fileuridevelopment_c/data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: file://com.samples.fileuridevelopment_c/data/storage/el2/base/haps/entry/files
HiAppEvent eventInfo.WatcherType=OnTrigger: file://com.samples.fileuridevelopment_c/data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: file://com.samples.fileuridevelopment_c/data/storage/el2/base/haps/entry/files/test.txt
HiAppEvent eventInfo.WatcherType=OnTrigger: test.txt
```



### 工程目录

```
├──entry/src/main
|	├──cpp
|	|	└──CMakeLists.txt 				// 动态库链接
|	|	└──napi_init.cpp 				// c++函数实现文件
|	|	├──types                        // c++函数配置目录
|	├──ets
|	|	├──entryability
|	|	|	└──EntryAbility.ets 		// 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	└──pages   						// 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录
```

### 具体实现

* 在CMake脚本中链接动态库，添加头文件。
  
* 调用OH_FileUri_GetUriFromPath接口，在接口中malloc的内存需要在使用完后释放，因此需要free对应的内存。
* 调用OH_FileUri_GetPathFromUri通过URi转成对应的PATH，在接口中malloc的内存需要在使用完后释放，因此需要free对应的内存。 
* 调用OH_FileUri_GetFullDirectoryUri获取URI所在路径的URI，在接口中malloc的内存需要在使用完后释放，因此需要free对应的内存。
* 调用OH_FileUri_IsValidUri接口进行URI格式验证。
* 调用OH_FileUri_GetFileName获取URI中的文件名称，在接口中malloc的内存需要在使用完后释放，因此需要free对应的内存。

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1.转换或者判断URI类型之前必须保证传入的参数正确有效。

2.为保证数据的准确性，在转换或者判断过程中只允许处理一个对象。

3.本示例仅支持标准系统上运行，支持设备：RK3568。

4.本示例已适配API16版本SDK，版本号：5.1.0.47，镜像版本号：OpenHarmony5.1.0.47。

5.本示例需要使用DevEco Studio (5.0.3.910)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/UserFile/FileUriDevelopment_C > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```