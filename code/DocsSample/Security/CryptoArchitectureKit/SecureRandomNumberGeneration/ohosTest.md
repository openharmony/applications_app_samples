# 安全随机数生成测试用例归档

## 用例表

| 测试功能                                    | 预置条件     | 输入 | 预期输出       | 是否自动 | 测试结果 |
| ------------------------------------------- | ------------ | ---- | -------------- | -------- | -------- |
| 拉起应用                                    | 设备正常运行 |      | 成功拉起应用   | 是       | Pass     |
| 点击按钮，安全随机数生成，使用await返回结果 | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，安全随机数生成，同步返回结果      | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |