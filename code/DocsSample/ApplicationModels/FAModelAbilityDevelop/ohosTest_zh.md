# FAModelAbilityDevelop测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|设备正常运行| 点击应用图标 |成功拉起应用|是|Pass|
|PageAbility组件开发指导-单设备|进入首页| 点击[PageAbility组件开发指导-单设备] |’PageAbility组件开发指导-单设备‘界面正常展示|是|Pass|
|获取分布式目录|进入’PageAbility组件开发指导-单设备‘界面|点击[获取分布式目录]|弹出toast[/data/***]|是|Pass|
|启动单例PageAbility指定页面|进入’PageAbility组件开发指导-单设备‘界面|点击[启动单例PageAbility]<br />再点击Home键回到桌面<br />再点击应用图标回到’PageAbility组件开发指导-单设备‘界面<br />点击[再启动单例PageAbility]|点击[启动单例PageAbility]后跳转至Title为’PageAbilitySingleton页面一‘的页面<br />点击[再启动单例PageAbility]后跳转至Title为’PageAbilitySingleton页面二‘的页面<br />|是|Pass|
|启动多例PageAbility指定页面|进入’PageAbility组件开发指导-单设备‘界面|点击[启动多例PageAbility页面一]<br />再点击Home键回到桌面<br />再点击应用图标回到’PageAbility组件开发指导-单设备‘界面<br />点击[启动多例PageAbility页面二]|点击[启动多例PageAbility页面一]后跳转至Title为’PageAbilityStandard页面一‘的页面<br />点击[启动多例PageAbility页面二]后跳转至Title为’PageAbilityStandard页面二‘的页面<br />|是|Pass|
|使用worker进行线程间通信|进入’PageAbility组件开发指导-单设备‘界面|点击[使用Worker进行线程间通信]|弹出toast[{"data":"message from worker thread."}]|是|Pass|
| 停止PageAbility | 进入’PageAbility组件开发指导-单设备‘界面 | 点击[停止PageAbility]                                  | 退出当前应用返回桌面                                         |是|Pass|
| PageAbility组件开发指导-多设备 | 进入首页且已设置README中依赖项内容 | 点击[PageAbility组件开发指导-多设备]<br />再点击[获取分布式数据同步权限]，并在弹出的申请权限对话框中点击’允许‘，再点击[获取设备id]<br />再点击[启动远程设备PageAbility] | 'PageAbility组件开发指导-多设备’界面正常展示<br />弹出toast，内容为对端设备的deviceId<br />弹出toast[启动远程Ability成功]，同时打开对端设备音乐应用 |否|Pass|
| ServiceAbility组件开发指导                | 进入首页                                                     | 点击[ServiceAbility组件开发指导]                       | ’ServiceAbility组件开发指导‘界面正常展示                     |是|Pass|
| 创建ServiceAbility                        | 进入’ServiceAbility组件开发指导‘界面                         | 点击[启动ServiceAbility]                             | 弹出toast[启动serviceAbility成功] |是|Pass|
| 连接ServiceAbility                        | 进入’ServiceAbility组件开发指导‘界面                         | 点击[连接ServiceAbility]                               | 弹出toast[连接serviceAbility成功]          |是|Pass|
| 连接错误的ServiceAbility                  | 进入’ServiceAbility组件开发指导‘界面                         | 点击[连接错误的ServiceAbility]                         | 弹出toast[连接serviceAbility失败]          |是|Pass|
|DataAbility组件开发指导|进入首页|点击[DataAbility组件开发指导]并在弹出的对话框中点击’允许‘|’DataAbility组件开发指导‘界面正常展示且弹出是否允许申请权限的对话框|是|Pass|
| 插入数据                                  | 进入’DataAbility组件开发指导‘界面’且允许当前应用访问通讯录   | 点击[插入数据-callback方式]<br />再点击[插入数据-promise方式] | 点击后均弹出toast[插入数据成功]                        |是|Pass|
| 删除数据                                  | 进入’DataAbility组件开发指导‘界面’且允许当前应用访问通讯录   | 点击[删除数据-callback方式]<br />再点击[删除数据-promise方式] | 点击后均弹出toast[删除数据成功]                        |是|Pass|
| 更新数据                                  | 进入’DataAbility组件开发指导‘界面’且允许当前应用访问通讯录   | 点击[更新数据-callback方式]<br />再点击[更新数据-promise方式] | 点击后均弹出toast[更新数据成功]                        |是|Pass|
| 查找数据                                  | 进入’DataAbility组件开发指导‘界面’且允许当前应用访问通讯录   | 点击[查找数据-callback方式]<br />再点击[查找数据-promise方式] | 点击后均弹出toast[查找数据成功]                        | 是    | Pass     |
| 批量插入数据                              | 进入’DataAbility组件开发指导‘界面’且允许当前应用访问通讯录   | 点击[批量插入数据-callback方式]<br />再点击[批量插入数据-promise方式] | 点击后均弹出toast[批量插入数据成功]                    | 是    | Pass     |
| 批量处理数据                              | 进入’DataAbility组件开发指导‘界面’且允许当前应用访问通讯录   | 点击[批量处理数据-callback方式]<br />再点击[批量处理数据-promise方式] | 点击后均弹出toast[批量处理数据成功]                    | 是    | Pass     |
| FA模型与Stage模型应用组件互通指导         | 进入首页                                                     | 点击[FA模型与Stage模型应用组件互通指导]                | ’FA模型与Stage模型应用组件互通指导‘界面正常展示              | 是    | Pass     |
| 通过PageAbility启动UIAbility-无需返回结果 | 进入’FA模型与Stage模型应用组件互通指导‘界面                  | 点击[通过PageAbility启动UIAbility-无需返回结果]       | 成功启动时钟应用                                             | 是    | Pass     |
| 通过PageAbility启动UIAbility-返回执行结果 | 进入’FA模型与Stage模型应用组件互通指导‘界面                  | 点击[通过PageAbility启动UIAbility-返回执行结果]        | 成功启动时钟应用                                             | 是    | Pass     |
| 通过ServiceAbility启动UIAbility           | 进入’FA模型与Stage模型应用组件互通指导‘界面                  | 点击[通过ServiceAbility启动UIAbility]                  | 成功启动时钟应用                                             | 是    | Pass     |
| 添加服务卡片 | 回到桌面 | 长按应用图标，在弹出框中点击服务卡片，进入服务卡片添加界面，点击添加至桌面 | 跳转会桌面，并桌面上新增FAModel服务卡片 | 是       | Pass |
| 卡片跳转事件触发 | 已成功添加服务卡片 | 点击卡片内‘titleOnCreate' | 跳转至应用界面 | 是 | Pass |
| 卡片更新事件触发 | 已成功添加服务卡片 | 点击卡片内‘detailOnCreate' | 卡片内容会更新 | 是 | Pass |

