# AgentExtensionAbility智能体管理能力简介

### 介绍

[AgentExtensionAbility智能体管理能力](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/agent-manager-sys.md) 从API version 24开始，支持开发者使用AgentExtensionAbility类型的组件，为应用提供智能体服务。系统应用可以通过agentManager中的connectAgentExtensionAbility方法连接应用侧的AgentExtensionAbility组件从而与智能体进行双向通信和双向安全认证。

### 效果预览

不涉及。
### 使用说明

1. 应用在启动后展示首页，首页展示相关按钮，点击进入相应功能界面。
2. 点击对应按钮触发相关回调，并打印相关信息。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability         
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

1. 在pages目录下的Index.ets中，使用了agentManager相关的能力。
2. 在应用中去连接一个新的AgentExtensionAbility组件。
3. 在应用中去断连一个AgentExtensionAbility组件。

### 相关权限

当前应用需要使用AgentManager去连接AgentExtensionAbility时，需要申请ACL权限（ohos.permission.CONNECT_AGENT）。该ACL权限当前只对系统应用开放申请。

### 依赖

不涉及。

### 约束与限制

1.本示例为Stage模型，支持API24及以上版本SDK。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/ConnectAgentExtension > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
