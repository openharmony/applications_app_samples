# ManageDistributedAccount 测试用例归档

## 用例表

| 测试功能                             | 预置条件     | 输入                                       | 预期输出                                           | 是否自动 | 测试结果 |
| ------------------------------------ | ------------ | ------------------------------------------ | -------------------------------------------------- | -------- | -------- |
| 拉起应用                             | 设备正常运行 |                                            | 成功拉起应用                                       | 是       | Pass     |
| Log in and bind distributed account on the current system account   | 位于首页     | 点击'Log in and bind distributed account on the current system account'   | 页面显示'Bind distributed account: ZhangSan'                 | 是       | Pass     |
| Log out and unbind distributed account on the current system account   | 位于首页     | 点击'Log out and unbind distributed account on the current system account'   | 页面显示'Successfully unbound distributed account'                       | 是       | Pass     |
| Log in and bind distributed account on the specified system account | 位于首页     | 点击'Log in and bind distributed account on the specified system account' | 页面显示'指定的系统账号上Bind distributed account: ZhangSan' | 是       | Pass     |
| Log out and unbind distributed account on the specified system account   | 位于首页     | 点击'Log out and unbind distributed account on the specified system account'   | 页面显示'指定系统账号上登出Successfully unbound distributed account'     | 是       | Pass     |