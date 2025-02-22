# AsyncConcurrencyOverview 测试用例归档

## 用例表

| 测试功能             | 预置条件     | 输入                       | 预期输出                                      | 是否自动 | 测试结果 |
| -------------------- | ------------ | -------------------------- | --------------------------------------------- | -------- | -------- |
| 拉起应用             | 设备正常运行 |                            | 成功拉起应用                                  | 是       | Pass     |
| Create application account         | 位于首页     | 点击'Create application account'         | 页面显示'Account creation successful'                        | 是       | Pass     |
| Query application account         | 位于首页     | 点击'Query application account'         | 页面显示'Query account result: ZhangSan'              | 是       | Pass     |
| Access account credentials       | 位于首页     | 点击'Access account credentials'       | 页面显示'Successfully set account credentials: xxxxxx'          | 是       | Pass     |
| Access custom data of the account | 位于首页     | 点击'Access custom data of the account’ | 页面显示'Successfully set custom account credentials, age is 12‘ | 是       | Pass     |
| Access account authorization token   | 位于首页     | 点击'Access account authorization token’   | 页面显示'Successfully stored account authorization token: xxxxxx‘        | 是       | Pass     |
| Delete application account         | 位于首页     | 点击'Delete application account’         | 页面显示'removeAccount successfully‘                        | 是       | Pass     |