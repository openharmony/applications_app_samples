# 存储空间统计（仅对系统应用开放）

### 介绍

本示例通过应用程序包管理、应用空间统计与卷管理模块，实现了查看当前设备存储空间信息、所有安装的应用的存储信息、所有可用卷的存储信息的功能。

### 效果预览

| 存储空间统计                          | 应用存储信息                                            | 可用卷信息                    |
|---------------------------------|---------------------------------------------------|--------------------------|
| ![](./screenshots/device/main_page_zh.png) | ![](./screenshots/device/application_page_zh.png) | ![](./screenshots/device/volume_page_zh.png) |

使用说明：

1. 主页面会展示当前设备存储使用的详细信息。

2. 点击“应用”，可以查看当前安装的所有应用的存储使用情况。

3. 当有可用的卷时，点击“查看可用卷信息”查看当前设备所有的可用卷的存储使用情况。

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts
|---common
|   |---ParseData.ets                         // 数据
|   |---QueryStorageData.ets                  // 空间
|   |---QueryVolumeData.ets                   // 可用卷
|   |---TitleBar.ets                          // 标题
|---MainAbility
|   |---MainAbility.ts
|---model
|   |---AppData.ets                           // 应用数据
|   |---StorageData.ets                       // 存储空间
|   |---VolumeData.ets                        // 可用卷使用
|---pages
|   |---AppInfo.ets                           // 应用详情
|   |---MainPage.ets                          // 主页
|   |---StorageList.ets                       // 空间列表
|   |---VolumeList.ets                        // 可用卷列表
|---utils
|   |---CheckEmptyUtils.ets                   // 判空方法
|   |---Logger.ts                             // 日志工具
|   |---StorageConst.ets                      
```
### 具体实现

* 本示例使用DataPanel组件展示不同种类的应用存储信息，通过 Bundle模块来获取不同应用的包名与应用名等信息，使用应用空间统计来查询当前设备的存储使用情况，使用卷管理来查询可用卷存储使用情况。
* 源码链接：[QueryStorageData.ets](entry/src/main/ets/common/QueryStorageData.ets)，[QueryVolumeData.ets](entry/src/main/ets/common/QueryVolumeData.ets)
* 接口参考：[DataPanel组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-datapanel.md)，[@ohos.bundle.bundleManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-Bundle.md)，[@ohos.file.storageStatistics](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-storage-statistics.md)，[@ohos.file.volumeManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-volumemanager.md)

### 相关权限

1. 允许获取存储信息与可用卷信息：[ohos.permission.STORAGE_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionstorage_manager)

2. 允许获取已安装应用的信息：[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionget_bundle_info_privileged)

3. 允许应用读取已安装应用列表：[ohos.permission.GET_INSTALLED_BUNDLE_LIST](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionget_installed_bundle_list)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例为Stage模型，已适配API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

3. 本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

4. 本示例需要使用@ohos.bundle.innerBundleManager，@ohos.volumeManager，@ohos.storageStatistics系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEcoStudio中替换，具体操作可参考 [替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/) 。

5. 本示例使用了system_core级别的权限（相关权限级别请查看[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md) ），需要手动配置高级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/) ) 。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/DEviceManagement/StorageStatistic/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```
