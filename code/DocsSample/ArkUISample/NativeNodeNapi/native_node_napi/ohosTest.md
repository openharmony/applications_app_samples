# 测试用例归档

## 用例表

| 测试功能                                 | 预置条件     | 输入                                                         | 预期显示                                | 是否自动 | 测试结果 |
| ---------------------------------------- | ------------ | ------------------------------------------------------------ | --------------------------------------- | -------- | -------- |
| 启动应用                                 | 设备正常运行 | 1.开启开发板 <br/>2.编译hap包并将hap包及环境烧录进开发板，运行测试用例<br /> | 成功拉起应用。                          | 否       | 验证通过 |
| swiper正确获取navigation和router相关信息 | 应用位于首页 | 1.点击首页navigation按钮<br/>2.点击pushPath按钮              | 1.获取到以A0ff00/Manager为tag的相关日志 | 否       | 验证通过 |

| EmbeddedComponent OnErrorCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model false 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnErrorCallback:        code=100018, name=start_ability_fail, message=Start ui extension ability failed, please check the want of UIextensionAbility.} | 否 | 验证通过 |
| EmbeddedComponent OnTerminatedCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model true 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnTerminatedCallback: code=0} | 否 | 验证通过 |
| 文本无障碍属性设置 | 应用位于首页 | 1.点击首页Accessibility按钮 | 观测Get日志设置属性值与Set函数一致 | 否 | 验证通过 |