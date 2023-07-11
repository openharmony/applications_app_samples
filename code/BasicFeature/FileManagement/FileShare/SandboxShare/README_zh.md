# 为应用之间分享和文件访问提供统一的入口能力

### 介绍

本示例主要展示了沙箱文件分享相关的功能，使用 [@ohos.file.fileuri](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-fileuri.md) 、[@ohos.file.fs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-fs.md)、[@ohos.ability.wantConstant](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-ability-wantConstant.md)、[@ohos.application.Want](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-want.md) 等接口，实现了获取文件uri、创建沙箱文件、提供want中操作want常数和解释Flags说、应用组件间的信息传递的功能。

### 效果预览

|首页|分享界面| 分享至picker后的编辑界面            |
|--------------------------------|--------------------------------|--------------------------------|
|![](./screenshots/device/index.jpg)|![](./screenshots/device/share.jpg)|![](./screenshots/device/edit.jpg)|

使用说明：

1. 因本应用的功能依赖Picker应用，在使用本应用之前首先应安装[Picker](code/BasicFeature/FileManagement/FileShare/Picker)应用;
2. 在主界面，可以点击沙箱文件夹列出文件夹中的文件，同时也可以直接点击沙箱目录下的文件进入文件分享界面；
3. 点击沙箱文件，进入文件分享界面，点击分享图标，文件将以picker方式打开文件，点击编辑图标，文件进入可编辑模式，在textArea中输入内容，然后点击保存，文件内容更新，返回沙箱应用首页，文件修改成功。

### 工程目录
```
entry/src/main/ets/
|---Application
|---Common
|   |---Common.ts                      // 公共方法
|	|---Utils.ts	
|   |---Logger.ts                      // 日志工具
|---MainAbility
|   |---EntryAbility.ts                // Ability类
|---fileFs
|   |---fileFs.ts                      // 创建沙箱文件
|---pages
|   |---Index.ets                      // 首页
|   |---Show.ets                       // 文件分享页面
```
### 具体实现

* 增添文件、查找指定类型文件、获取文件uri、传递want信息启动ability的功能接口封装在fileFs.ts，源码参考：[fileFs.ts](src/main/ets/fileFs/fileFs.ts)

  * 使用fs.mkdirSync、fs.openSync、fs.writeSync、fs.readSync、fs.closeSync分别用来来创建文件夹、打开文件、写文件、读文件、关闭文件，接口参考：[@ohos.file.fs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-fs.md)

  * 使用fileUri.getUriFromPath来获取文件uri，接口参考：[@ohos.file.fileuri](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-fileuri.md) 

  * 分享文件至picker应用打开并编辑：在分享页面[show.ets](src/main/ets/pages/Show.ets)

    调用 implicitStartAbility 方法传递want参数启动新的ability，接口参考：[@ohos.ability.wantConstant](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-ability-wantConstant.md)、[@ohos.application.Want](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-want.md) 


### 相关权限

| 权限名                                     | 权限说明                                 | 级别         |
| ------------------------------------------ | ---------------------------------------- | ------------ |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED | 允许查询应用的基本信息和其他敏感信息。   | system_basic |
| ohos.permission.MEDIA_LOCATION             | 允许应用访问用户媒体文件中的地理位置信息 | normal       |
| ohos.permission.READ_MEDIA                 | 允许应用读取用户外部存储中的媒体文件信息 | normal       |
| ohos.permission.WRITE_MEDIA                | 允许应用读写用户外部存储中的媒体文件信息 | normal       |

### 依赖

本应用需要依赖[Picker](code/BasicFeature/FileManagement/FileShare/Picker)应用，沙箱文件需分享至Picker应用打开并编辑保存

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568;

2.本示例为Stage模型，仅支持API9版本SDK，版本号：3.2.12.2，镜像版本号：OpenHarmony 4.0.9.1。

3.本示例需要使用DevEco Studio 3.1 Release (Build Version: 3.1.0.500, built on April 28, 2023)及以上版本才可编译运行。

4.本示例涉及部分接口需要配置系统应用签名，可以参考[特殊权限配置方法](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/) ，把配置文件中的“apl”字段信息改为“system_basic”。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/FileManagement/FileShare/SandboxShare > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```
