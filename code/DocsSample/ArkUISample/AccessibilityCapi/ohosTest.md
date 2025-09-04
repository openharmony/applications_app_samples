# AccessibilityCapi测试用例归档

## 用例表

| 测试功能                 | 预置条件     | 输入                 | 预期输出                 | 是否自动 | 测试结果 |
| ------------------------ | ------------ | -------------------- | ------------------------ | -------- | -------- |
| 拉起应用                 | 设备正常运行 |       进入应用首页               | 成功拉起应用             | 是       | Pass     |
| EmbeddedComponent OnErrorCallback回调成功 | 设备正常运行 | hdc shell param set persist.sys.abilityms.multi_process_model false | EmbeddedComponent onError回调被触发，打印日志{OnErrorCallback:        code=100018, name=start_ability_fail, message=Start ui extension ability failed, please check the want of UIextensionAbility.} | 是       | Pass     |
| EmbeddedComponent OnTerminatedCallback回调成功     | 设备正常运行 | hdc shell param set persist.sys.abilityms.multi_process_model true | EmbeddedComponent onError回调被触发，打印日志{OnTerminatedCallback: code=0}         | 是       | Pass     |
| 文本无障碍属性设置     | 设备正常运行 | 进入应用首页 | 观测Get日志设置属性值与Set函数一致     | 是       | Pass     |