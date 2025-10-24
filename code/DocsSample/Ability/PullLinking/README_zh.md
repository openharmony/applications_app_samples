# 应用间跳转
### 介绍
应用间跳转是 OpenHarmony 系统中实现跨应用协作的核心能力，支持从当前应用（调用方）拉起目标应用（被调用方），并可伴随数据传递、指定页面唤起、特定功能触发等场景。本工程聚焦应用间跳转的核心实现方案，覆盖兼容性判断、主流跳转方式、版本适配规范及配置说明，为开发者提供标准化的跨应用交互开发参考。​
本工程主要包含四大核心内容：
  1. 应用可访问性预检（canOpenLink）：
    调用方应用在发起跳转前，通过canOpenLink接口预先检测目标应用是否已安装、且其配置的链接协议可被系统识别，避免因目标应用缺失导致的跳转失败，提升交互稳定性。​
  2. Deep Linking 跳转实现：
    基于统一资源标识符（URI）的跳转方案，调用方通过openLink接口传入目标应用的 URI，系统自动扫描本地已安装应用，匹配与 URI 协议匹配的应用并拉起；若存在多个匹配应用，将弹出应用选择弹窗供用户决策。
  3. 显式 Want 跳转版本适配：
    针对系统版本迭代的适配指导：自 API 12 开始，系统不再推荐第三方应用基于 “指定 Ability 名称” 的显式 Want 方式拉起目标应用，强制要求采用 “基于 URI 协议的应用链接” 方式实现跳转，以提升应用间交互的规范性和兼容性。
  4. 应用链接（URI）配置说明：
    被调用方应用需在配置文件module.json5的skills字段中声明uris信息，明确自身可被唤起的协议规则，核心配置字段包括schem（协议名）、host（主机名）、port（端口）、path（路径）、linkFeature（链接功能标识）等。
### 效果预览
不涉及。
### 使用说明

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
1. 应用间跳转:
   首先使用canOpenLink判断应用是否可访问，然后通过App Linking 和 Deep Linking以及显式Want三种方式实现应用跳转。
   其中App Linking 和 Deep Linking主要是通过openLink函数来实现。
2. 核心配置（被调用方）：module.json5 中 uris 声明，被调用方需在module.json5的skills字段中配置可被唤起的链接协议。
   [核心配置（被调用方）](./entry/src/main/module.json5)
3. 应用间跳转完整流程（调用方）:
   步骤 1：应用可访问性预检（canOpenLink）在触发跳转前，通过canOpenLink接口检测目标应用是否可访问。
   步骤 2：执行跳转（三种方式实现）
      方式 1：Deep Linking 跳转（推荐，API 12 + 适配），通过openLink接口传入 URI，实现跨应用跳转。
      方式 2：App Linking 跳转（与 Deep Linking 共用 openLink，适用于云链接场景），App Linking 支持通过云端链接拉起应用，若应用未安装可引导至应用市场。
      方式 3：显式 Want 跳转（API 12 前兼容，不推荐使用），通过指定目标 Ability 名称拉起应用，API 12 及以上版本可能失效。
   步骤 3：被调用方接收跳转参数（OpenAppAbility1.ets） 被唤起时，可在 Ability 的onCreate或onNewWant生命周期中接收调用方传递的参数。
   [调用方接收](./entry/src/main/ets/OpenApp/OpenAppAbility1.ets)
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
