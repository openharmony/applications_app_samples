# ArkUI动态布局测试用例归档

## 用例表

| 测试功能                                                                            | 预置条件       | 输入                   | 预期输出    | 是否自动 | 测试结果 |
|---------------------------------------------------------------------------------| -------------- |----------------------|---------|:-----| -------- |
| 测试创建动态布局是否构建成功                                                         | 设备正常运行   | 进入pages/basic/CreateDynamicLayout.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试自定义布局算法实现指导是否构建成功                                                | 设备正常运行 | 进入pages/customlayout/CustomLayoutBasic.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试自定义布局索引页是否构建成功                                                      | 设备正常运行 | 进入pages/customlayout/CustomLayoutIndex.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试自定义网格布局是否构建成功                                                       | 设备正常运行 | 进入pages/customlayout/GridLayout.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试自定义标签云布局是否构建成功                                                      | 设备正常运行 | 进入pages/customlayout/TagCloudLayout.ets页面，push页面，然后然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试自定义瀑布流布局是否构建成功                                                     | 设备正常运行 | 进入pages/customlayout/WaterFlowLayout.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试网格布局算法是否构建成功                                                         | 设备正常运行 | 进入pages/gridlayout/GridLayoutAlgorithm.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试垂直线性布局算法是否构建成功                                                      | 设备正常运行 | 进入pages/linearlayout/ColumnLayoutAlgorithm.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试水平线性布局算法是否构建成功                                                      | 设备正常运行 | 进入pages/linearlayout/RowLayoutAlgorithm.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试通过修改算法属性触发重新布局是否构建成功                                              | 设备正常运行 | 进入pages/responsivelayout/ChangeAlgorithmProperties.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试通过状态变量切换布局算法是否构建成功                                                | 设备正常运行 | 进入pages/responsivelayout/ChangeLayoutAlgorithm.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试通过条件运算符切换布局算法是否构建成功                                              | 设备正常运行 | 进入pages/responsivelayout/ChangeLayoutWithConditionVariable.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试响应式布局算法切换是否构建成功                                                    | 设备正常运行 | 进入pages/responsivelayout/ChangeLayoutWithMediaQuery.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试布局切换保持子组件状态是否构建成功                                                  | 设备正常运行 | 进入pages/responsivelayout/ReserveChildState.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试响应式布局索引页是否构建成功                                                      | 设备正常运行 | 进入pages/responsivelayout/ResponsiveLayoutIndex.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
| 测试堆叠布局算法是否构建成功                                                         | 设备正常运行 | 进入pages/stacklayout/StackLayoutAlgorithm.ets页面，push页面，然后返回 | 页面跳转正常  | 是    | Pass     |
