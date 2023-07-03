# 数据代理卡片（数据库刷新）

### 介绍

本示例主要展示了数据代理卡片的功能，使用[@ohos.application.DataShareExtensionAbility](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-application-dataShareExtensionAbility.md)、[@ohos.data.dataShare](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-dataShare.md)、[@ohos.data.dataSharePredicates](ohos.data.dataSharePredicates)等接口，实现了修改卡片订阅信息后，当rdb数据库中的数据发生变化时，卡片中对应信息也发生相应变化的功能。

### 效果预览

| 应用主界面 | 修改订阅条件 | 发布数据                                          | 卡片样式                                      |
| ------- | ------- | ------- | ------- |
| ![mainInterface](./screenshots/zh/mainInterface.jpeg) | ![modifySubscriptionConditions](./screenshots/zh/modifySubscriptionConditions.jpeg) | ![dataRelease](./screenshots/zh/dataRelease.jpeg) | ![cardStyle](./screenshots/zh/cardStyle.jpeg) |

使用说明

1.长按应用图标弹出菜单，点击"服务卡片"选项可以添加服务卡片至桌面；

2.长按数据卡片弹出菜单，点击"移除"可以将已添加至桌面的数据卡片从桌面上移除；

3.点击"修改订阅条件"按键，界面将跳转至修改订阅条件界面，对应选择想要发布的数据完成对订阅条件的修改；

4.在应用中点击"发布数据"按键，界面将跳转至数据发布界面，对应选择想要发布的数据并点击"发布数据"完成数据发布；

### 工程目录

```
entry/src/main/
|---common
|  └---Logger.ts
|---ets
|  └---dataShare
|  | └---dataShare.ts
|  |---entryability
|  |  └---EntryAbility.ts
|  |---entryformability
|  |  └---EntryFormAbility.ts
|  |---pages
|  |  |---Index.ets                          // EntryAbility页面
|  |  |---IndexSec.ets                       // 发布数据页面
|  |  └---IndexThi.ets                       // 修改订阅条件页面
|  └---widget
|     └---pages
|        └---WidgetCard.ets                  // ArkTS卡片
|---js
|  |---common
|  |---i18n
|  └---widgetJS
|     └---pages
|        └---index
|           |---index.css                       // JS卡片样式
|           |---index.hml                       // JS卡片
|           └---index.json                      // JS卡片默认值
|---resources                                   // 资源信息
```

### 具体实现

- 修改数据卡片的订阅条件的功能封装在IndexThi中，源码参考：[IndexThi.ets](./entry/src/main/ets/pages/IndexThi.ets)。
  - 使用modifyCondition来获取所有已经建立出的卡片对象。
  - 修改订阅条件：使用updateCardDisplayContent遍历所有卡片对象，并根据界面获取的订阅条件数据修改订阅条件。
- 发布数据的功能封装在IndexSec中，源码参考：[IndexSec.ets](./entry/src/main/ets/pages/IndexSec.ets)。
  - 使用updateRDB来修改rdb数据库中的对应数据。
- 在dataShare模块中，建立rdb数据库，并提供对应update方法。
  - 在onCreate中初始化数据库中的数据。
  - 在update中实现对应的数据更新方法。

###  相关权限

[ohos.permission.START_ABILITIES_FROM_BACKGROUND](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.START_INVISIBLE_ABILITY](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.GET_BUNDLE_INFO](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.REQUIRE_FORM](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/permission-list.md)

### 依赖

本测试demo需要安装在仿桌面应用上进行测试。launcher应用地址：[Launcher](../../../Launcher)

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 10版本SDK，版本号：4.0.8.5。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)才可编译运行。

4.本示需要使用Full SDK编译。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南]( https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/ )。

5.本示例所配置的权限为system_core级别(相关权限级别可通过[权限定义列表]( https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md )查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/))。

6.本示例中使用到DataShareExtensionAbility，需要将本实例加入到白名单中再进行安装。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/ApplicationModels/PersistentProxyForm > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```