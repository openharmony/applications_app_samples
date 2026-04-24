# ArkTS TurboTrans简介

### 介绍

本示例主要演示了 `@hadss/turbo-trans-json`（下文简称 **turbotransJSON**）在 ArkTS 中操作Sendable对象的典型用法：
 	 
- 使用 **turbotransJSON** 将 JSON 字符串反序列化为对象，并转换为 **Sendable 对象** 在并发实例间传递。

### 效果预览

|                                     首页                                     |                            执行及结果即时反馈                             |
|:--------------------------------------------------------------------------:| :-----------------------------------------------------------------------: |
| <img src="./screenshots/TurboTrans_1.png" style="zoom: 30%;" width="360;" /> | <img src="./screenshots/TurboTrans_2.png" style="zoom: 50%;" width="360;" /> |

### 使用说明

1. 在主界面，点击运行Taskpool测试。
2. 执行结果会即时反馈在屏幕中央，打印出Test。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   │   └── EntryAbility.ets          // 应用入口能力
 │   │   ├── entrybackupability
 │   │   │   └── EntryBackupAbility.ets    // 备份恢复能力
 │   │   ├── pages
 │   │   │   ├── Index.ets                 // 首页
 │   │   │   └── concurrentFunc.ets        // 并发函数定义
 │   │   ├── turbotrans_JSON
 │   │   │   ├── layout.ets                // JSON布局模型
 │   │   │   └── test1.ets                 // JSON序列化测试
 │   ├── module.json5
 │   └── resources
 ├── generated
 │   └── ets
 │       ├── sendableModel
 │       │   └── SendableLayout.ets        // 自动生成的Sendable布局模型
 │       └── turbotrans_JSON
 │           └── layout.ets                // 自动生成的JSON布局模型
 ├── mock
 │   └── mock-config.json5                 // Mock配置文件
 ├── ohosTest
 │   └── ets
 │       └── test
 │           ├── Ability.test.ets          // 自动化测试代码
 │           └── List.test.ets             // 列表测试代码
 └── test
     ├── List.test.ets                     // 列表单元测试
     └── LocalUnit.test.ets                // 本地单元测试
```

### 相关权限

不涉及。

### 依赖

使用 ohpm 安装核心库：
ohpm install @hadss/turbo-trans-core @hadss/turbo-trans-json

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：64位设备。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.820, built on June 28, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/TurboTrans > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
