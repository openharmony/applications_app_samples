# AudioEffectManagement 测试用例归档

## 用例表

| 测试功能       | 预置条件             | 输入                     | 预期输出                               | 是否自动 | 测试结果 |
| -------------- | -------------------- | ------------------------ | -------------------------------------- | -------- | -------- |
| 拉起应用       | 设备正常运行         |                          | 成功拉起应用                           | 是       | Pass     |
| 主页展示       | 设备正常运行         |                          | 展示音效管理的入口按钮                 | 是       | Pass     |
| 主页按钮点击   | 位于主页             | 点击”音效管理“           | 跳转预置音效查询页面                   | 是       | pass     |
| 选择类型场景   | 位于预置音效查询页面 | 在类型和场景选择框中选择 | 被选择项正常显示                       | 是       | pass     |
| 查询预置音效   | 位于预置音效查询页面 | 点击”查询“按钮           | 查询结果正常显示                       | 是       | pass     |
| 更新类型场景   | 位于预置音效查询页面 | 更新选择框内的类型场景   | 更新项正常显示，查询结果重置           | 是       | pass     |
| 再次查询       | 位于预置音效查询页面 | 点击”查询“按钮           | 查询结果正常显示                       | 是       | pass     |
| 切换页面       | 位于预置音效查询页面 | 点击”实时音效设置“按钮   | 切换至实时音效设置页面                 | 是       | pass     |
| 选择类型场景   | 位于实时音效设置页面 | 在类型和场景选择框中选择 | 被选择项正常显示                       | 是       | pass     |
| 音乐播放       | 位于实时音效设置页面 | 点击播放按钮             | 音乐播放，选择框置灰                   | 是       | pass     |
| 查询实时音效   | 位于实时音效设置页面 | 点击”查询“按钮           | 查询结果正常显示                       | 是       | pass     |
| 音乐暂停       | 位于实时音效设置页面 | 点击暂停按钮             | 音乐暂停，选择框使能                   | 是       | pass     |
| 更新类型场景   | 位于实时音效设置页面 | 更新选择框内的类型场景   | 更新项正常显示，查询结果重置           | 是       | pass     |
| 音乐播放并查询 | 位于实时音效设置页面 | 再次点击播放和查询按钮   | 音乐播放，查询结果正常显示             | 是       | pass     |
| 设置实时音效   | 位于实时音效设置页面 | 在音效模式选择框中选择   | 被选择模式正常显示，音乐听感明显变化   | 是       | pass     |
| 查询实时音效   | 位于实时音效设置页面 | 点击”查询“按钮           | 查询结果正常显示，并与之前的设置值相同 | 是       | pass     |
| 返回主页       | 位于实时音效设置页面 | 点击返回图标             | 音乐终止，回到主页                     | 是       | pass     |



