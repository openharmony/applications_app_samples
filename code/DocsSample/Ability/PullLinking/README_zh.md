# 应用间跳转

### 介绍

* 应用间跳转概述：
   应用跳转是指从一个应用跳转至另外一个应用，传递相应的数据、执行特定的功能。通过应用跳转可以满足用户更为真实丰富的场景诉求、提升交互体验的便捷性和流畅性。
* 应用场景：
   应用间跳转在社交分享、推广营销等场景广泛使用。举例如下：
  * 社交分享： 在社交软件中分享位置链接、美食推荐链接、购物链接、游戏链接等，可以通过该链接快速跳转到匹配的导航App、美食App、购物App、游戏App等应用。
  * 推广营销： 在视频类App、社交类App、浏览器App等广告投放平台中，嵌入需要推广的应用链接（该链接可能以文本、卡片、视频等形式呈现），通过该链接信息可以跳转到目标应用的指定页面；也可以在推送短信、发送邮件时，在正文中携带需要推广的应用链接，通过该链接信息可以跳转到目标应用的指定页面。
* 应用跳转的两种类型：
  * 拉起指定应用：拉起方应用明确指定跳转的目标应用，来实现应用跳转。指向性跳转可以分为指定应用链接、指定Ability两种方式。 说明:（从API 12开始，已不再推荐三方应用使用指定Ability方式（即显式Want）拉起其他应用。关于如何从指定Ability方式切换到指定应用链接方式，详见显式Want跳转切换应用链接跳转适配指导)
    * 指定应用链接（推荐）：通过openLink或startAbility接口来指定应用链接，拉起目标应用页面。
    * 指定Ability（不推荐）：通过startAbility接口指定具体的Ability（即显式Want方式），拉起目标应用页面。
  * 拉起指定类型的应用：拉起方应用通过指定应用类型，拉起垂类应用面板。该面板将展示目标方接入的垂域应用，由用户选择打开指定应用。

### 效果预览

不涉及。

### 使用说明

1. 前期准备：
   准备两个应用（调用方和目标应用），或在同一工程中通过多 Ability 模拟跨应用场景。
2. 操作步骤：
   调用方应用：在页面中触发跳转逻辑（如点击按钮），分别通过openLink和startAbility以及web组件的window.open三种方式接口传入目标应用链接。
   目标应用：配置module.json5以支持该链接，并在 Ability 中处理链接解析与页面导航。
   测试场景：分别在 “目标应用已安装” 和 “未安装” 两种状态下验证跳转效果。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── OpenApp                         // 应用间跳转
 │   │       ├── OpenAppAbility1.ets            
 │   │   ├── pages
 │   │       ├── Index.ets                   // 首页
 │   │       ├── OpenAppPage1.ets             // 应用间跳转页面
 │   │       ├── OpenAppPage2.ets             // 应用间跳转页面
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```

### 具体实现

* 应用间跳转:
    * 首先使用canOpenLink判断应用是否可访问，然后通过App Linking 和 Deep Linking以及显式Want三种方式实现应用跳转。
    * 其中App Linking 和 Deep Linking主要是通过openLink函数来实现。
* 核心配置（被调用方）：module.json5 中 uris 声明，被调用方需在module.json5的skills字段中配置可被唤起的链接协议。
    * 被调方配置参考：[module.json5](./entry/src/main/module.json5)
* 应用间跳转完整流程（调用方）:
    * 步骤 1：应用可访问性预检（canOpenLink）在触发跳转前，通过canOpenLink接口检测目标应用是否可访问。
    * 步骤 2：执行跳转（三种方式实现）
        方式 1：Deep Linking 跳转（推荐，API 12 + 适配），通过openLink接口传入 URI，实现跨应用跳转。
        方式 2：App Linking 跳转（与 Deep Linking 共用 openLink，适用于云链接场景），App Linking 支持通过云端链接拉起应用，若应用未安装可引导至应用市场。
        方式 3：显式 Want 跳转（API 12 前兼容，不推荐使用），通过指定目标 Ability 名称拉起应用，API 12 及以上版本可能失效。
    * 步骤 3：被调用方接收跳转参数（OpenAppAbility1.ets） 被唤起时，可在 Ability 的onCreate或onNewWant生命周期中接收调用方传递的参数。调用方接收源码参考：[OpenAppAbility1.ets](./entry/src/main/ets/OpenApp/OpenAppAbility1.ets)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备：RK3568。
2. 本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。
3. 本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/PullLinking > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
