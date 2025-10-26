# 按键拦截监听（ArkTS）

## 用例表

| 测试功能         | 预置条件           | 输入                                          | 预期输出                                                         | 是否自动 | 测试结果 |
|--------------|----------------|---------------------------------------------|--------------------------------------------------------------|------|------|
| 拉起应用         | 设备正常运行         |                                             | 成功拉起应用                                                       | 是    | Pass |
| 音量上键按键事件拦截监听 | 音量上键按键事件拦截监听开启 | 点击音量上键                                      | 弹窗显示**点击了音量键上**，音量不被调节                                       | 否    | Pass |
| 音量下键按键事件拦截监听 | 音量下键按键事件拦截监听开启 | 点击音量下键                                      | 弹窗显示**点击了音量键下**，音量不被调节                                       | 否    | Pass |
| 取消音量上键的拦截监听  | 音量上键按键事件拦截监听开启 | 点击**Remove monitoring for Volume Up key**   | 弹窗显示**Successfully removed monitoring for Volume UP key!**   | 是    | Pass |
| 取消音量下键的拦截监听  | 音量下键按键事件拦截监听开启 | 点击**Remove monitoring for Volume Down key** | 弹窗显示**Successfully removed monitoring for Volume Down key!** | 是    | Pass |
| 取消音量上键拦截监听   | 已取消音量上键的拦截监听   | 点击音量上键                                      | 无弹窗，音量增加                                                     | 否    | Pass |
| 取消音量下键拦截监听   | 已取消音量下键的拦截监听   | 点击音量下键                                      | 无弹窗，音量减小                                                     | 否    | Pass |
| 添加音量上键的拦截监听  | 无              | 点击**Add monitoring for Volume Up key**      | 弹窗显示**Successfully added monitoring for Volume UP key!**     | 是    | Pass |
| 添加音量下键的拦截监听  | 无              | 点击**Add monitoring for Volume Down key**    | 弹窗显示**Successfully added monitoring for Volume Down key!**   | 是    | Pass |

