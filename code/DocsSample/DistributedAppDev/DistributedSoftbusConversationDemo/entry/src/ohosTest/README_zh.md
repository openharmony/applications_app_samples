# 分布式软总线会话自动化测试

### 介绍

本目录为分布式软总线会话示例的UI自动化测试工程，基于arkxtest测试框架编写，覆盖应用拉起、页面显示、按钮点击等基本功能场景。

测试框架arkxtest的详细介绍请[参考](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-test/test-kit-overview.md)。

本测试用例引入UiTest接口[@ohos.UiTest](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-test-kit/js-apis-uitest.md)进行UI自动化操作。

自动化测试用例编写规范请[参考](https://gitcode.com/openharmony/applications_app_samples/blob/master/CodeCommitChecklist.md#ui%E8%87%AA%E5%8A%A8%E5%8C%96%E7%94%A8%E4%BE%8B%E7%BC%96%E5%86%99%E8%A7%84%E8%8C%83)。

### 使用说明

1. 将DistributedSoftbusConversationDemo项目工程导入DevEco Studio开发工具中。
2. 连接真机设备，确保设备已安装目标应用。
3. 在DevEco Studio顶部运行配置中选择**entry\_test**，点击运行按钮执行全部测试用例。
4. 也可在测试代码中右键单个用例（it方法）单独运行。
5. 测试结果在DevEco Studio底部Run/Log面板中查看。

### 工程目录

```
entry/src/ohosTest/
|---ets
|   |---test
|   |   |---Ability.test.ets                   // 自动化测试用例
|   |   |---List.test.ets                      // 测试用例入口
|---module.json5                               // 测试模块配置
```

### 测试用例说明

| 用例名称                                                    | 测试功能     | 验证内容                                            |
| ------------------------------------------------------- | -------- | ----------------------------------------------- |
| DistributedSoftbusConversation\_StartAbility\_001       | 拉起应用     | 启动应用并处理权限弹窗，验证当前顶层Ability为EntryAbility          |
| DistributedSoftbusConversation\_PageTitle\_001          | 页面标题显示   | 验证页面显示"Distributed SoftBus Conversation Test"标题 |
| DistributedSoftbusConversation\_GetTrustedDevices\_001  | 获取可信设备列表 | 点击"Get Trusted Devices"按钮，验证接口调用不出现异常           |
| DistributedSoftbusConversation\_RegisterListener\_001   | 注册会话监听器  | 点击"Register Listener"按钮，验证接口调用不出现异常             |
| DistributedSoftbusConversation\_UnregisterListener\_001 | 注销会话监听器  | 点击"Unregister Listener"按钮，验证接口调用不出现异常           |
| DistributedSoftbusConversation\_SendMessage\_001        | 发送消息     | 点击"Send Message"按钮，验证接口调用不出现异常                  |

### 具体实现

- 通过abilityDelegatorRegistry.getAbilityDelegator()获取AbilityDelegator对象，调用startAbility()拉起应用。
- 通过Driver.create()创建UiTest驱动，使用findComponent(ON.text())查找页面组件。
- 启动应用后，通过查找"允许"按钮并点击，处理权限弹窗。
- 通过assertComponentExist()验证组件是否存在，通过click()模拟用户点击操作。
- 日志使用hilog接口打印，遵循\[Sample\_DistributedSoftbusConversation]前缀规范，DOMAIN设置为0xF811。

### 相关权限

不涉及额外权限，测试用例运行时会自动处理应用权限弹窗。

### 依赖

不涉及。

### 约束与限制

1. 本测试用例仅支持标准系统上运行，支持设备：RK3568。
2. 本测试用例需要使用DevEco Studio 6.1.1 Release及以上版本才可编译运行。
3. 运行测试用例前需确保设备已连接。
4. 首次运行时权限弹窗需由测试代码自动处理，请勿手动操作设备屏幕。

