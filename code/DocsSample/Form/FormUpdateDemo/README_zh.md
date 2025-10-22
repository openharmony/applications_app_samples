# 卡片使用方主动刷新卡片内容（仅对系统应用开放）

## 介绍

本工程主要实现了对以下指南文档中 [卡片使用方主动刷新卡片内容（仅对系统应用开放）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-active-refresh.md#%E5%8D%A1%E7%89%87%E4%BD%BF%E7%94%A8%E6%96%B9%E4%B8%BB%E5%8A%A8%E5%88%B7%E6%96%B0%E5%8D%A1%E7%89%87%E5%86%85%E5%AE%B9%E4%BB%85%E5%AF%B9%E7%B3%BB%E7%BB%9F%E5%BA%94%E7%94%A8%E5%BC%80%E6%94%BE) 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。


## 相关概念

由于定时、定点刷新存在时间限制，卡片使用方可以通过调用[requestForm](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formHost-sys.md#requestform)接口向卡片管理服务请求主动触发卡片的刷新。
卡片管理服务触发卡片提供方FormExtensionAbility中的[onUpdateForm](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formExtensionAbility.md#formextensionabilityonupdateform)生命周期回调，回调中可以使用[updateForm](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md#formproviderupdateform)接口刷新卡片内容。

## 效果预览

| 卡片未更新状态                                 | 卡片更新状态                                    |
|-----------------------------------------|-------------------------------------------|
| ![image](./screenshots/formupdate1.png) | ![image](./screenshots/formupdate2.png) |

## 使用说明

1. 应用启动后会通过FormComponent组件自动添加卡片，并且获取formId

2. 点击更新卡片按钮，会通过formHost提供的requestForm（仅支持系统应用使用）接口请求更新卡片，卡片管理服务会进而通知卡片提供方完成卡片更新。


## 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets                   // 主进程UIAbility
|---entryformability
|   |---EntryFormAbility.ets               // 卡片进程Ability
|---pages
|   |---index.ets                          // 卡片使用方页面
|---widget
|   |---pages
|   |   |---WidgetCard.ets                 // 卡片页
```

## 具体实现

* 卡片组件
  * 使用卡片组件FormComponent （系统能力：SystemCapability.ArkUI.ArkUI.Full），展示卡片提供方提供的卡片内容。
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 参考：[FromComponent组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-formcomponent-sys.md)

* formHost接口
  * 使用formHost接口（系统能力：SystemCapability.Ability.Form），对使用方同一用户下安装的卡片进行删除、更新、获取卡片信息、状态等操作。
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 接口参考：[@ohos.app.form.formHost](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formHost-sys.md)


## 依赖

卡片提供方 [FormProvider](../FormProvider/)

## 相关权限

| 权限名                                     | 权限说明                                         | 级别         |
| ------------------------------------------ | ------------------------------------------------ | ------------ |
| [ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/security/permission-list.md#ohospermissiongetbundleinfoprivileged) | 允许应用查询其他应用的信息。                     | system_basic |
| [ohos.permission.LISTEN_BUNDLE_CHANGE](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/security/permission-list.md#ohospermissionlistenbundlechange)      | 允许应用监听其他应用安装、更新、卸载状态的变化。 | system_basic |
| [ohos.permission.REQUIRE_FORM](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/security/permission-list.md#ohospermissionrequireform)               | 允许应用获取Ability Form。                       | system_basic |
| [ohos.permission.OBSERVE_FORM_RUNNING](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/security/permission-list.md#ohospermissionobserveformrunning)       | 允许应用监听卡片运行状态                      | system_basic |

## 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568；
2. 本示例支持API20版本SDK，版本号：6.0.0.55；
3. 本示例已支持使DevEco Studio 6.0.0 Release编译运行；
4. 本示例需要使用系统权限的系统接口，需要使用Full SDK编译。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)；
5. 本示例所配置的权限为system_basic或system_core级别(权限级别请参考[权限定义列表](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md))，需要配置对应级别的权限签名(可查看[自动化签名方案](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/hapsigntool-overview.md))；
6. 本示例类型为系统应用，需要手动配置对应级别的应用类型("app-feature": "hos_system_app")。具体可参考profile配置文件[bundle-info对象内部结构]( https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/app-provision-structure.md#bundle-info%E5%AF%B9%E8%B1%A1%E5%86%85%E9%83%A8%E7%BB%93%E6%9E%84 )；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/Form/FormUpdateDemo/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
