# 应用文件访问（C++）

## 介绍

 本实例主要实现了使用C++的方式去访问应用沙箱目录下的文件，使用接口FileManagement_ErrCode OH_FileIO_GetFileLocation(char *uri, int uriLength, FileIO_FileLocation *location),接口的详细说明请参考：FileIO。主要实现的功能是：使用文件uri作为入参，调用C语言函数去访问应用文件，并确定文件的存储位置。该工程中展示的代码详细描述可查如下链接。

- [应用文件访问（C/C++）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/file-management/native-fileio-guidelines.md)

## 效果预览

| 应用启动界面                                      | 文件访问结果                                    |
| ------------------------------------------------- | ----------------------------------------------- |
| <img src="./screenshots/start.jpg" width = "400"> | <img src="./screenshots/end.jpg" width = "400"> |

使用说明：

1. 本应用主要使用napi的方式，使用C语言函数对应用的沙箱文件进行访问，可以在创建文件后向napi定义的函数传递文件的uri参数，通过uri对文件进行访问，并确定文件的存储文件是本地还是云端。
2. 在启动应用之后，按顺序点击界面上的两个按钮，先创建文件，在对文件进行访问，通过日的反馈知道访问的结果。

## 工程目录

```
NDKAppFileSample
├──entry/src/main
|	├──cpp
|	|	├──types
|	|	|	├──libentry				
|	|	|	└──CMakeLists.txt        	// CMake脚本文件
|	|	|	└──napi_init.cpp			// napi函数封装类 
|	├──ets
|	|	├──commom
|	|	|	├──Logger.ts				// 封装日志类
|	|	├──entryability
|	|	|	└──EntryAbility.ets         // 程序入口类
|	|	├──entrybackupability
|	|	|	└──EntryBackupAbility.ets   
|	|	├──fileFs
|	|	|	└──fileFs.ets               // 文件创建函数封装
|	|	└──pages                        // 页面文件
|	|		└──Index.ets 				// 主界面
|	├──resources						// 资源文件目录	
```

## 具体实现

1. 在CMake脚本中链接动态库，即在CMakeLists.txt中添加以下lib。

   ```
   target_link_libraries(sample PUBLIC libohfileio.so)
   ```

2. 添加头文件

   ```
   #include <filemanagement/fileio/oh_fileio.h>
   ```

3. 调用OH_FileIO_GetFileLocation接口获取文件存储位置。示例代码如下所示：

   ```c
       void GetFileLocationExample() {
           char *uri = "file://com.example.demo/data/storage/el2/base/files/test.txt";
           FileIO_FileLocation location;
           FileManagement_ErrCode ret = OH_FileIO_GetFileLocation(uri, strlen(uri), &location);
           if (ret == 0) {
               if (location == FileIO_FileLocation::LOCAL) {
                   printf("This file is on local.");
               } else if (location == FileIO_FileLocation::CLOUD) {
                   printf("This file is on cloud.");
               } else if (location == FileIO_FileLocation::LOCAL_AND_CLOUD) {
                   printf("This file is both on local and cloud.");
               }
           } else {
               printf("GetFileLocation failed, error code is %d", ret);
           }
       }    
   ```

## 相关权限

无

## 依赖

不涉及

## 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.58，镜像版本号：OpenHarmony 5.0.2.58。

3.本示例需要使用DevEco Studio 5. 1Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

## 下载

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/NDKAppFileSample > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

