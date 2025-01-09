# ManageSystemAccountCredentials 测试用例归档

## 用例表

| 测试功能     | 预置条件     | 输入               | 预期输出                    | 是否自动 | 测试结果 |
| ------------ | ------------ | ------------------ | --------------------------- | -------- | -------- |
| 拉起应用     | 设备正常运行 |                    | 成功拉起应用                | 是       | Pass     |
| Enter PIN code    | 位于首页     | 点击'Enter PIN code'    | 页面显示“PIN code entry successful”     | 是       | Pass     |
| Authenticate PIN code    | 位于首页     | 点击'Authenticate PIN code'    | 页面显示“PIN code entry successful”     | 是       | Pass     |
| Update credentials     | 位于首页     | 点击'Update credentials'     | 页面显示“Successfully updated PIN code credentials” | 是       | Pass     |
| Query credential information | 位于首页     | 点击'Query credential information' | 页面显示“Query information length:1” | 是       | Pass     |
| Delete credentials     | 位于首页     | 点击'Delete credentials'     | 页面显示“Successfully deleted PIN code credentials” | 是       | Pass     |