# 服务卡片开发指导：ArkTS卡片生命周期

### 介绍

本示例展示了ArkTS卡片生命周期的卡片指导。

本示例参考[管理ArkTS卡片生命周期](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-page-animation.md)。 

#### 使用说明

1.长按FormLifecycleSta 应用图标，弹出菜单后点击**服务卡片**选项进入卡片预览界面。

2.点击下方**添加到桌面**按钮即可以将卡片添加到桌面。

### 工程目录
```
├── AppScope
│ ├── app.json5
│ └── resources
│ └── base
│ ├── element
│ │ └── string.json
│ └── media
│ ├── background.png
│ ├── foreground.png
│ └── layered_image.json
├── README_zh.md
├── build-profile.json5
├── entry
│ ├── build-profile.json5
│ ├── hvigorfile.ts
│ ├── oh-package.json5
│ ├── obfuscation-rules.txt
│ └── src
│ ├── main
│ │ ├── ets
│ │ │ ├── entryability
│ │ │ │ └── EntryAbility.ets
│ │ │ ├── entryformability
│ │ │ │ └── EntryFormAbility.ets //卡片业务逻辑模块，提供卡片创建、销毁、刷新等生命周期回调。
│ │ │ ├── pages
│ │ │ │ └── Index.ets //应用的默认页面
│ │ │ └── widget
│ │ │ ├── pages
│ │ │ │ └── WidgetCard.ets
│ │ │ ├── view
│ │ │ │ └── ControlButtonComponent.ets
│ │ │ └── viewmodel
│ │ │ └── ControlButtonParameter.ets
│ │ ├── module.json5
│ │ └── resources
│ │ ├── base
│ │ │ ├── element
│ │ │ │ ├── color.json
│ │ │ │ ├── float.json
│ │ │ │ └── string.json
│ │ │ ├── media
│ │ │ │ ├── background.png
│ │ │ │ ├── foreground.png
│ │ │ │ ├── ic_widget_main.png
│ │ │ │ ├── ic_widget_background.png
│ │ │ │ ├── ic_widget_explored.png
│ │ │ │ ├── ic_widget_mine.png
│ │ │ │ ├── ic_widget_study.png
│ │ │ │ ├── layered_image.json
│ │ │ │ └── startIcon.png
│ │ │ └── profile
│ │ │ ├── form_config.json
│ │ │ └── main_pages.json
│ │ └── dark
│ │ └── element
│ │ └── color.json
│ └── ohosTest
│ ├── ets
│ │ └── test
│ │ ├── Ability.test.ets
│ │ └── List.test.ets
│ └── module.json5
├── hvigor
│ └── hvigor-config.json5
├── hvigorfile.ts
├── oh-package.json5
├── code-linter.json5
```


### 具体实现


### 约束与限制



### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Form/FormSta/FormLifecycleSta/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
