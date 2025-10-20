# 服务卡片开发指导：独立卡片包

### 介绍

此Sample为开发指南中**服务卡片开发指导（Stage模型）**章节中**开发卡片页面**一小节示例代码的完整工程。

[独立卡片页面配置](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-configuration.md)
[卡片使用动效能力](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-page-animation.md)

### 效果预览
| 动效卡片                                                                          |
|-------------------------------------------------------------------------------|
| ![TransitionEffectExample1](./screenshots/device/TransitionEffectExample.png) |

使用说明：

1.长按FormStandaloneDemo 应用图标，弹出菜单后点击**服务卡片**选项进入卡片预览界面。

2.卡片预览界面默认显示一张动效卡片。

3.点击下方**添加到桌面**按钮即可以将卡片添加到桌面。


### 工程目录
```shell
├── AppScope
│   ├── app.json5
│   └── resources
│       └── base
│           ├── element
│           │   └── string.json
│           └── media
│               └── app_icon.png
├── README_zh.md
├── build-profile.json5
├── entry
│   ├── build-profile.json5
│   ├── hvigorfile.ts
│   ├── oh-package.json5
│   └── src
│       ├── main
│       │   ├── ets
│       │   │   ├── entryability
│       │   │   │   └── EntryAbility.ts
│       │   │   ├── entryformability
│       │   │   │   └── EntryFormAbility.ts
│       │   │   ├── pages
│       │   │   │   └── Index.ets
│       │   ├── module.json5
│       │   └── resources
│       │       ├── base
│       │       │   ├── element
│       │       │   │   ├── color.json
│       │       │   │   ├── float.json
│       │       │   │   └── string.json
│       │       │   ├── media
│       │       │   │   └── icon.png
│       │       │   └── profile
│       │       │       ├── form_config.json
│       │       │       └── main_pages.json
│       │       ├── en_US
│       │       │   └── element
│       │       │       └── string.json
│       │       ├── rawfile
│       │       └── zh_CN
│       │           └── element
│       │               └── string.json
│       └── ohosTest
│           ├── ets
│           │   ├── test
│           │   │   ├── Ability.test.ets     // UI自动化用例
│           │   │   └── List.test.ets
│           └── module.json5
├── library
│   ├── build-profile.json5
│   ├── hvigorfile.ts
│   ├── oh-package.json5
│   ├── Index.ets
│   └── src
│       ├── main
│       │   ├── ets
│       │   │   └── widget
│       │   │   │   └── TransitionEffectExample1.ets
│       │   ├── module.json5
│       │   └── resources
│       │       └── base
│       │           ├── element
│       │           │   ├── color.json
│       │           │   ├── float.json
│       │           │   └── string.json
│       │           ├── media
│       │           │   └── testImg.png
│       │           └── profile
│       │               └── form_config.json
│       │       
│       └── ohosTest
│           ├── ets
│           │  └── module.json5
│           └── test
│               ├── List.test.ets
│               └── LocalUnit.test.ets
├── hvigor
│   ├── hvigor-config.json5
│   └── hvigor-wrapper.js
├── hvigorfile.ts
├── hvigorw
├── hvigorw.bat
├── oh-package.json5
├── ohosTest.md
└── screenshots
    └── device
        └── TransitionEffectExample.png     // 动效卡片效果图
```

### 具体实现

可参考服务卡片开发指南如下三个章节：

[卡片页面能力说明](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-page-overview.md)

[卡片使用动效能力](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-page-animation.md)

[卡片使用自定义绘制能力](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-page-custom-drawing.md)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API14版本SDK，版本号：5.0.2.57；

3.  本示例已支持使DevEco Studio 5.0.1 Release (构建版本：5.0.5.306，构建 2024年12月12日)编译运行；

4.  高等级APL特殊签名说明：无；

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/DocsSample/Form/ArkTSCardDocsSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
