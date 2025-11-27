# Want简介

### 介绍

[Want概述](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/want-overview.md) 文档中的Want是一种对象，用于在应用组件之间传递信息。

### 效果预览

不涉及。
### 使用说明

1. 应用在启动后显示文本"hello world"。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── explicitability
 │   │       ├── ExplicitAbility.ets   // 显式Want一般使用
 │   │   ├── implicitability
 │   │       ├── ImplicitAbility.ets            // 隐式Want一般使用
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

1.通常用于应用内组件启动，通过在Want对象内指定本应用Bundle名称信息（bundleName）和abilityName来启动应用内目标组件。当有明确处理请求的对象时，显式Want是一种简单有效的启动目标应用组件的方式。

entry/src/main/ets/explicitability/ExplicitAbility.ets
```ts
import { Want } from '@kit.AbilityKit';

let wantInfo: Want = {
  deviceId: '', // deviceId为空表示本设备
  bundleName: 'com.example.myapplication',
  abilityName: 'FuncAbility',
}
```

2.隐式Want：在启动目标应用组件时，调用方传入的want参数中未指定abilityName，称为隐式Want

entry/src/main/ets/implicitability/ImplicitAbility.ets
```ts
import { Want } from '@kit.AbilityKit';

let wantInfo: Want = {
  // uncomment line below if wish to implicitly query only in the specific bundle.
  // bundleName: 'com.example.myapplication',
  action: 'ohos.want.action.search',
  // entities can be omitted
  entities: [ 'entity.system.browsable' ],
  uri: 'https://www.test.com:8080/query/student',
  type: 'text/plain',
};
```
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/WantOverview > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
