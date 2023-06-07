# 上传

### 介绍

本示例主要展示Request服务向三方应用提供系统上传服务能力，通过[@ohos.request](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-request.md)，[@ohos.multimedia.mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md)等接口去实现图片的选取与上传。

### 效果预览

|首页                                    |添加图片                                |上传图片                                |
|---------------------------------------|-------------------------------------|-------------------------------------|
|![image](screenshots/device/Add.png) |![image](screenshots/device/Selected.png)|![image](screenshots/device/Upload.png)|

使用说明

1.安装应用前，先本地配置好服务器；

2.将[NavigationBar.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/SystemFeature/Connectivity/Upload/entry/src/main/ets/pages/NavigationBar.ets) 文件中的服务器地址替换成配置好的服务器地址；

3.启动应用，点击允许访问权限进入；

4.点击加号，出现弹出框，点击拍摄进行拍照，点击从图库选择进行选取照片；

5.点击发表，图片会进行上传，上传成功后会有弹窗提示。

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts
|---MainAbility
|   |---MainAbility.ts
|---componets
|   |---AddPictures.ets                     // 添加图片
|   |---DownloadController.ets              // 下载
|   |---NavigationBar.ets                   // 切换
|   |---RequestBar.ets                      // 请求
|   |---SelectDialog.ets                    // 选择弹窗
|   |---ServiceConfigDialog.ets             // 服务
|   |---UploadController.ets                // 上传
|---config
|   |---config.ets                         
|---download
|   |---pages                          
|   |   |---Download.ets                    // 下载     
|---feature
|   |---CameraService.ts                    // 相册服务
|   |---CostTimeCompute.ets                 // 时间计算
|   |---DateTimeUtil.ts                     // 时间
|   |---GetPictures.ets                     // 获取相册
|   |---MediaUtils.ets                      // 媒体
|   |---UploadFile.ets                      // 文件上传
|---pages
|   |---Index.ets                           // 首页
|---upload
|   |---pages                          
|   |   |---CameraPage.ets                  // 相机          
|   |   |---Upload.ets                      // 上传      
|---util
|   |---ConfigUtil.ets                           
|   |---Logger.ts                           // 日志工具
|   |---Style.ts                            
```
### 具体实现

* 该示例通过camera接口实现相机管理，image接口提供图片处理效果，mediaLibrary接口实现媒体库管理，fileio接口提供文件存储管理能力request接口给应用提供上传下载文件的基础能力等去实现图片的选取与上传。
* 源码链接：[CameraService.ts](code/SystemFeature/Connectivity/Upload/entry/src/main/ets/feature/CameraService.ts)，[MediaUtils.ts](code/SystemFeature/Connectivity/Upload/entry/src/main/ets/feature/MediaUtils.ts)，[DownloadController.ets](code/SystemFeature/Connectivity/Upload/entry/src/main/ets/componets/DownloadController.ets)
* 接口参考：[@ohos.multimedia.camera](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-camera.md)，[@ohos.multimedia.image](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-image.md)，[@ohos.multimedia.mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md)，[@ohos.fileio](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-fileio.md)，[@ohos.request](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-system-request.md)

### 相关权限

本示例需要在module.json5中配置如下权限:

1.允许应用读取用户外部存储中的媒体文件信息权限：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

2.允许应用使用相机拍摄照片和录制视频权限：[ohos.permission.CAMERA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

3.允许应用读写用户外部存储中的媒体文件信息权限：[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

4.允许使用Internet网络权限：[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备:RK3568；

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9；

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行；

4.本示例需要使用系统权限的接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/Connectivity/Upload/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```