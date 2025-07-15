#  延迟加载测试用例归档

## 用例表

| 测试功能     | 预置条件     | 输入                | 预期输出     | 测试结果 |
| ------------ | ------------ | ------------------- | ------------ | -------- |
| 拉起应用     | 设备正常运行 |                     | 成功拉起应用 | Pass     |
| 主页按钮点击 | 位于主页     | 点击触发a按钮       | Call a success result: a = mod1 a executed | Pass     |
| 主页按钮点击 | 位于主页     | 点击触发b按钮       | Call b success result: b = mod1 b executed | Pass     |
| 主页按钮点击 | 位于主页     | 点击触发c按钮       | Call c success result: c = mod2 c executed | Pass     |
| 主页按钮点击 | 位于主页     | 点击不推荐用法1按钮 | Not advisable to use one error: ReferenceError | Pass     |
| 主页按钮点击 | 位于主页     | 点击不推荐用法2按钮 | Not advisable to use two error: ReferenceError | Pass     |