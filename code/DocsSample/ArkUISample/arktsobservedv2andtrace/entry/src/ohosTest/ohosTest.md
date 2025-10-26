| 测试功能                                               | 预置条件   | 输入                               | 预期输出              | 测试结果 |
|----------------------------------------------------|--------|----------------------------------|-------------------|------|
| 首页加载测试                                             | 设备正常运行 | 验证基础元素渲染                         | 检查列表组件            | Pass |
| 直接观测的局限性                                           | 设备正常运行 | 点击"LimitationsPage"              | 跳转成功包含文本          | Pass |
| V1版本的解决方案是使用@ObjectLink装饰器与自定义组件来实现观测              | 设备正常运行 | 点击"RealizeObservationPage"       | 跳转成功且包含文本         | Pass |
| 在嵌套类中使用@Trace装饰的属性具有被观测变化的能力。                      | 设备正常运行 | 点击"ObserveChangesPage"           | 跳转成功且页面包含文本       | Pass |
| 在继承类中使用@Trace装饰的属性具有被观测变化的能力。                      | 设备正常运行 | 点击"InheritedChangesPage"         | 跳转成功且页面包含文本       | Pass |
| 类中使用@Trace装饰的静态属性具有被观测变化的能力。                       | 设备正常运行 | 点击"StaticAttributePage"          | 跳转成功且页面包含文本       | Pass |
| 非@Trace装饰的成员属性用在UI上无法触发UI刷新。                       | 设备正常运行 | 点击"UiRefreshCannotTriggeredPage" | 跳转成功且页面包含文本       | Pass |
| 使用@ObservedV2与@Trace装饰的类不能和@State等V1的装饰器混合使用，编译时报错 | 设备正常运行 | 点击"UseMixturePage"               | 跳转成功且页面包含Button组件 | Pass |
| 继承自@ObservedV2的类无法和@State等V1的装饰器混用，运行时报错           | 设备正常运行 | 点击"InheritanceMixturePage"       | 跳转成功且页面包含Button组件 | Pass |
| 嵌套类场景                                              | 设备正常运行 | 点击"NestedClassPage"              | 跳转成功且页面包含Button组件 | Pass |
| 继承类场景                                              | 设备正常运行 | 点击"InheritanceClassPage"         | 跳转成功且页面包含Button组件 | Pass |
| @Trace装饰基础类型的数组                                    | 设备正常运行 | 点击"DecorationFoundationPage"     | 跳转成功且页面包含Button组件 | Pass |
| @Trace装饰对象数组                                       | 设备正常运行 | 点击"DecorativeObjectPage"         | 跳转成功且页面包含文本       | Pass |
| @Trace装饰Map类型                                      | 设备正常运行 | 点击"DecorationMapPage"            | 跳转成功且页面包含Button组件 | Pass |
| @Trace装饰Set类型                                      | 设备正常运行 | 点击"DecorationSetPage"            | 跳转成功且页面包含Button组件 | Pass |
| @Trace装饰Date类型                                     | 设备正常运行 | 点击"DecorateDatePage"             | 跳转成功且页面包含Button组件 | Pass |
