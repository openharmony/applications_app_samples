# 图库项目

### 介绍

应用使用[@ohos.file.photoAccessHelper](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
等接口，实现了系统相册图片查看、相册分类和删除的功能。

使用说明：

1. 首页提供“照片”和“相册”两个菜单，默认焦点位于“相册”，支持切换。“照片”页面展示全部照片和视频，“相册”页面包含照片、录屏截屏、视频和最近删除等分类。
2. 焦点位于照片区域时，按确定键可进入预览；选中视频资源时可进入播放界面。
3. 焦点位于册菜单时，按确定键可进入对应相册并浏览其中的照片和视频；选中视频资源时可进入播放界面。
4. 首页按钮可打开底部操作菜单。

### 工程目录
```text
entry/src/main/ets/
|---MainAbility
|   |---EntryAbility.ets             // 入口 Ability
|   |---MainAbility.ets              // 主 Ability
|   |---PickerAbility.ets            // 选择器 Ability
|---common
|   |---Constants.ets                // 常量定义
|   |---GlobalContext.ets            // 全局上下文
|   |---Logger.ets                   // 日志封装
|   |---PhotoPositionUtils.ets       // 媒体位置信息工具
|   |---TraceControllerUtils.ets     // 耗时跟踪工具
|   |---Util.ets                     // 通用工具
|   |---WifiManager.ets              // Wi-Fi 管理
|---component
|   |---DistributedPhotoView.ets     // 分布式图片组件
|---manager
|   |---loader/                      // 媒体加载器
|   |---utils/                       // 文件与图片工具
|   |---DfsManager.ets               // 分布式分享管理
|   |---PhotoManager.ets             // 媒体数据管理
|   |---RdbManager.ets               // 数据库管理
|   |---VideoThumbLoader.ets         // 视频缩略图处理
|---models
|   |---FileSendModel.ets            // 分享数据模型
|   |---IDataSource.ets              // 列表数据源模型
|   |---PhotoModel.ets               // 媒体数据模型
|---pages
|   |---DistributedDevicePage.ets    // 分布式设备页
|   |---Index.ets                    // 首页
|   |---NasClientPage.ets            // NAS 客户端页
|   |---NasSessionPage.ets           // NAS 会话页
|   |---PhotoDeleteList.ets          // 最近删除页
|   |---PhotoList.ets                // 相册列表页
|   |---PhotoWatch.ets               // 图片与视频预览页
|   |---ThirdSelectPhotoGridPage.ets // 三方选择器页面
|---smaba
|   |---client/                      // SMB/NAS 客户端实现
|   |---NasFinder.ets                // NAS 发现
|   |---NasSessionManager.ets        // NAS 会话管理
|---workers
|   |---NasSessionWorker.ets         // NAS 后台任务
```

### 具体实现

- 获取照片列表和相册分类的能力封装在 [Index.ets](entry/src/main/ets/pages/Index.ets)
    * 首页支持在“照片”和“相册”两个菜单之间进行焦点切换，并通过 `phAccessHelper.getAlbums` 获取相册分类数据；
    * 通过 `phAccessHelper.getFileAssets` 获取媒体资源，再通过 `fetchFileResult.getAllObject` 读取检索结果，接口参考：[@ohos.file.photoAccessHelper](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)；
    * 底部菜单支持选择、分享和删除操作，其中删除能力通过 `MediaAssetChangeRequest.deleteAssets` 实现。
- 相册列表页面的能力封装在 [PhotoList.ets](entry/src/main/ets/pages/PhotoList.ets)
    * 通过 `phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype, albumFetchOptions)` 获取系统相册分类，并支持焦点切换和菜单操作。
- 已删除照片列表页面的能力封装在 [PhotoDeleteList.ets](entry/src/main/ets/pages/PhotoDeleteList.ets)
    * 通过 `phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype, albumFetchOptions)` 获取对应分类数据。
- 图片与视频预览能力封装在 [PhotoWatch.ets](entry/src/main/ets/pages/PhotoWatch.ets)
    * 选中照片后可进入预览页面；使用左右方向键可切换上一张或下一张；选中视频后可进入播放界面。

### 相关权限

| 权限名                              | 权限说明                 | 级别           |
|----------------------------------|----------------------|--------------|
| ohos.permission.MEDIA_LOCATION   | 允许应用访问用户媒体文件中的地理位置信息 | normal       |
| ohos.permission.READ_MEDIA       | 允许应用读取用户外部存储中的媒体文件信息 | normal       |
| ohos.permission.WRITE_IMAGEVIDEO | 允许修改用户公共目录的图片或视频文件   | system_basic |
| ohos.permission.READ_IMAGEVIDEO  | 允许读取用户公共目录的图片或视频文件   | system_basic |

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568, V900。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 12 Release),镜像版本号(5.0 Release)

3.本示例需要使用DevEco Studio 版本号(5.0 Release)及以上版本才可编译运行。

4.本示例涉及部分接口需要配置系统应用签名，可以参考[特殊权限配置方法](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)
，把配置文件中的“apl”字段信息改为“system_core”。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVPhotos > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
