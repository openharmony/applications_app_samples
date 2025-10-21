# ArkUI使用@ReusableV2装饰器：组件复用指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/ui/state-management/arkts-basic-syntax-overview.md)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

### 1.[线性容器(Column)](https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-column.md)

### 2.[文本显示器(Text)](https://docs.openharmony.cn/pages/v5.1/en/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-text.md)

### 3.[Button](https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-button.md)

## 预览效果

![image1](E:\ReusableV2\screenshots\device\image1.jpeg)

![imag3](E:\ReusableV2\screenshots\device\imag3.jpeg)

![imag3](E:\ReusableV2\screenshots\device\imag3.jpeg)

![image2](E:\ReusableV2\screenshots\device\image2.jpeg)

![image4](E:\ReusableV2\screenshots\device\image4.jpeg)




## 使用说明

### 1.在进入主页面后，点击页面按钮进行查看

## 工程目录结构


```
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
│     │  │  ├─ common      // 复用组件
│     │  │  │  ├─ NormalV2Component.ets
│     │  │  │  ├─ ReusableV2Component.ets
│     │  │  │  ├─ ReusableV2Component1.ets
│     │  │  │  ├─ ReusableV2Component2.ets
│     │  │  │  ├─ ReusableV2Component3.ets
│     │  │  │  ├─ ReusableV2Component4.ets
│     │  │  │  ├─ ReusableV2Component5.ets
│     │  │  │  ├─ ReusableV2Component6.ets
│     │  │  │  ├─ ReusableV2Component7.ets
│     │  │  │  ├─ ReusableV2Component8.ets
│     │  │  │  └─ ReusableV2Component9.ets
│     │  │  ├─ entryability
│     │  │  │  └─ EntryAbility.ets
│     │  │  ├─ entrybackupability
│     │  │  │  └─ EntryBackupAbility.ets
│     │  │  ├─ pages
│     │  │  │  └─ Index.ets   // 主页面
│     │  │  └─ view
│     │  │     ├─ Page1.ets
│     │  │     ├─ Page10.ets
│     │  │     ├─ Page11.ets
│     │  │     ├─ Page12.ets
│     │  │     ├─ Page13.ets
│     │  │     ├─ Page2.ets
│     │  │     ├─ Page3.ets
│     │  │     ├─ Page4.ets
│     │  │     ├─ Page5.ets
│     │  │     ├─ Page6.ets
│     │  │     ├─ Page7.ets
│     │  │     ├─ Page8.ets
│     │  │     └─ Page9.ets
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
│     │  │     ├─ index.test.ets
│     │  │     └─ List.test.ets
│     │  └─ module.json5
│     └─ test
│        ├─ List.test.ets
│        └─ LocalUnit.test.ets
├─ hvigor
│  └─ hvigor-config.json5
├─ hvigorfile.ts
├─ oh-package-lock.json5
├─ oh-package.json5
├─ README_zh.md
└─ screenshots  // 预览图片
   └─ device
      ├─ image1.png
      ├─ image2.png
      └─ image3.png

```

`````
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API18版本full-SDK，版本号：5.1.0.107，镜像版本号：OpenHarmony_5.1.0 Release。

3.本示例需要使用DevEco Studio 5.0.5 Release (Build Version: 5.0.13.200， built on May 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/ScrollableComponent > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````
`````