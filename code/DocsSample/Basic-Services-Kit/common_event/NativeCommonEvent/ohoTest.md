# CommonEventPublish 测试用例归档
## 用例表


| 测试功能               | 预置条件       | 输入                                                                                                                     | 预期输出 | 是否自动 | 测试结果 |
|--------------------| -------------- |------------------------------------------------------------------------------------------------------------------------|------| :------- | -------- |
| 创建订阅者信息        | 设备正常运行   | 1.调用createSubscribeInfo方法<br/>2.通过OH_CommonEvent_CreateSubscribeInfo创建订阅者信息。<br/>                                      | true | 是 | Pass |
| 销毁订阅者信息       | 设备正常运行   | 1.调用destroySubscribeInfo方法<br/>2.通过OH_CommonEvent_DestroySubscribeInfo销毁订阅者信息。<br/>                                    | true | 是 | Pass |
| 创建订阅者          | 设备正常运行   | 1.调用createSubscriber方法<br/>2.创建订阅者时需传入公共事件的回调函数CommonEvent_ReceiveCallback。待事件发布时，订阅者会接收到回调数据CommonEvent_RcvData。<br/> | true | 是 | Pass |
| 订阅事件        | 设备正常运行   | 1.先创建订阅信息和订阅者<br/>2.然后通过OH_CommonEvent_Subscribe订阅事件<br/>                                                              | true | 是 | Pass |
| 发布公共事件         | 设备正常运行   | 1.调用publish方法<br/>2.通过OH_CommonEvent_Publish发布不携带信息的公共事件<br/>                                                          | true | 是 | Pass |
| 创建时带入公共事件属性对象    | 设备正常运行   | 1.调用publishWithInfo方法<br/>2.通过OH_CommonEvent_PublishWithInfo发布携带信息的公共事件<br/>                                           | true | 是 | Pass |
| 创建订阅信息、订阅者并订阅、取消订阅 | 设备正常运行   | 1.先创建订阅信息、订阅者并订阅<br/>2.然后调用OH_CommonEvent_UnSubscribe取消订阅<br/>                                                         | true | 是 | Pass |
| 验证自定义公共事件的完整生命周期流程，包括订阅信息的创建和管理、订阅者的创建和销毁、事件的订阅和取消、事件的发布等完整流程。   | 设备正常运行   | 1.创建订阅信息对象<br/>2.基于订阅信息创建订阅者<br/>3.订阅指定的公共事件<br/>4.发布对应的公共事件<br/> 5.取消事件订阅<br/>6.销毁订阅者对象<br/>7.销毁订阅信息对象<br/>        |  每个步骤都成功执行并返回true，整个流程顺利完成，无异常抛出。 | 是 | Pass |
