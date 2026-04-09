# 图库项目

### 介绍

应用使用[@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
等接口，实现了系统相册图片查看、相册分类和删除的功能。

使用说明：

1. 在首页，有照片相册两个菜单，焦点在相册上面，左右可以进行切换。1.照片展示所有照片和视频。2.相册包含照片、录屏截屏、视频、最近删除。
2. 焦点在照片上，确定按键点击照片可以查看照片和视频。点击视频可以播放视频，反之关闭。
3. 焦点在相册菜单上，确定按键点击照片可以查看照片和视频。点击视频可以播放视频，反之关闭。
4. 在首页，点击菜单键下方弹出菜单（分享，删除，选择），点击选择，进入编辑页面，可进行选择照片，点击分享菜单，分享图片和视频到其他设备。点击删除，删除选择之后的照片。

### 工程目录

```
entry/src/main/ets/
|---base
|	|---PhotoFileUri.ts                 //系统对接封装模块
|---common  
|	|---Constants.ts                    //枚举字符串封装
|	|---GlobalContext.ts	            //GlobalContext封装
|	|---Logger.ts                       //日志工具封装
|	|---Common.ts                       //权限字符转换封装
|	|---TraceControllerUtils.ts         //时间片跟踪模块封装
|	|---Utils.ts                        //Tip弹窗，日志封装
|	|---WifiManager.ts                  //wifi管理模块封装
|---entryability
|	|---MainAbility.ts                  //ability类
|---model
|	|---AlbumModel.ts                   //相册模型封装
|	|---FileSendModel.ts                //文件分享模型封装
|	|---IDataSource.ets                 //LazyForeach模型封装
|	|---PhotoModel.ts                   //照片模型封装
|---pages
|	|---Index.ets                       //首页（照片和相册）
|	|---PhotoList.ets                   //照片删除列表
|	|---PhotoList.ets                   //照片列表
|	|---PhotoWatch.ets                  //查看图片和视频界面
```

### 具体实现

- 获取照片列表和相册分类的功能封装在Index.ets，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 焦点默认在照片上面，左右可进行照片，相册切换 使用phAccessHelper.getAlbums来获取相册的实例，用于访问视频、图片的分类；
    * 使用使用phAccessHelper.getFileAssets来获取文件资源；使用来fetchFileResult.getAllObject获取所有文件检索结果，接口参考：[@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
    * 点击菜单键，弹出菜单功能，选择照片，使用MediaAssetChangeRequest.deleteAssets来删除文件实例。
- 照片列表的功能封装在PhotoList.ets，源码参考：[PhotoList.ets](entry/src/main/ets/pages/PhotoList.ets)
    * 使用phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype, albumFetchOptions)
      方法来进行获取照片分类。可以进行焦点切换，点击菜单键，选择照片，可进行删除操作。
- 照片列表的功能封装在PhotoDeleteList.ets，源码参考：[PhotoDeleteList.ets](entry/src/main/ets/pages/PhotoDeleteList.ets)
    * 使用phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype, albumFetchOptions)
      方法来进行获取照片分类。
- 查看图片或视频并查看的功能封装在ViewMedia.ets，源码参考：[PhotoWatch.ets](entry/src/main/ets/pages/PhotoWatch.ets)
    * 确定键点击照片可进入查看照片页面，左右键可以进行查看上下一张照片，视频页面点击确定键可进行播放视频，再次点击即可停止播放

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
