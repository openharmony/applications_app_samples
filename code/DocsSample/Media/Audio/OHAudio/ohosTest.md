# AudioManager 测试用例归档

## 用例表

| 测试功能            | 预置条件          | 输入               | 预期输出                                                               | 是否自动 | 测试结果 |
|-----------------|---------------|------------------|--------------------------------------------------------------------|------|------|
| 拉起应用            | 	设备正常运行       | 		               | 成功拉起应用                                                             | 是    | Pass |
| 允许权限            | 设备正常运行        | 点击权限弹窗允许按钮       | 授权后成功进入首页                                                          | 是    |Pass|
| 主页展示            | 	设备正常运行       | 		               | 展示发声设备查询与选择和音频焦点的入口按钮                                              | 是    | Pass |
| 主页按钮点击          | 	位于主页         | 	点击“录制和播放”       | 	跳转“录制和播放”页面                                                       | 是    | Pass |
| 打开低时延录制         | 录制和播放页面       | 点击低时延录制开关        | 低时延录制按钮变为打开状态                                                      | 是    | pass |
| 开始录制            | 录制和播放页面       | 点击开始录制按钮         | 录制开始，开始录制按钮变为录制中，同时计时展示当前的录制时长，右侧会出现暂停录制按钮                         | 是    | pass |
| 暂停录制            | 录制和播放页面       | 点击暂停录制按钮         | 录制被暂停，时长也停止计时，同时暂停按钮变为继续按钮                                         | 是    | pass |
| 继续录制            | 录制和播放页面       | 点击继续录制按钮         | 继续开始录制，时长在暂停前基础上，继续累增计时，继续按钮又变成暂停按钮                                | 是    | pass |
| 停止录制            | 录制和播放页面       | 点击停止录制按钮         | 录制按钮变为不可点击状态，低时延录制开关变为不可点击状态，计时消失，暂停按钮也消失，同时界面中增加低时延播放开关和一条录音音频播放器 | 是    | pass |
| 打开低时延播放         | 录制和播放页面       | 点击低时延播放开关        | 低时延播放按钮变为打开状态                                                      | 是    | pass |
| 播放录音数据          | 录制和播放页面       | 点击播放器的播放按钮       | 播放按钮变成了暂停按钮，同时会播放上述步骤所采集的录音数据                                      | 是    | pass |
| 暂停播放音频          | 录制和播放页面       | 点击播放器的暂停按钮       | 暂停按钮变成播放按钮，同时停止播放                                                  | 是    | pass |
| 继续播放录音数据        | 录制和播放页面       | 点击播放器的播放按钮       | 播放按钮变成了暂停按钮，同时会播放上述步骤所采集的录音数据                                      | 是    | pass |
| 暂停播放音频          | 录制和播放页面       | 点击播放器的暂停按钮       | 暂停按钮变成播放按钮，同时停止播放                                                  | 是    | pass |
| 返回主页            | 录制和播放页面       | 点击返回按钮           | 返回到主页面                                                             | 是    | pass |
| 进入Audiovivid播放页 | 位于主页          | 点击Audiovivid播放卡片 | 进入Audiovivid播放页                                                    | 是    | pass |
| 播放普通音乐          | Audiovivid播放页 | 点击播放按钮           | 播放普通格式音乐                                                           | 是    | pass |
| 暂停普通音乐          | Audiovivid播放页 | 点击暂停按钮           | 暂停普通格式音乐                                                           | 是    | pass |
| 播放Audiovivid音乐          | Audiovivid播放页 | 点击播放按钮           | 播放Audiovivid格式音乐                                                           | 是    | pass |
| 暂停Audiovivid音乐          | Audiovivid播放页 | 点击暂停按钮           | 暂停Audiovivid格式音乐                                                           | 是    | pass |
| 返回主页            | Audiovivid播放页       | 点击返回按钮           | 返回到主页面                                                             | 是    | pass |


