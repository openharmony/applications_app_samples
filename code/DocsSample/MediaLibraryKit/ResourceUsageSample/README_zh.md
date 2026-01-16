# 媒体资源使用示例

## 简介

本示例展示了如何使用PhotoAccessHelper API管理媒体资产（图像和视频）。示例涵盖了获取媒体资源、检索缩略图、重命名文件和管理回收站等基本操作。

本示例使用的核心包包括：
- [@kit.MediaLibraryKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/medialibrary/Readme-CN.md) - 提供PhotoAccessHelper API用于媒体资源管理
- [@kit.ArkData](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/database/Readme-CN.md) - 提供数据共享和谓词查询能力
- [@kit.ImageKit](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/image/Readme-CN.md) - 提供图像处理和缩略图生成能力

## 使用说明

1. 启动应用后，在主界面可以看到四个功能选项；
2. 点击"获取媒体资源"按钮，根据指定条件（如媒体类型、日期、专辑名称）检索媒体资产；
3. 点击"获取媒体缩略图"按钮，获取指定媒体资源的缩略图；
4. 点击"重命名媒体"按钮，对选定的媒体文件进行重命名操作；
5. 点击"移动媒体到回收站"按钮，将选定的媒体文件移动到回收站；
6. 回收站中的文件将保留30天，之后会被永久删除。

## 工程目录
```
entry/src/main/ets/
├─entryability
│  └─EntryAbility.ets                              # 应用入口
├─entrybackupability
│  └─EntryBackupAbility.ets                        # 备份能力
├─getmediaresourceability
│  └─GetMediaResourceAbility.ets                   # 获取媒体资源功能
├─getmediathumbnailsability
│  └─GetMediaThumbnailsAbility.ets                 # 获取媒体缩略图功能
├─movemediatorecyclebinability
│  └─MoveMediaToRecycleBinAbility.ets              # 移动媒体到回收站功能
├─renamemediaability
│  └─RenameMediaAbility.ets                        # 重命名媒体功能
└─pages
   └─Index.ets                                     # 主界面
entry/src/main/resources/
└─rawfile
   └─test.jpg                                      # 测试图片资源
entry/src/ohosTest/ets/
├─test
│  ├─GetMediaResource.test.ets                     # 获取媒体资源测试用例
│  ├─GetMediaThumbnails.test.ets                   # 获取媒体缩略图测试用例
│  ├─MoveMediaToRecycleBin.test.ets                # 移动到回收站测试用例
│  ├─RenameMedia.test.ets                          # 重命名媒体测试用例
│  └─List.test.ets                                 # 测试用例列表
└─Provider.ets                                     # 测试数据提供者
```

## 具体实现

### 1. 获取媒体资源

根据指定条件检索媒体资产，源码参考：[GetMediaResourceAbility.ets](entry/src/main/ets/getmediaresourceability/GetMediaResourceAbility.ets)

- 获取PhotoAccessHelper实例：使用photoAccessHelper.getPhotoAccessHelper()获取实例；
- 配置查询条件：使用FetchOptions设置搜索条件，包括媒体类型、日期、专辑名称等；
- 执行查询：调用photoAccessHelper.getAssets()根据条件检索媒体资产；
- 获取结果：使用FetchResult从结果集中获取指定位置的媒体对象；
- 释放资源：使用完毕后调用FetchResult.close()释放资源。

### 2. 获取媒体缩略图

检索指定媒体资源的缩略图，源码参考：[GetMediaThumbnailsAbility.ets](entry/src/main/ets/getmediathumbnailsability/GetMediaThumbnailsAbility.ets)

- 获取媒体资源：首先通过getAssets()获取目标媒体资源；
- 请求缩略图：调用photoAsset.getThumbnail()获取缩略图的PixelMap对象；
- 显示缩略图：使用Image组件显示获取到的缩略图；
- 资源管理：使用完毕后释放PixelMap资源。

### 3. 重命名媒体文件

对选定的媒体文件进行重命名操作，源码参考：[RenameMediaAbility.ets](entry/src/main/ets/renamemediaability/RenameMediaAbility.ets)

- 获取媒体资源：通过getAssets()获取需要重命名的媒体资源；
- 设置新名称：指定媒体文件的新名称；
- 执行重命名：调用photoAsset.set()修改displayName属性；
- 提交修改：调用photoAsset.commitModify()提交更改到数据库；
- 错误处理：使用try-catch块处理可能出现的错误。

### 4. 移动媒体到回收站

将选定的媒体文件移动到回收站，源码参考：[MoveMediaToRecycleBinAbility.ets](entry/src/main/ets/movemediatorecyclebinability/MoveMediaToRecycleBinAbility.ets)

- 获取媒体资源：通过getAssets()获取需要删除的媒体资源；
- 移动到回收站：调用photoAccessHelper.deleteAssets()将媒体文件移动到回收站；
- 回收站保留期：文件在回收站中保留30天后自动永久删除；
- 批量操作：支持一次性将多个媒体文件移动到回收站。

## 相关权限

- ohos.permission.READ_IMAGEVIDEO - 读取媒体资源时需要
- ohos.permission.WRITE_IMAGEVIDEO - 修改或删除媒体资源时需要

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
echo code/DocsSample/MediaLibraryKit/ResourceUsageSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```