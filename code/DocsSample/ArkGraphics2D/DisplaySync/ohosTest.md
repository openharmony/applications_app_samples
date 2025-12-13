# DisplaySync测试用例归档

## 用例表

| 测试功能            | 预置条件            | 输入                                           | 预期输出                                                                                                                           | 是否自动 | 测试结果 |
|-----------------|-----------------|----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|------|------|
| 拉起应用            | 设备正常运行          |                                              | 成功拉起应用                                                                                                                         | 是    | Pass |
| 主页展示            | 设备正常运行          |                                              | 展示 Requesting Frame Rates for Animations、Requesting Frame Rates for UI Components、Requesting Frame Rates for Custom Content 按钮 | 是    | Pass |
| 主页按钮点击          | 位于主页            | 点击 Requesting Frame Rates for Animations     | 跳转至请求动画绘制帧率页面                                                                                                                  | 是    | Pass |
| 动画绘制帧率开始        | 位于动画绘制帧率面       | 点击Start                                      | 三个方块分别按照30hz、40hz、60hz频率来回移动                                                                                                   | 是    | Pass |
| 动画绘制帧率返回主页      | 位于动画绘制帧率页面      | 点击Back                                       | 回到主页                                                                                                                           | 是    | Pass |
| 主页按钮点击          | 位于主页            | 点击 Requesting Frame Rates for UI Components  | 跳转请求 UI 绘制帧率页面                                                                                                                 | 是    | Pass |
| 请求 UI 绘制帧率开始    | 位于请求 UI 绘制帧率    | 点击 Start                                     | 数字 30、60 分别按照 30hz、60hz 频率放大缩小                                                                                                 | 是    | Pass |
| 请求 UI 绘制帧率停止    | 位于请求 UI 绘制帧率    | 点击 Stop                                      | 数字 30、60 变化停止                                                                                                                  | 是    | Pass |
| 请求 UI 绘制帧率返回    | 位于请求 UI 绘制帧率    | 点击 Back                                      | 回到主页                                                                                                                           | 是    | Pass |
| 主页按钮点击          | 位于主页            | 点击 Requesting Frame Rates for Custom Content | 跳转 请求自绘制内容绘制帧率 页面                                                                                                              | 是    | Pass |
| 请求自绘制内容绘制帧率开始   | 位于请求自绘制内容绘制帧率页面 | 点击Start                                      | 两个方块分别按照 30hz、120hz 频率来回移动                                                                                                     | 是    | pass |
| 请求自绘制内容绘制帧率停止   | 位于请求自绘制内容绘制帧率页面 | 点击Stop                                       | 两个方块移动停止                                                                                                                       | 是    | pass |
| 请求自绘制内容绘制帧率返回主页 | 位于请求自绘制内容绘制帧率页面 | 点击Back                                       | 回到主页                                                                                                                           | 是    | pass |