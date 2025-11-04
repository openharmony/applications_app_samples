# ArkUI自定义组件混用场景指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [自定义组件混用场景指导](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-custom-component-mixed-scenarios.md)。


### 效果预览

| 存在变量传递时，V1和V2的自定义组件数据混用效果        
| ------------------------------------ |
| ![](screenshots/device/image1.png) |

### 使用说明

1. 在主界面，可以点击对应页面，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
├── common
│   └── Resource.ets
├── entryability
│   └── EntryAbility.ets
├── entrybackupability
│   └── EntryBackupAbility.ets
└── pages
    ├── Index.ets
    ├── MixingUseofCustomComponents
    │   ├── ObserveNestedClasses_ObservedAndObjectLink.ets
    │   ├── ObserveNestedClasses_ObsevedV2AndTrace.ets
    │   ├── V1CommonVariablesToV2CustomComponent.ets
    │   ├── V1StateVariablesToV2CustomComponent.ets
    │   ├── V1InV2.ets
    │   ├── V2CommonVariablesToV1CustomComponent.ets
    │   ├── V2StateVariablesToV1CustomComponent.ets
    │   └── V2InV1.ets
    └── common
        └── Index.ets
entry/src/ohosTest/
├── ets
│   └── test
│       ├── Ability.test.ets
│       ├── Index.test.ets        // 测试用例代码
│       └── List.test.ets
└── module.json5
```

### 具体实现

状态管理V1与V2的混用规则如下：
1. V1的自定义组件中不可以使用V2的装饰器，否则编译报错。

2. 当组件间不传递变量时，V1的自定义组件中可以使用V2的自定义组件，包括导入第三方的@ComponentV2装饰的自定义组件。

3. 组件间存在变量传递时，V1的变量传递给V2的自定义组件，有以下限制：V1中未被装饰器装饰的变量（后称普通变量）：V2只能使用@Param接收。V1中被装饰器装饰的变量（后称状态变量）：V2只能通过@Param装饰器接收，且仅限于boolean、number、enum、string、undefined、null这些简单类型数据。

4. V2的自定义组件中不可以使用V1的装饰器，否则编译报错。

5. 组件间不存在变量传递时，V2自定义组件可以使用V1的自定义组件，包括import第三方@Component装饰的自定义组件。

6. 组件间存在变量传递时，V2的变量传递给V1的自定义组件，有以下限制：V2中未被装饰器装饰的变量（后称普通变量）：若V1使用装饰器装饰接收的数据，只能通过@State、@Prop、@Provide。V2中被装饰器装饰的变量（后称状态变量）：若V1使用装饰器装饰接收的数据，不支持内置类型数据：Array、Set、Map、Date。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858， built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/CustomComponentsMixingUse > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````