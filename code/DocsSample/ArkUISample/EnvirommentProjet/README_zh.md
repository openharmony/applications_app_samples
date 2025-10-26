# ArkUI Environment：设备环境查询指南文档示例

### 介绍


本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1.[线性布局 (Column)](https://gitcode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-layout-development-linear.md)。
2.[文本显示 (Text/Span)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-text-display.md)

### 效果预览

![](screenshots/device/image1.jpeg)

### 具体实现
1. 基本功能与原理
   核心作用：查询设备环境信息，使应用能根据运行环境动态调整行为
   实现机制：
   Environment 是 ArkUI 框架创建的单例对象
   提供不可变的基本类型属性，反映应用运行时状态
   通过 AppStorage 访问环境变量
   主要特性：系统环境变化时自动更新，支持多种设备环境参数
2. 支持的环境参数
   colorMode：颜色模式（ColorMode.LIGHT/DARK）
   languageCode：系统语言代码（如 'zh'、'en'）
   layoutDirection：布局方向（LayoutDirectionction.LTR/RTL）
   fontScale：字体缩放比例
   fontWeightScale：字体粗细比例
   accessibilityEnabled：是否启用屏幕阅读器辅助功能
3. 使用方式与代码示例
   将环境变量存储到 AppStorage：
   Environment.envProp('languageCode', 'en');
   在 UI 中访问环境参数：
   @StorageProp('languageCode') languageCode: string = 'en';

build() {
Column() {
Text(`当前语言: ${this.languageCode}`)
}
}
在应用逻辑中使用：
const lang = AppStorage.prop('languageCode');
if (lang.get() === 'en') {
console.info('Hello!');
}

### 项目结构
```
EnvirommentProjet
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
│     │  │  ├─ entryability
│     │  │  │  └─ EntryAbility.ets
│     │  │  ├─ entrybackupability
│     │  │  │  └─ EntryBackupAbility.ets
│     │  │  └─ pages
│     │  │     └─ Index.ets          // 主页面
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
│     ├─ screenshots  // 预览截图
│     │  └─ device
│     │     └─ image1.jpeg
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

.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Canary1 (Build Version: 6.0.0.270， built on May 9, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/EnvirommentProjet > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````
