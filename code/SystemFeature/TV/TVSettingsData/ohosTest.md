# TVSettingsData 测试用例归档

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 基础测试用例运行 | 1. 构建并安装测试 hap（`entry_test`）<br/>2. 设备支持运行 Hypium | 执行 `ohosTest` 用例 | 用例执行完成，无异常崩溃 | 是 | Pass |
| Ability 测试示例 | 已安装测试 hap | 执行 `Ability.test.ets` | 断言通过（`assertContain/assertEqual` 通过） | 是 | Pass |

