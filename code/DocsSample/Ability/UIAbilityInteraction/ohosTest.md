# 启动应用内的UIAbility组件测试用例

## 用例表

| 测试功能                 | 预置条件     | 输入                                     | 预期输出                                               | 是否自动 | 测试结果 |
|----------------------| ------------ |----------------------------------------|----------------------------------------------------|------| -------- |
| 拉起应用                 | 设备正常运行 |                                        | 成功拉起应用                                             | Yes  | Pass     |
| 启动应用内的UIAbility      | 设备正常运行 | 应用启动成功，点击'拉起FuncAbilityA'按钮            | 成功拉起FuncAbilityA                                   | Yes  | Pass     |
| 启动应用内的UIAbility并返回结果 | 设备正常运行 | 应用启动成功，点击'拉起FuncAbilityA With Result'按钮 | 成功拉起FuncAbilityA，终止后toast提示”来自FuncAbility Index页面“ | Yes  | Pass     |
| 冷启动UIAbility指定页面     | 设备正常运行 | 应用启动成功，点击'冷启动指定页面'按钮                   | 成功拉起ColdAbility                                    | Yes  | Pass     |
| 热启动UIAbility指定页面     | 设备正常运行 | 应用启动成功，点击'热启动指定页面'按钮                   | 成功拉起HotAbility                                     | Yes  | Pass     |
| 启动UIAbility指定窗口模式    | 设备正常运行 | 应用启动成功，点击'StartWindowMode'按钮           | 显示悬浮窗                                              | Yes  | Pass     |

