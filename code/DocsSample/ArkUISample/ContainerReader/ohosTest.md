# ArkUI ContainerReader测试用例归档

## 用例表

| 测试功能                                                 | 预置条件     | 输入                                                                      | 预期输出   | 是否自动 | 测试结果 |
|------------------------------------------------------|----------|-------------------------------------------------------------------------|--------|:-----|--------|
| 测试占满空间是否构建成功                                          | 设备正常运行   | 进入pages/layoutSpecifications/FillTheSpace.ets页面，push页面，然后返回            | 页面跳转正常 | 是    | Pass   |
| 测试占满剩余空间是否构建成功                                         | 设备正常运行   | 进入pages/layoutSpecifications/DivideRemainingSpace.ets页面，push页面，然后返回     | 页面跳转正常 | 是    | Pass   |
| 测试平分剩余空间是否构建成功                                         | 设备正常运行   | 进入pages/layoutSpecifications/DivideRemainingSpaceEqually.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试布局规格索引页是否构建成功                                         | 设备正常运行   | 进入pages/layoutSpecifications/LayoutSpecificationsIndex.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试开发步骤是否构建成功                                            | 设备正常运行   | 进入pages/developmentSteps/DevelopmentSteps.ets页面，push页面，然后返回             | 页面跳转正常 | 是    | Pass   |
| 测试结合layoutWeight使用是否构建成功                                | 设备正常运行   | 进入pages/combineWithFlexRowColumn/CombineWithLayoutWeight.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试displayPriority控制显示优先级（低优先级）是否构建成功                     | 设备正常运行   | 进入pages/combineWithFlexRowColumn/CombineWithLowDisplayPriority.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试displayPriority控制显示优先级（高优先级）是否构建成功                     | 设备正常运行   | 进入pages/combineWithFlexRowColumn/CombineWithHighDisplayPriority.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试flexShrink控制收缩比例是否构建成功                                | 设备正常运行   | 进入pages/combineWithFlexRowColumn/CombineWithFlexShrink.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试flexGrow控制扩展比例是否构建成功                                   | 设备正常运行   | 进入pages/combineWithFlexRowColumn/CombineWithFlexGrow.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试结合Flex/Row/Column使用是否构建成功                              | 设备正常运行   | 进入pages/combineWithFlexRowColumn/CombineWithFlexColumnRowIndex.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试独立断点设置是否构建成功                                          | 设备正常运行   | 进入pages/developmentDemo/IndependentBreakpoints.ets页面，push页面，然后返回       | 页面跳转正常 | 是    | Pass   |
| 测试Grid自适应列数设置是否构建成功                                      | 设备正常运行   | 进入pages/developmentDemo/GridComponentAdaptiveColumnSettings.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试自定义组件自适应布局是否构建成功                                       | 设备正常运行   | 进入pages/developmentDemo/CustomComponentAdaptiveLayout.ets页面，push页面，然后返回 | 页面跳转正常 | 是    | Pass   |
| 测试自适应左右分栏是否构建成功                                         | 设备正常运行   | 进入pages/developmentDemo/LeftOrRightSplitLayout.ets页面，push页面，然后返回       | 页面跳转正常 | 是    | Pass   |
