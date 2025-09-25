# 测试用例归档

## 用例表

| 测试功能                       | 预置条件     | 输入                                                         | 预期显示                                                     | 是否自动 | 测试结果 |
| ------------------------------ | ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | -------- |
| 启动应用                       | 设备正常运行 | 1.开启开发板 <br/>2.编译hap包并将hap包及环境烧录进开发板，运行测试用例<br /> | 成功拉起应用。                                               | 否       | 验证通过 |
| swiper设置自定义箭头功能       | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第一个swiper左右两侧各有一个圆形的淡灰色的箭头，swiper内容为“0” | 否       | 验证通过 |
| swiper设置自定义导航点功能     | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第二个swiper左上角有一个被选中为红色未被选中为灰色的导航栏，swiper内容为“0” | 否       | 验证通过 |
| swiper设置自定义数字导航栏功能 | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第三个swiper左上角显示数字导航栏，左侧数字为1/14，其中数字1为红色，14为灰色，swiper内容为“0” | 否       | 验证通过 |
| 基础 Text 样式展示       | 应用加载完成 | 1.查看第一段文本                                         | 1.宽 200vp 高 30vp 带边框，斜体 600 字重，超长跑马灯、不可复制 | 否       | 验证通过 |
| TextInput 输入功能     | 应用加载完成 | 1.点击输入框尝试输入                         | 1.支持输入，第一个样式内联，第二个带清除按钮  | 否       | 验证通过 |

| EmbeddedComponent OnErrorCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model false 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnErrorCallback:        code=100018, name=start_ability_fail, message=Start ui extension ability failed, please check the want of UIextensionAbility.} | 否 | 验证通过 |
| EmbeddedComponent OnTerminatedCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model true 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnTerminatedCallback: code=0} | 否 | 验证通过 |
| 文本无障碍属性设置 | 应用位于首页 | 1.点击首页Accessibility按钮 | 观测Get日志设置属性值与Set函数一致 | 否 | 验证通过 |