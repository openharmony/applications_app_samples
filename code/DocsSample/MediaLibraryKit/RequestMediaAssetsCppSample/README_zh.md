# 使用MediaAssetManager请求媒体资源示例

## 简介

本示例展示了如何使用MediaAssetManager请求媒体资源。通过Native API，开发者可以创建MediaAssetManager实例、配置请求策略、请求图片资源，并在必要时取消请求。

本示例使用的核心包包括：
- [@kit.MediaLibraryKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/medialibrary/Readme-CN.md) - 提供MediaAssetManager的Native API用于请求媒体资源
- [@kit.CoreFileKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/file-management/Readme-CN.md) - 提供文件系统访问能力
- [@kit.AbilityKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/Readme-CN.md) - 提供应用能力相关支持

## 使用说明

1. 开发前需要在module.json5中申请ohos.permission.READ_IMAGEVIDEO权限；
2. 在CMake脚本中链接libmedia_asset_manager.so动态库；
3. 在代码中包含必要的头文件：media_asset_manager_capi.h和media_asset_base_capi.h；
4. 创建MediaAssetManager实例，设置资源请求回调和请求策略；
5. 调用OH_MediaAssetManager_RequestImageForPath()向目标URI请求图片资源；
6. 请求完成后，通过OnDataPrepared回调函数处理结果；
7. 如需取消请求，可调用OH_MediaAssetManager_CancelRequest()接口。

## 工程目录
```
entry/src/main/cpp/
├─CMakeLists.txt                         # CMake构建配置文件
├─types/libentry/
│  └─Index.d.ts                          # TypeScript类型定义
└─napi_init.cpp                          # Native C++实现代码
entry/src/main/ets/
├─entryability
│  └─EntryAbility.ets                    # 应用入口
├─entrybackupability
│  └─EntryBackupAbility.ets              # 备份能力
└─pages
   └─Index.ets                           # 主界面
```

## 具体实现

### 1. 链接动态库

在CMake脚本中链接MediaAssetManager动态库，源码参考：[CMakeLists.txt](entry/src/main/cpp/CMakeLists.txt)

- 添加动态库链接：在CMakeLists.txt中使用target_link_libraries链接libmedia_asset_manager.so；
- 配置头文件路径：确保包含必要的头文件搜索路径；
- 编译Native模块：使用CMake构建系统编译Native代码。

### 2. 创建MediaAssetManager实例

使用OH_MediaAssetManager_Create()创建MediaAssetManager实例，源码参考：[napi_init.cpp](entry/src/main/cpp/napi_init.cpp)

- 包含头文件：引入media_asset_manager_capi.h和media_asset_base_capi.h；
- 创建实例：调用OH_MediaAssetManager_Create()获取MediaAssetManager实例；
- 实例管理：保存实例指针以便后续使用。

### 3. 配置请求选项

设置资源请求回调、请求策略、源图片URI和目标URI，源码参考：[napi_init.cpp](entry/src/main/cpp/napi_init.cpp)

- 设置回调函数：定义OnDataPrepared回调函数处理请求完成事件；
- 配置请求策略：使用MEDIA_LIBRARY_HIGH_QUALITY_MODE请求高质量图片资源；
- 指定URI：设置源图片URI和目标保存URI。

### 4. 请求图片资源

调用OH_MediaAssetManager_RequestImageForPath()请求图片资源，源码参考：[napi_init.cpp](entry/src/main/cpp/napi_init.cpp)

- 执行请求：调用OH_MediaAssetManager_RequestImageForPath()发起图片资源请求；
- 获取请求ID：成功的请求返回有效的UUID格式请求ID；
- 错误处理：失败的请求返回错误ID "00000000-0000-0000-0000-000000000000"；
- 回调处理：在OnDataPrepared回调中接收请求结果和请求ID。

### 5. 取消请求（可选）

如需取消正在进行的请求，调用OH_MediaAssetManager_CancelRequest()，源码参考：[napi_init.cpp](entry/src/main/cpp/napi_init.cpp)

- 取消请求：使用请求ID调用OH_MediaAssetManager_CancelRequest()取消请求；
- 资源释放：取消请求后释放相关资源；
- 可选操作：此步骤为可选，开发者可根据实际需求决定是否调用。

## 相关权限

- ohos.permission.READ_IMAGEVIDEO - 读取媒体资源时需要


## 依赖

无

## 约束与限制

1. 本示例仅支持标准系统上运行；
2. 本示例支持API23版本SDK，版本号：6.1.0.23；
3. 本示例需要使用DevEco Studio 6.0.0 Canary1（构建版本：6.0.0.63，构建于2025年10月30日）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo MediaLibraryKit/RequestMediaAssetsCppSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```