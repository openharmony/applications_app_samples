# 语言基础类库测试用例归档

## 用例表

| 测试功能     | 预置条件    | 输入       | 预期输出                     | 是否自动              | 测试结果 |
| ----------- | -------- | ---------- |--------------------------|------|------|
| 拉起应用     | 设备正常运行  | 点击应用图标   | 成功拉起应用                   | 是                  | Pass |
| 主页按钮点击   | 位于主页    | 点击搜索心率设备 | 开始搜索附近心率设备并显示设备列表        | 是       | Pass |
| 主页按钮点击   | 位于主页    | 点击连接     | 开始连接心率设备，连接成功显示两个按钮：查看心率和断开连接 | 是 | Pass |
| 主页按钮点击   | 位于主页    | 点击查看心率   | 跳转到实时心率图页                | 是               | Pass |
| 实时心率图页测试 | 位于实时心率图页 | 点击返回箭头   | 能够正确返回到上一页               | 是              | Pass |
| 实时心率图页测试 | 位于实时心率图页 | -          | 能够正确显示实时心率数据             | 是            | Pass |
| 实时心率图页测试 | 位于实时心率图页 | 点击断开连接   | 断开与心率设备的连接并返回到上一页  | 是 | Pass |