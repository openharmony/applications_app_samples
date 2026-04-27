# 应用重启（restartApp）

### 介绍

本示例展示了如何使用 ApplicationContext 的 restartApp 方法来重启应用。restartApp 方法可以用于在应用运行过程中重启应用，例如在配置更改后需要重启应用使新配置生效的场景。

### 效果预览

进入应用后，点击"restartApp"按钮，应用将重启并返回到首页。
![完全重新启动应用](screenshots/ApplicationContextRestartApp.gif)
![重启应用刷新当前窗口](screenshots/UIAbilityContextRestartApp1.gif)
![重启应用跳转到新窗口](screenshots/UIAbilityContextRestartApp2.gif)

### 使用说明

1. 前期准备：
   * 确保设备已正常运行。
   * 使用 DevEco Studio 编译并安装本应用到设备。
2. 操作步骤：
   * 启动应用后，点击页面中央的"restartApp"按钮。
   * 观察应用重启过程，应用会关闭并重新启动，返回到首页。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │       ├── EntryAbility.ets            // 主Ability
 │   │   ├── secondability
 │   │       ├── SecondAbility.ets           // 第二个Ability
 │   │   ├── entrybackupability
 │   │       ├── EntryBackupAbility.ets      // 备份扩展Ability
 │   │   ├── pages
 │   │       ├── Index.ets                   // 主页面，包含restartApp按钮
 │   │       ├── Index2.ets
 │   │       ├── Index3.ets
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```

### 具体实现

* 应用重启功能，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 使用 ApplicationContext.restartApp() 方法重启应用
  * 通过 Want 对象指定重启后启动的 Ability

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例为 Stage 模型，支持 API22 版本 SDK。

3. 本示例需要使用 DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025) 及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/restartapp > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
