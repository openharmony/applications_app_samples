# AgentExtensionAbility简介

### 介绍

[使用AgentExtensionAbility组件实现智能体服务](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/agent-extension-ability.md) 从 API version 24 开始支持的组件，旨在为应用提供智能体服务。系统应用可以连接应用侧的AgentExtensionAbility组件从而获取相应的智能体服务。

### 效果预览

不涉及。
### 使用说明

1. 本应用中包含了AgentExtensionAbility，并且配置了AgentCard信息。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── AgentExtAbility
 │   │       ├── AgentExtAbility.ets             
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

1. 在AgentExtAbility目录，右键选择“New > ArkTS File”，新建一个文件并命名为AgentExtAbility.ets。
2. 在Module中的module.json5中注册AgentExtensionAbility。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例为Stage模型，支持API24及以上的版本SDK。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/AgentExtensionAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
