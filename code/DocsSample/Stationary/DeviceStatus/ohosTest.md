# DeviceStatus服务测试用例

## 用例表

| 测试功能                 | 预置条件     | 输入                 | 预期输出                 | 是否自动 | 测试结果 |
| ------------------------ | ------------ | -------------------- | ------------------------ | -------- | -------- |
| 订阅 | 进入主界面 | 点击订阅按钮 | 页面text显示deviceStatus subscribe | 是 | Pass |
| 取消全部订阅 | 进入主界面 | 点击取消全部订阅按钮 | 页面text显示deviceStatus unsubscribeAll | 是 | Pass |
| 取消单个订阅 | 进入主界面 | 点击取消单个订阅按钮 | 页面text显示deviceStatus unsubscribe | 是 | Pass |
