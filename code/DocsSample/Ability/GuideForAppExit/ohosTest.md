# 应用退出指南测试用例

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---------|---------|------|---------|---------|---------|
| terminateSelf应用拉起 | 设备正常运行 | | 成功拉起应用 | Yes | Pass |
| terminateSelf自动退出 | 应用已启动 | 等待2秒 | 应用自动退出 | Yes | Pass |
| onBackPressed应用拉起 | 设备正常运行 | | 成功拉起应用 | Yes | Pass |
| onBackPressed返回键处理 | 应用已启动 | 点击返回键 | 应用退出 | Yes | Pass |
| Ability生命周期测试 | 应用已启动 | | 生命周期方法正常调用 | Yes | Pass |
| terminateSelf错误处理 | 应用已启动 | | 错误处理正常 | Yes | Pass |
| Promise异步处理 | 应用已启动 | | Promise处理正常 | Yes | Pass |
| Want参数验证 | 应用已启动 | | Want参数正确 | Yes | Pass |

## 测试说明

### terminateSelf模块测试
1. **应用启动测试**：验证应用能否正常启动
2. **自动退出测试**：验证应用在2秒后是否自动调用terminateSelf()退出
3. **错误处理测试**：验证terminateSelf()方法的错误处理机制
4. **生命周期测试**：验证应用退出时的生命周期方法调用顺序

### onBackPressed模块测试
1. **应用启动测试**：验证应用能否正常启动
2. **返回键监听测试**：验证onBackPressed()方法是否能正确捕获返回键事件
3. **事件消费测试**：验证返回true时是否正确消费事件
4. **退出逻辑测试**：验证点击返回键后应用是否正常退出

### 自动化测试
- Ability.test.ets：包含30+个自动化测试用例，覆盖：
  - Ability生命周期方法测试
  - terminateSelf相关方法测试
  - Want参数测试
  - 错误处理测试
  - Promise异步操作测试
  - 各种断言方法测试
