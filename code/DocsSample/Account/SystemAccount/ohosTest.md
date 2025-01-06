# SystemAccount 测试用例归档

## 用例表

| 测试功能                           | 预置条件                                     | 输入                                     | 预期输出                                     | 是否自动 | 测试结果 |
| ---------------------------------- | -------------------------------------------- | ---------------------------------------- | -------------------------------------------- | -------- | -------- |
| 拉起应用                           | 设备正常运行                                 |                                          | 成功拉起应用                                 | 是       | Pass     |
| Set the constraint list for the specified system account         | 位于UseConstraintManagementSystemAccount页面 | 点击'Set the constraint list for the specified system account'         | 页面显示“Successfully set the constraint list for the specified system account”     | 是       | Pass     |
| Determine if the specified constraint for the target system account is enabled | 位于UseConstraintManagementSystemAccount页面 | 点击'Determine if the specified constraint for the target system account is enabled' | 页面显示“Set the constraint list for the specified system account”   | 是       | Pass     |
| Create system account                       | 位于ManageSystemAccounts页面                 | 点击'Create system account'                       | 页面显示“Account creation successful. Account name:: "Bob"”       | 是       | Pass     |
| Query all system accounts                   | 位于ManageSystemAccounts页面                 | 点击'Query all system accounts'                   | 页面显示“Query account successful. Account name:"user"”      | 是       | Pass     |
| Query specified system account information               | 位于ManageSystemAccounts页面                 | 点击'Query specified system account information'               | 页面显示“Query account successful. Account name for account 100: "user"” | 是       | Pass     |
| Modify system account avatar                   | 位于ManageSystemAccounts页面                 | 点击'Modify system account avatar'                   | 页面显示“Successfully updated system account avatar”               | 是       | Pass     |
| Modify system account nickname                   | 位于ManageSystemAccounts页面                 | 点击'Modify system account nickname'                   | 页面显示“Successfully modified system account name”               | 是       | Pass     |
| Delete system account                       | 位于ManageSystemAccounts页面                 | 点击'Delete system account'                       | 页面显示“Successfully deleted system account”                   | 是       | Pass     |