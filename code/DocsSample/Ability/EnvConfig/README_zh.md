# 获取/设置环境变量

### 介绍

环境变量涵盖了所有可能影响应用运行时的环境配置信息，包括应用可指定的内部环境变量（字体大小、外观、语言等）和应用可感知的外部环境变量（屏幕方向等）。环境变量的操作主要包含获取环境变量和设置环境变量两种方式，详情可参考 [获取/设置环境变量](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/subscribe-system-environment-variable-changes.md) 文档。具体如下：
1. 获取环境变量
   开发者通过使用getConfigurationSync主动获取当前环境变量，包括深浅色模式、屏幕方向、语言地区、屏幕密度、设备类型等，对应用程序作出相应处理，提供更好的用户体验。
2. 设置环境变量
   设置环境变量主要包含 设置字体大小、设置深浅色模式、设置应用语言。通过setFontSizeScale设置应用字体大小、使用setColorMode设置应用和UIAbility的深浅模式、使用setLanguage设置应用语言。

### 效果预览

不涉及。

### 使用说明

1. 功能入口：启动应用后，通过首页（Index.ets）可进入环境变量管理、应用异常退出原因查询、应用间跳转等功能模块。
2. 环境变量获取操作：
   在首页触发 “获取环境变量” 功能，系统通过 Want 拉起EnvAbility0.ets元能力。
   元能力执行getConfigurationSync接口获取配置，可通过日志输出或页面展示结果。
3. 环境变量设置操作：
   进入 “设置环境变量” 模块，系统拉起EnvAbility6.ets或EnvAbility7.ets元能力，并加载对应页面（EnvAbility6Page.ets/EnvAbility7Page.ets）。
   在设置页面通过开关、滑块等控件修改字体大小、深浅色模式等，操作后配置即时生效。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── EnvAbility                      // 获取/设置环境变量
 │   │   ├── MyAbility                       // 获取应用异常退出原因
 │   │       ├── MyAbility1.ets            
 │   │       ├── MyAbility2.ets
 │   │   ├── OpenApp                         // 应用间跳转
 │   │       ├── OpenAppAbility1.ets            
 │   │   ├── pages
 │   │       ├── EnvAbilityPage6.ets         // 设置环境变量页面对应其元能力EnvAbility6
 │   │       ├── EnvAbilityPage7.ets         // 设置环境变量页面对应其元能力EnvAbility7
 │   │       ├── Index.ets                   // 首页
 │   │       ├── OpenAppPage.ets             // 应用间跳转页面
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

* 核心实现逻辑框架
   * 环境变量管理采用 “Want 拉起元能力→元能力加载对应页面” 的流程，核心分为获取与设置两大模块，各模块对应明确的元能力与页面文件。 
* 环境变量获取实现：
   * 通过getConfigurationSync接口获取系统与应用的环境配置。源码参考：[EnvAbility0.ets](./entry/src/main/ets/EnvAbility/EnvAbility0.ets)
* 环境变量设置实现：
   * 设置字体大小：通过函数setFontSizeScale设置字体大小。源码参考：[EnvAbility1.ets](./entry/src/main/ets/EnvAbility/EnvAbility1.ets)
   * 设置深浅色模式：通过函数setColorMode设置深浅色模式。源码参考：[EnvAbility2.ets](./entry/src/main/ets/EnvAbility/EnvAbility2.ets)
   * 设置应用语言：通过函数setLanguage设置应用语言。源码参考：[EnvAbility5.ets](./entry/src/main/ets/EnvAbility/EnvAbility5.ets)
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
echo code/DocsSample/Ability/EnvConfig > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
