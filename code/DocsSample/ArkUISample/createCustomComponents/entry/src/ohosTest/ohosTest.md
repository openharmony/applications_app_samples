| 测试功能                           | 预置条件     | 输入               | 预期输出                                                     | 测试结果 |
|--------------------------------| ------------ | ------------------ |----------------------------------------------------------| -------- |
| 首页加载测试                         | 设备正常运行 | 验证基础元素渲染    | 检查列表组件                                                   | Pass     |
| 自定义组件的基本用法                     | 设备正常运行 | 点击"ParentComponentPage" | 跳转成功且页面包含自定义组件                                           | Pass     |
| 自定义组件的参数规定                     | 设备正常运行 | 点击"ParameterSpecificationPage" | 跳转成功且根据装饰器的规则来初始化自定义组件的参数                                | Pass     |
| 自定义组件的参数规定                     | 设备正常运行 | 点击"ParentFunctionPage" | 跳转成功且父组件中的函数传递给子组件                                       | Pass     |
| build()函数                      | 设备正常运行 | 点击"MyComponentBuildPage" | 跳转成功且build()函数下根节点唯一且必要，必须为容器组件                          | Pass     |
| 自定义组件通用样式                      | 设备正常运行 | 点击"MyComponentStylePage" | 跳转成功且自定义组件通过“.”链式调用设置通用样式                                | Pass     |
| V1自定义组件不支持静态代码块                | 设备正常运行 | 点击"StaticCodeV1Page" | 跳转成功且在@Component或@CustomDialog装饰的自定义组件中编写静态代码块时，该代码不会被执行 | Pass     |
| V2装饰的自定义组件中支持使用静态代码块           | 设备正常运行 | 点击"StaticCodeV2Page" | 跳转成功且静态代码块生效，a的值变为'hello world'                          | Pass     |
| 状态管理基本概念                       | 设备正常运行 | 点击"stateManagementOverviewPage" | 跳转成功且子组件初始化的默认值在有父组件传值的情况下，会被覆盖                          | Pass     |
| @Component                     | 设备正常运行 | 点击"ComponentPage" | 跳转成功且一个struct只能被一个@Component装饰                           | Pass     |
| freezeWhenInactive             | 设备正常运行 | 点击"FreezeWhenInactivePage" | 跳转成功且页面包含freezeWhenInactive参数                            | Pass     |
| build()函数                      | 设备正常运行 | 点击"BuildFunctionPage" | 跳转成功且自定义组件必须定义build()函数                                  | Pass     |
| @Entry                         | 设备正常运行 | 点击"EntryPage" | 跳转成功且@Entry装饰的自定义组件将作为UI页面的入口                            | Pass     |
| EntryOptions                   | 设备正常运行 | 点击"RouteNamePage" | 跳转成功且有routeName参数                                        | Pass     |
| @Reusable                      | 设备正常运行 | 点击"ReusablePage" | 跳转成功且有@Reusable装饰的自定义组件                                  | Pass     |
| build()函数不允许调用没有用@Builder装饰的方法 | 设备正常运行 | 点击"BuilderMethodPage" | 跳转成功且不允许调用没有用@Builder装饰的方法                               | Pass     |
| build()函数不允许使用switch语法         | 设备正常运行 | 点击"IfPage" | 跳转成功且页面使用的是if                                            | Pass     |
| build()函数不允许使用表达式              | 设备正常运行 | 点击"ModuleComponentPage" | 跳转成功且页面使用的是if                                            | Pass     |
| 数组修改                           | 设备正常运行 | 点击"ForEachFilterPage" | 跳转成功且页面包含ForEach                                         | Pass     |

