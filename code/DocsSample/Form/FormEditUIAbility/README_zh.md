# 卡片编辑开发指导-全屏编辑页

### 全屏编辑页介绍

ArkTS卡片提供卡片页面编辑能力，支持实现用户自定义卡片内容的功能，例如：编辑联系人卡片、修改卡片中展示的联系人、编辑天气卡片等。

卡片全屏编辑页布局是由应用继承UIAbility画出来的，页面布局和编辑逻辑都由应用自主决定，最后通过[updateForm](https://gitcode.com/openharmony/docs/blob/54c0b27ce55a27bf7eeb256935045ee54e932eff/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md#formProvider.updateForm)接口来达到编辑卡片的目的。

### 效果预览

| 长按编辑                                      | 一级编辑页                                       | 修改后                                            |
|-------------------------------------------|---------------------------------------------|------------------------------------------------|
| ![image](screenshot/FormUIAbility_LongPressAndEdit.png) | ![image](screenshot/FormUIAbility_edit.png) | ![image](screenshot/FormUIAbility_edit(2).png) |

使用说明

1. 用户在桌面（卡片使用方）上长按卡片，在弹出的菜单栏中点击编辑；

2. 卡片使用方识别到卡片提供方继承[FormEditExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formEditExtensionAbility.md)后，拉起卡片全屏编辑页；

3. 全屏编辑页可以编辑卡片的内容，通过updateForm接口来达到编辑卡片的目的。


### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets/
|---common
|   |---PreferencesUtil.ets                // 实现封装preference的工具类
|---entryability
|   |---EntryAbility.ets                   // 主进程UIAbility
|   |---EntryEditAbility.ets               // 全屏编辑Ability
|---entryformability
|   |---EntryFormAbility.ets               // 卡片进程Ability
|---pages
|   |---FormEditIndex.ets                  // 卡片编辑页的布局和编辑逻辑
|   |---index.ets                          // 卡片提供方主应用首页
|---widget
|   |---pages
|   |   |---WidgetCard.ets                 // 卡片页

```

### 具体实现

* 卡片编辑能力通过[FormEditExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formEditExtensionAbility.md)实现，可参考[卡片编辑开发指导](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-event-formeditextensionability.md)
  * 在ability中添加FormEditAbility，实现onCreate和onNewWant回调函数。卡片使用方会通过Want的parameters字段把被编辑的卡片ID带进来;
 * 给ExtensionEvent对象注册的接口中获取EntryFormEditAbility的[FormEditExtensionContext](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-inner-application-formEditExtensionContext.md)上下文，并调用上下文的[startSecondPage](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-inner-application-formEditExtensionContext.md#startsecondpage)方法实现卡片二级编辑页的跳转，参考[EntryFormEditAbility.ets](entry%2Fsrc%2Fmain%2Fets%2Fentryformeditability%2FEntryFormEditAbility.ets)；
  * 在一级编辑页中可通过[formProvider](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md)的[updateform](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-form-kit/js-apis-app-form-formProvider.md#formproviderupdateform-1)更新卡片，参考[FormEditExtension.ets](entry%2Fsrc%2Fmain%2Fets%2Fpages%2FFormEditExtension.ets)；

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例是否支持取决于卡片使用方的实现；
2. 本示例为Stage模型，支持API20版本及以上SDK，SDK版本号(API Version 20 Release),镜像版本号(6.0Release)；
3. 本示例需要使用DevEco Studio 版本号(6.0Release)版本才可编译运行；
4. 本示例不涉及系统接口。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code\DocsSample\Form\FormEditUIAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```