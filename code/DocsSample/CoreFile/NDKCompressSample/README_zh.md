# 应用压缩与解压（C++）

## 介绍

本实例主要实现了使用C++的方式对应用沙箱目录下的文件进行压缩与解压，使用接口`OH_Archive_BufferWrite`、`OH_Archive_BufferRead`、`OH_Archive_StreamWrite_*`、`OH_Archive_StreamRead_*`、`OH_Archive_Writer_*`和`OH_Archive_Reader_*`等API，接口的详细说明请参考：Archive。主要实现的功能包括：基于Buffer的内存压缩与解压、基于Stream的流式压缩与解压（含取消操作）、以及基于Zip文件的压缩与解压。该工程中展示的代码详细描述可查如下链接。

- [应用压缩与解压（C/C++）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/file-management/native-compression-guidelines.md)

## 效果预览

| 应用启动界面 |
|------------|
| <img src="./screenshots/start.jpg" width="400"> |

使用说明：

1. 本应用主要使用napi的方式，使用C语言函数对应用沙箱中的文件进行压缩与解压操作。
2. 启动应用后，按顺序点击界面上的按钮，分别体验Buffer压缩/解压、Stream压缩/解压（含取消）、Zip文件压缩/解压功能，通过日志反馈查看运行结果。

## 工程目录

```
NDKCompressSample
├──entry/src/main
|  ├──cpp
|  |  ├──types
|  |  |  └──libentry
|  |  |     └──Index.d.ts             // NAPI接口类型声明
|  |  ├──CMakeLists.txt              // CMake脚本文件
|  |  └──napi_init.cpp               // napi函数封装，实现压缩解压功能
|  ├──ets
|  |  ├──entryability
|  |  |  └──EntryAbility.ets         // 程序入口类
|  |  ├──entrybackupability
|  |  |  └──EntryBackupAbility.ets
|  |  └──pages
|  |     └──Index.ets                // 主界面，调用napi接口触发压缩解压
|  ├──resources                      // 资源文件目录
```

## 具体实现

1. 在CMake脚本中链接动态库，即在CMakeLists.txt中添加以下lib。

   ```
   target_link_libraries(entry PUBLIC libace_napi.z.so PUBLIC liboharchive.so)
   ```

2. 添加头文件

   ```
   #include <filemanagement/archive/oh_archive.h>
   ```

3. 调用压缩解压接口。示例代码如下所示：

   **Buffer压缩：**

   ```c
   // 计算压缩输出缓冲区大小
   uint64_t bound = OH_Archive_BufferWriteCompressBound(OH_ARCHIVE_COMPRESS_DEFLATE, sourceLen);
   dest = (uint8_t *)malloc(bound);
   destLen = bound;
   
   // 执行压缩
   OH_Archive_ErrCode ret = OH_Archive_BufferWrite(dest, &destLen,
       reinterpret_cast<uint8_t *>(source), sourceLen, OH_ARCHIVE_COMPRESS_DEFLATE, 0);
   ```

   **Stream压缩：**

   ```c
   // 创建Stream压缩上下文
   OH_Archive_Stream_Config config;
   config.blockSize = 65536;
   config.threadNum = 4;
   config.method = OH_ARCHIVE_COMPRESS_DEFLATE;
   config.checksum = OH_ARCHIVE_CRC32;
   OH_Archive_StreamWrite_Ctx ctx = OH_Archive_StreamWrite_Create(config);
   
   // 开始压缩
   OH_Archive_StreamWrite_Start(ctx, WriteCallBack, fout);
   
   // 分块写入压缩数据
   while ((read = fread(buffer, 1, bufferSize, fi)) > 0) {
       OH_Archive_StreamWrite_Update(ctx, buffer, read);
   }
   
   // 结束压缩
   OH_Archive_StreamWrite_End(ctx, &streamInfo);
   ```

   **Zip文件压缩：**

   ```c
   // 创建Zip写入上下文
   OH_Archive_Writer_Ctx arc = OH_Archive_Writer_OpenFile(zipPathBuf,
       OH_ARCHIVE_OPEN_MODE_CREATE, OH_ARCHIVE_FMT_ZIP);
   
   // 设置压缩方法
   OH_Archive_Writer_SetCompressMethod(arc, OH_ARCHIVE_COMPRESS_DEFLATE, 6);
   
   // 添加文件到Zip
   OH_Archive_Writer_Add(arc, srcFiles.data(), srcFiles.size());
   
   // 关闭zip文件
   OH_Archive_Writer_Close(arc);
   ```

   **Zip文件解压：**

   ```c
   // 打开Zip文件
   OH_Archive_Reader_Ctx ctx = OH_Archive_Reader_OpenFile(zipPathBuf);
   
   // 解压全部文件到目标目录
   OH_Archive_Reader_ExtractAllFile(ctx, outDirBuf);
   
   // 关闭
   OH_Archive_Reader_Close(ctx);
   ```

## 相关权限

无

## 依赖

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.58，镜像版本号：OpenHarmony 5.0.2.58。

3. 本示例需要使用DevEco Studio 5.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

## 下载

```
git init
git config core.sparsecheckout true
echo code/DocsSample/CoreFile/NDKCompressSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
