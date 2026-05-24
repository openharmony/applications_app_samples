# 卡片使用方主动刷新卡片内容（仅对系统应用开放）

## 介绍

本工程主要实现了对以下指南文档中 [卡片提供方批量请求刷新卡片内容](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-active-refresh.md#%E5%8D%A1%E7%89%87%E6%8F%90%E4%BE%9B%E6%96%B9%E6%89%B9%E9%87%8F%E8%AF%B7%E6%B1%82%E5%88%B7%E6%96%B0%E5%8D%A1%E7%89%87%E5%86%85%E5%AE%B9) 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。


## 相关概念

由于定时、定点刷新存在时间限制，卡片使用方可以通过调用[reloadForms](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md#formproviderreloadforms22)接口向卡片管理服务请求主动触发卡片批量刷新。
卡片管理服务触发卡片提供方FormExtensionAbility中的[onUpdateForm](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formExtensionAbility.md#formextensionabilityonupdateform)生命周期回调，回调中可以使用[reloadForms](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md#formproviderreloadforms22)接口批量刷新卡片内容。

## 效果预览

![image](./screenshots/批量刷新结果.gif)

## 使用说明
1. 应用启动后会通过FormComponent组件自动添加卡片，并且获取formId

2. 点击更新卡片按钮，会通过formProvider提供的reloadForms接口请求更新卡片。


## 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets                   // 主进程UIAbility
|---entryformability
|   |---EntryFormAbility.ets               // 卡片进程Ability
|---pages
|   |---index.ets                          // 卡片使用方页面
|---reloadbyuibility
|   |---pages
|   |   |---ReloadByUIAbilityCard.ets                 // 卡片页
```

## 具体实现

* formProvider接口
  * 使用formHost接口（系统能力：SystemCapability.Ability.Form），对使用方同一用户下安装的卡片进行删除、更新、获取卡片信息、状态等操作。
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 接口参考：[@ohos.app.form.formProvider](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md)


## 依赖
不涉及

## 相关权限
不涉及

## 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568；
2. 本示例支持API22版本SDK，版本号：6.0.2.55；
3. 本示例已支持使DevEco Studio 6.0.2 Beta1编译运行；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/Form/FormUpdateDemo/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
