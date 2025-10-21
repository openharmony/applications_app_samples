# 基础能力增强测试用例

## 用例表

| 测试功能                  | 预置条件     | 输入                            | 预期输出                                          | 是否自动 | 测试结果 |
|-----------------------| ------------ |-------------------------------|-------------------------------------------------|------| -------- |
| 拉起应用                  | 设备正常运行 |                               | 成功拉起应用                                       | Yes  | Pass     |
| singleton启动模式         | 设备正常运行 | 应用启动成功，点击'启动单实例模式UIAbility'按钮 | 成功拉起SigletonAbility                           | Yes  | Pass     |
| multiton启动模式          | 设备正常运行 | 应用启动成功，点击'启动多实例模式UIAbility'按钮 | 成功拉起MultitionAbility                     | Yes  | Pass     |
| specified启动模式         | 设备正常运行 | 应用启动成功，点击'新建一个文档'按钮           | 成功拉起SpecifiedFirstAbility               | Yes  | Pass     |
| specified启动模式         | 设备正常运行 | 应用启动成功，点击'打开已保存文档'按钮          | 成功拉起SpecifiedSecondAbility             | Yes  | Pass     |

