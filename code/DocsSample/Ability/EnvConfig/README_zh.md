# 获取/设置环境变量
### 介绍
1. 获取/设置环境变量
   环境变量涵盖了所有可能影响应用运行时的环境配置信息，包括应用可指定的内部环境变量（字体大小、外观、语言等）和应用可感知的外部环境变量（屏幕方向等）。
2. 获取环境变量
   开发者可以使用getConfigurationSync主动获取当前环境变量，包括深浅色模式、屏幕方向、语言地区、屏幕密度、设备类型等，对应用程序作出相应处理，提供更好的用户体验。
3. 设置环境变量
   支持应用自定义的环境变量包括字体大小、外观模式、应用语言，其余环境变量（例如屏幕方向等）不支持直接设置。
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
 │   │       ├── EnvAbility0.ets
 │   │       ├── EnvAbility1.ets
 │   │       ├── EnvAbility2.ets
 │   │       ├── EnvAbility3.ets
 │   │       ├── EnvAbility4.ets
 │   │       ├── EnvAbility5.ets
 │   │       ├── EnvAbility6.ets
 │   │       ├── EnvAbility7.ets
 │   │       ├── EnvAbility8.ets
 │   │       ├── EnvAbility9.ets
 │   │       ├── EnvAbility10.ets
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
1. 核心实现逻辑框架
   环境变量管理采用 “Want 拉起元能力→元能力加载对应页面” 的流程，核心分为获取与设置两大模块，各模块对应明确的元能力与页面文件。 
2. 环境变量获取实现（EnvAbility0.ets）
   通过getConfigurationSync接口获取系统与应用的环境配置.
   [环境变量获取实现](./entry/src/main/ets/EnvAbility/EnvAbility0.ets)
3. 环境变量设置实现（EnvAbility6Page.ets）
   通过updateConfiguration接口修改应用内部环境变量.
   [环境变量设置实现](./entry/src/main/ets/pages/EnvAbilityPage6.ets)
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
