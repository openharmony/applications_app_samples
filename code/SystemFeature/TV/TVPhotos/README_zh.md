# 图库项目

### 介绍

应用使用[@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
等接口，实现了系统相册图片查看、相册分类和删除的功能。

使用说明：

1. 首页提供“照片”和“相册”两个菜单，默认焦点位于“相册”，支持切换。“照片”页面展示全部照片和视频，“相册”页面包含照片、录屏截屏、视频和最近删除等分类。
2. 焦点位于照片区域时，按确定键可进入预览；选中视频资源时可进入播放界面。
3. 焦点位于册菜单时，按确定键可进入对应相册并浏览其中的照片和视频；选中视频资源时可进入播放界面。
4. 首页按钮可打开底部操作菜单。

### 工程目录`
entry/src/main/ets/
|---base
|	|---PhotoFileUri.ts                 //系统接口封装
|---common  
|	|---Constants.ts                    //常量定义
|	|---GlobalContext.ts	            //全局上下文管理
|	|---Logger.ts                       //日志封装
|	|---Common.ts                       //权限处理工具
|	|---TraceControllerUtils.ts         //耗时跟踪工具
|	|---Utils.ts                        //弹窗与日志工具
|	|---WifiManager.ts                  //Wi-Fi 管理
|---entryability
|	|---MainAbility.ts                  //应用入口能力
|---model
|	|---AlbumModel.ts                   //相册数据模型
|	|---FileSendModel.ts                //文件分享数据模型
|	|---IDataSource.ets                 //列表数据源模型
|	|---PhotoModel.ts                   //照片数据模型
|---pages
|	|---Index.ets                       //首页（照片和相册）
|	|---PhotoList.ets                   //照片删除列表
|	|---PhotoList.ets                   //照片列表
|	|---PhotoWatch.ets                  //查看图片和视频界面
```

### 具体实现

- 获取照片列表和相册分类的能力封装在 [Index.ets](entry/src/main/ets/pages/Index.ets)
    * 首页支持在“照片”和“相册”两个菜单之间进行焦点切换，并通过 `phAccessHelper.getAlbums` 获取相册分类数据；
    * 通过 `phAccessHelper.getFileAssets` 获取媒体资源，再通过 `fetchFileResult.getAllObject` 读取检索结果，接口参考：[@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)；
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

4.本示例涉及部分接口需要配置系统应用签名，可以参考[特殊权限配置方法](https://gitee.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)
，把配置文件中的“apl”字段信息改为“system_core”。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/FileManagement/FileShare/Picker > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
