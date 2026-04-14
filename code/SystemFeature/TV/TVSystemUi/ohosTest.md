# TV SystemUI 测试用例归档

本工程 `entry/tv` 模块下配置了 **ohosTest**（模块名 `tv_entry_test`），使用 **Hypium** 执行单元测试。测试入口为 `TestAbility`，用例集合在 `src/ohosTest/ets/test/List.test.ets` 中注册。

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
| --- | --- | --- | --- | --- | --- |
| AbilityManager / 全局 Ability 上下文 | 1. 需在支持 SystemUI 运行环境的设备或模拟环境 <br/> 2. 构建并安装含 ohosTest 的测试包 <br/> | 执行 Hypium 套件中的 AbilityManager 用例 | 用例按断言通过 | 是 | 以实机/流水线为准 |
| CheckEmptyUtils | 同上 | 执行空值/集合检查相关用例 | 断言通过 | 是 | 以实机/流水线为准 |
| CommonStyleManager | 同上 | 执行样式管理相关用例 | 断言通过 | 是 | 以实机/流水线为准 |
| DialogModule | 同上 | 执行对话框模块用例 | 断言通过 | 是 | 以实机/流水线为准 |
| Decorators | 同上 | 执行装饰器相关用例 | 断言通过 | 是 | 以实机/流水线为准 |
| EventBus | 同上 | 执行事件总线用例 | 断言通过 | 是 | 以实机/流水线为准 |
| HeightConfigUtils | 同上 | 执行高度配置工具用例 | 断言通过 | 是 | 以实机/流水线为准 |
| Log | 同上 | 执行日志封装用例 | 断言通过 | 是 | 以实机/流水线为准 |
| PartsPairModel / PairModels | 同上；涉及配件配对模型 | 执行配对模型用例 | 断言通过 | 是 | 以实机/流水线为准 |
| ResourceUtil | 同上 | 执行资源工具用例 | 断言通过 | 是 | 以实机/流水线为准 |
| SceneTests | 同上 | 执行场景类组合用例 | 断言通过 | 是 | 以实机/流水线为准 |
| TimeManager | 同上 | 执行时间管理相关用例 | 断言通过 | 是 | 以实机/流水线为准 |
| Volume 相关（Constants / VM / WindowController / Service） | 同上；音量面板与窗口逻辑 | 执行音量相关用例 | 断言通过 | 是 | 以实机/流水线为准 |
| SettingsUtilIntegration | 同上 | 执行设置工具集成用例 | 断言通过 | 是 | 以实机/流水线为准 |
| WindowManagerFull | 同上 | 执行窗口管理全量用例 | 断言通过 | 是 | 以实机/流水线为准 |
| StringUtil / ArrayBufferUtil / EventUtil / TimeoutPromise | 同上 | 执行对应工具类用例 | 断言通过 | 是 | 以实机/流水线为准 |

## 说明

- 运行方式与工程构建配置一致：在 DevEco Studio 中选择 **ohosTest** 目标或使用命令行执行测试任务；具体以当前 SDK 与工程 `build-profile.json5` 为准。
- 测试结果请在集成环境或真机执行后更新上表「测试结果」列（例如 Pass / Fail）。
