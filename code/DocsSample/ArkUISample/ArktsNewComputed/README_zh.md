# @Computed装饰器：计算属性

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [@Computed装饰器：计算属性](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-new-Computed.md)

### 效果预览


| CustomComponentUse页面  | ObservedV2ClassUser界面    | ComputingPropertyResolution界面 | ComputedInitParam界面 | ComputedProperty界面         |
|-------------------------|-----------------------------|-----------------------------|-----------------------------|-----------------------------|
| ![](screenshots/image1.png) | ![](screenshots/image2.png) | ![](screenshots/image3.png) | ![](screenshots/image4.png) | ![](screenshots/image5.png) |


### 使用说明

执行测试用例会先打开相应界面，然后会将界面上的按钮点击一遍，演示初始化同步数据源。

### 工程目录
```
entry/src/
├── main
│   ├── ets
│   │   ├── entryability
│   │   ├── entrybackupability
│   │   └── pages
│   │       ├── Index.ets
│   │       └── ComputedInitParam.ets
│   │       └── ComputedProperty.ets
│   │       └── ComputingPropertyResolution.ets
│   │       └── CustomComponentUse.ets
│   │       └── ObservedV2ClassUser.ets
│   ├── module.json5
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets
            └── index.test.ets
            └── List.test.ets

```

### 具体实现

1. @ComponentV2中@Computed装饰getter方法，避免UI重复计算，依赖状态变化仅重算一次；

2. @ObservedV2类中@Computed依赖@Trace变量，异步初始化，依赖变化自动重算；

3. @Computed计算结果可初始化子组件@Param，依赖变化时自动同步

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例已适配API version 20及以上版本SDK。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArktsNewComputed/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```