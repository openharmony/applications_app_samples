# 应用间跳转
### 介绍
使用App Linking实现应用间跳转
   使用App Linking进行跳转时，系统会根据接口传入的uri信息（HTTPS链接）将用户引导至目标应用中的特定内容，无论应用是否已安装，用户都可以访问到链接对应的内容，跳转体验相比Deep Linking方式更加顺畅。
### 效果预览

不涉及。
### 使用说明
  1. 前期准备：
     需在开发者平台（如 OpenHarmony 应用市场）配置 App Linking 域名，完成域名与应用的关联验证（确保 HTTPS 链接能被正确解析到目标应用）。
     准备两个应用（调用方和目标应用），或在同一工程中通过多 Ability 模拟跨应用场景。
  2. 操作步骤：
     调用方应用：在页面中触发跳转逻辑（如点击按钮），通过openLink接口传入 App Linking 的 HTTPS 链接。
     目标应用：配置module.json5以支持该链接，并在 Ability 中处理链接解析与页面导航。
     测试场景：分别在 “目标应用已安装” 和 “未安装” 两种状态下验证跳转效果。
### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── common
 │   │       ├── GlobalContext.ets           // AppLink 获取应用上下文的接口
 │   │   ├── entryability
 │   │       ├── AppLinkEntryAbility.ets     // AppLink 拉起应用的元能力
 │   │       ├── EntryAbility.ets
 │   │   ├── entrybackupability     
 │   │   ├── pages
 │   │       ├── Index.ets                   // AppLink 拉起应用界面
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现
   1. 目标应用配置（module.json5）
      [目标应用配置](./entry/src/main/module.json5)
      在目标应用的module.json5中声明支持的 App Linking 规则，确保系统能将 HTTPS 链接匹配到该应用。
      AppLinking/entry/src/ohosTest/module.json5
   2. 全局上下文工具（GlobalContext.ets）
      [全局上下文工具](./entry/src/main/ets/common/GlobalContext.ets)
      提供全局上下文访问能力，方便页面获取UIAbilityContext以调用openLink接口。
   3. 调用方跳转逻辑（Index.ets）
      [调用方跳转逻辑](./entry/src/main/ets/pages/Index.ets)
      在页面中触发 App Linking 跳转，通过openLink接口传入 HTTPS 链接。
   4. 目标应用处理跳转（AppLinkEntryAbility.ets）
      [目标应用处理跳转](./entry/src/main/ets/entryability/AppLinkEntryAbility.ets)
      在目标应用的 Ability 中解析 App Linking 链接，提取参数并导航至对应页面。
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
echo code/DocsSample/Ability/AppLinking > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
