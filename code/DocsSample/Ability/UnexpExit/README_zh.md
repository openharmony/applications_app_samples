# 获取应用异常退出原因
### 介绍
1. 获取应用异常退出原因
  就是获取应用异常退出原因。当应用异常退出后再次启动时，开发者往往需要获取上次异常退出的具体原因和当时的应用状态信息。
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
 │   │   ├── exitability                       // 获取应用异常退出原因
 │   │       ├── exitAbility1.ets            
 │   │       ├── exitAbility2.ets
 │   │   ├── pages
 │   │       ├── Index.ets                   // 首页
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

1. 获取应用异常退出原因
   [获取应用异常](./entry/src/main/ets/exitability/ExitAbility1.ets)

2. 通过want调用ExitAbility2,查看是否拉起对应的ExitAbility2元能力拉起正常。
   [want调用](./entry/src/main/ets/exitability/ExitAbility2.ets)
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
echo code/DocsSample/Ability/UnexpExit > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
