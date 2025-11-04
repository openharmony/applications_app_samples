# 状态管理指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [状态管理](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-state-management-best-practices.md)。

### 效果预览

| 避免与否在for、while等循环逻辑中频繁读取状态变量的效果                                            | 使用临时变量替换状态变量或者直接操作状态变量的效果图                                            | 使用@ObjectLink和@Prop深拷贝的效果                                            | 使用状态变量或者不使用强行更新非状态变量的效果                                            | 精准与否控制状态变量关联的组件数的效果                                            | 
| ------------------------------------ | --------------------------------------------- | --------------------------------------------------- | ------------------------------------ |
| ![](screenshots/image1.png) | ![](screenshots/image1.png) | ![](screenshots/image2.png)
| ![](screenshots/image3.png) | ![](screenshots/image4.png) |

### 使用说明

1. 在主界面，可以点击对应页面，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
├── common
│   └── resource.ets
├── entryability
│   └── EntryAbility.ets
├── entrybackupability
│   └── EntryBackupAbility.ets
└── pages
    ├── CalculationDirectState.ets                 // 直接操作状态变量反例
    ├── CalculationTempVariable.ets                // 使用临时变量替换状态变量正例
    ├── DeepCopyReverse.ets                        // 使用@Prop深拷贝反例
    ├── DeepCopyCorrect.ets                        // 使用@ObjectLink深拷贝正例
    ├── ForceUpdateCounterexample.ets              // 不使用状态变量强行更新非状态变量反例
    ├── ForceUpdatePositiveCase.ets                // 使用状态变量强行更新非状态变量正例
    ├── LoopStateInefficient.ets                   // 没有避免在for、while等循环逻辑中频繁读取状态变量反例
    ├── LoopStateOptimized.ets                     // 避免在for、while等循环逻辑中频繁读取状态变量正例
    ├── PreciseControlCounterexamples.ets          // 没有精准控制状态变量关联的组件数反例
    ├── PreciseControlPositiveCases.ets            // 精准控制状态变量关联的组件数正例
    └── Index.ets                                  // 页面入口
entry/src/ohosTest/
├── ets
│   └── test
│       ├── Ability.test.ets
│       ├── Index.test.ets                         // 测试用例代码
│       └── List.test.ets
└── module.json5
```

### 具体实现
1. 使用@ObjectLink代替@Prop减少不必要的深拷贝：当父组件向子组件传递状态变量，且子组件不需要修改该状态变量时，应使用@ObjectLink而非@Prop。因为@Prop会深拷贝数据，增加组件创建时间和内存开销，而@ObjectLink保持引用，不会深拷贝，从而提高性能。

2. 避免使用状态变量强行更新非状态变量关联的组件：不要通过定义一个状态变量（如更新标志）来强制更新与非状态变量关联的组件。相反，应该将需要触发UI更新的变量用@State装饰，这样当变量变化时，ArkUI框架会自动触发UI更新，避免不必要的性能开销。

3. 精准控制状态变量关联的组件数：将一个状态变量绑定在多个同级组件的属性上时，状态变化会导致这些组件同时刷新，可能造成不必要的渲染。为了减少刷新组件的数量，可以将这些组件相同的属性绑定到它们的父组件上，这样状态变化时只需要刷新父组件，从而提升性能。

4. 使用临时变量替换状态变量进行多次操作：在需要对状态变量进行多次修改时，应先将状态变量赋值给一个临时变量，在临时变量上进行计算，最后再将临时变量赋值给状态变量。这样可以减少状态变量更新的次数，从而减少ArkUI框架查询和渲染组件的次数，提高性能。

5. 优化循环和频繁操作中的状态访问：在循环、递归或高频回调函数外预先读取状态变量值，将状态变量值存储在局部变量中供循环内部使用，避免在每次循环迭代中都通过this.访问状态变量。

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
echo code/DocsSample/ArkUISample/StateManagement > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````