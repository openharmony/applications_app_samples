# ArkUI使用形状裁剪（clipShape）指南文档示例

### 介绍


本示例通过使用[ArkUI指南文档](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1.[线性布局 (Column)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-layout-development-linear.md)。
2.[图片](https://developer.huawei.com/consumer/cn/doc/atomic-ascf/components-image)
3.[形状裁剪](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-clip-shape)

### 效果预览



| 裁剪圆形                                 | 裁剪椭圆形                            | 裁剪矩形                           | 裁剪不规则形状                          |
|------------------------------------|------------------------------------|------------------------------------|------------------------------------|
| ![image1](E:\dosc_smaplte\applications_app_samples_lbf\code\DocsSample\ArkUISample\ClipShape\entry\src\screenshots\device\image1.jpeg) | ![image1](E:\dosc_smaplte\applications_app_samples_lbf\code\DocsSample\ArkUISample\ClipShape\entry\src\screenshots\device\image2.jpeg) | ![image1](E:\dosc_smaplte\applications_app_samples_lbf\code\DocsSample\ArkUISample\ClipShape\entry\src\screenshots\device\image3.jpeg) |![image1](E:\dosc_smaplte\applications_app_samples_lbf\code\DocsSample\ArkUISample\ClipShape\entry\src\screenshots\device\image4.jpeg)



```
ClipShape
├─ AppScope
│  ├─ app.json5
│  └─ resources
│     └─ base
│        ├─ element
│        │  └─ string.json
│        └─ media
│           ├─ background.png
│           ├─ foreground.png
│           └─ layered_image.json
├─ code-linter.json5
├─ entry
│  ├─ hvigorfile.ts
│  ├─ obfuscation-rules.txt
│  ├─ oh-package.json5
│  └─ src
│     ├─ main
│     │  ├─ ets
│     │  │  ├─ Comm 
│     │  │  │  ├─ ClipShapeExampleA.ets          // 裁剪圆形
│     │  │  │  ├─ ClipShapeExampleB.ets          // 裁剪椭圆形
│     │  │  │  ├─ ClipShapeExampleC.ets          // 裁剪矩形
│     │  │  │  └─ ClipShapeExampleD.ets          // 裁剪不规则形状
│     │  │  ├─ entryability
│     │  │  │  └─ EntryAbility.ets
│     │  │  ├─ entrybackupability
│     │  │  │  └─ EntryBackupAbility.ets
│     │  │  └─ pages
│     │  │     └─ Index.ets
│     │  ├─ module.json5
│     │  └─ resources
│     │     ├─ base
│     │     │  ├─ element
│     │     │  │  ├─ color.json
│     │     │  │  ├─ float.json
│     │     │  │  └─ string.json
│     │     │  ├─ media
│     │     │  │  ├─ background.png
│     │     │  │  ├─ foreground.png
│     │     │  │  ├─ layered_image.json
│     │     │  │  └─ startIcon.png
│     │     │  └─ profile
│     │     │     ├─ backup_config.json
│     │     │     └─ main_pages.json
│     │     ├─ dark
│     │     │  └─ element
│     │     │     └─ color.json
│     │     └─ rawfile
│     ├─ mock
│     │  └─ mock-config.json5
│     ├─ ohosTest
│     │  ├─ ets
│     │  │  └─ test
│     │  │     ├─ Ability.test.ets
│     │  │     └─ List.test.ets
│     │  └─ module.json5
│     ├─ screenshots             // 效果截图
│     │  └─ device
│     │     ├─ image1.jpeg
│     │     ├─ image2.jpeg
│     │     ├─ image3.jpeg
│     │     └─ image4.jpeg
│     └─ test
│        ├─ List.test.ets
│        └─ LocalUnit.test.ets
├─ hvigor
│  └─ hvigor-config.json5
├─ hvigorfile.ts
├─ oh-package-lock.json5
├─ oh-package.json5
└─ README.md

```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API18版本SDK，版本号：5.1.0.56，镜像版本号：OpenHarmony_5.1.0.56。

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/DialogProject > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````