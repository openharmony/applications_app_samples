# DomainAccount 测试用例归档

## 用例表

| 测试功能               | 预置条件                                        | 输入                          | 预期输出                                      | 是否自动 | 测试结果 |
| ---------------------- | ----------------------------------------------- | ----------------------------- | --------------------------------------------- | -------- | -------- |
| 拉起应用               | 设备正常运行                                    |                               | 成功拉起应用                                  | 是       | Pass     |
| 注册插件               | 位于ManageDomainAccountsPlugin页面              | 点击‘Register plugin’                | 页面显示“Successfully registered plugin”                        | 是       | Pass     |
| 注销插件               | 位于ManageDomainAccountsPlugin页面              | 点击‘Register plugin’                | 页面显示“unregisterPlugin success“                        | 是       | Pass     |
| Check if the specified domain account exists | 位于ManageDomainAccounts页面，已注册插件        | 点击‘ Check if the specified domain account exists’ | 页面显示“Domain account already exists“                        | 是       | Pass     |
| Add domain account             | 位于ManageDomainAccounts页面，已注册插件        | 点击‘Add domain account’              | 页面显示“Account creation information: "testAccountName"“   | 是       | Pass     |
| Delete domain account             | 位于ManageDomainAccounts页面，已注册插件        | 点击‘Delete domain account’              | 页面显示“Successfully deleted account“                        | 是       | Pass     |
| Query domain account information         | 位于ManageDomainAccounts页面，已注册插件        | 点击‘Query domain account information’          | 页面显示“Queried account information: "testAccountName"“ | 是       | Pass     |
| Authenticate domain account using password     | 位于AuthenticationDomainAccount页面，已注册插件 | 点击‘使用密码进行认证’        | 页面显示“Successfully authenticated domain account using password“              | 是       | Pass     |
| Authenticate domain account using popup         | 位于AuthenticationDomainAccount页面，已注册插件 | 点击‘Authenticate domain account using popup’          | 页面显示"No domain account is bound"                    | 是       | Pass     |