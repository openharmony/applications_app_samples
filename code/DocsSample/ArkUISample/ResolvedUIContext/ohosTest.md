| 测试功能                              | 预置条件     | 输入                   | 预期输出      | 测试结果 |
|-----------------------------------| ------------ | ---------------------- |-----------| -------- |
| 首页加载测试         | 设备正常运行 | 应用启动时会执行 UIContext.resolveUIContext 获取 UIContext  | 页面加载成功,显示Calculate 20vp to px。 | Pass     |
| 点击 Calculate 20vp to px   | 设备正常运行 | 验证通过resolveUIContext 获取UIContext  |  点击后正常执行 vp2px 转换无异常。  | Pass     |







