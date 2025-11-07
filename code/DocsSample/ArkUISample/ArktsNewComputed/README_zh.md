# @Once：初始化同步一次

### 介绍

本示例展示了[@Once：初始化同步一次](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-new-once.md)装饰器的使用方法：

1. @Once用于期望变量仅初始化同步数据源一次，之后不再继续同步变化的场景；
2. 当@Once与@Param结合使用时，可以解除@Param无法在本地修改的限制，并能够触发UI刷新。此时，使用@Param和@Once的效果类似于@Local，但@Param和@Once还能接收外部传入的初始值；

### 效果预览


| CustomComponentUse页面  | ObservedV2ClassUser界面    | ComputingPropertyResolution界面 | ComputedInitParam界面 | ComputedProperty界面         |
|-------------------------|-----------------------------|-----------------------------|-----------------------------|-----------------------------|
| ![](screenshots/image1.png) | ![](screenshots/image2.png) | ![](screenshots/image3.png) | ![](screenshots/image4.png) | ![](screenshots/image5.png) |

### 具体实现

1. 到对应模块的官网文档，理解模块功能和使用说明

2. 补充对应的代码片段，确保可以运行

3. 拿真机，填写测试用例，运行项目

4. 拿真机对用例进行自动测试

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

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例已适配API version 12及以上版本SDK。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArktsNewComputed/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```