| 测试功能                                       | 预置条件   | 输入                                         | 预期输出                 | 测试结果 |
|--------------------------------------------|--------|--------------------------------------------|----------------------|------|
| 首页加载测试                                     | 设备正常运行 | 验证基础元素渲染                                   | 检查列表组件               | Pass |
| 赋值定义class                                  | 设备正常运行 | 点击"DecoratorDescriptionPage"               | 跳转成功                 | Pass |
| @ObjectLink装饰继承于Date的class时，可以观察到Date整体的赋值 | 设备正常运行 | 点击"ObservationChangeInheritancePage"       | 跳转成功且包含日历选择器组件       | Pass |
| 观察赋值                                       | 设备正常运行 | 点击"RestrictiveConditionsObservedPage"      | 跳转成功且页面包含Hello World | Pass |
| 成员属性与整体替换                                  | 设备正常运行 | 点击"ReadOnlyVariablePage"                   | 跳转成功且页面包含Button组件    | Pass |
| 嵌套场景                                       | 设备正常运行 | 点击"NestedObjectPage"                       | 跳转成功且页面包含Button组件    | Pass |
| 对象数组                                       | 设备正常运行 | 点击"ObjectArrayPage"                        | 跳转成功且页面包含Button组件    | Pass |
| 二维数组                                       | 设备正常运行 | 点击"TwoDimensionalArrayPage"                | 跳转成功且页面包含Button组件    | Pass |
| 二维数组                                       | 设备正常运行 | 点击"CompleteExampleTwoDimensionalArrayPage" | 跳转成功且页面包含Button组件    | Pass |
| 继承Map类                                     | 设备正常运行 | 点击"InheritFromMapClassPage"                | 跳转成功且页面包含Button组件    | Pass |
| 继承Set类                                     | 设备正常运行 | 点击"InheritFromSetClassPage"                | 跳转成功且页面包含Button组件    | Pass |
| ObjectLink支持联合类型                           | 设备正常运行 | 点击"ObjectLinkSupportsUnionTypesPage"       | 跳转成功且页面包含Button组件    | Pass |
| 基础嵌套对象属性更改失效                               | 设备正常运行 | 点击"BasicNestingPage"                       | 跳转成功且页面包含Button组件    | Pass |
| 复杂嵌套对象属性更改失效                               | 设备正常运行 | 点击"ComplexMethodsNestingPage"              | 跳转成功且页面包含Text组件      | Pass |
| 复杂嵌套对象属性更改失效                               | 设备正常运行 | 点击"ComplexNestingCompletePage"             | 跳转成功且页面包含Button组件    | Pass |
| @Prop与@ObjectLink的差异                       | 设备正常运行 | 点击"DifferencesPropObjectLinkPage"          | 跳转成功且页面包含Button组件    | Pass |
| 在@Observed装饰类的构造函数中延时更改成员变量                | 设备正常运行 | 点击"DelayedChangePage"                      | 跳转成功且页面包含Text组件      | Pass |
| @ObjectLink数据源更新时机                         | 设备正常运行 | 点击"ObjectLinkDataSourceUpdatePage"         | 跳转成功且页面包含Button组件    | Pass |
| @ObjectLink数据源更新时机                         | 设备正常运行 | 点击"ClickEventJackPage"                     | 跳转成功且页面包含Button组件    | Pass |
| this.weather加上Proxy代理，实现UI刷新               | 设备正常运行 | 点击"NotTriggerUIRefreshPage"                | 跳转成功且页面包含Button组件    | Pass |

