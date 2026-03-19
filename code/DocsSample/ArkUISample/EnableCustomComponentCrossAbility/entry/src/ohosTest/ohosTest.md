| 测试功能                          | 预置条件     | 输入                          | 预期输出                                                        | 测试结果 |
|-------------------------------|----------|-----------------------------|-------------------------------------------------------------| ------ |
| 首页加载测试                        | 设备正常运行   | 验证基础元素渲染                    | 检查首页包含"add node to tree"、"remove node from tree"、"start new ability"按钮 | Pass   |
| 创建BuilderNode节点              | 设备正常运行   | 点击"add node to tree"按钮      | BuilderNode节点成功创建并挂载到NodeContainer下，显示自定义组件                 | Pass   |
| 移除BuilderNode节点              | 设备正常运行   | 点击"remove node from tree"按钮 | BuilderNode节点从NodeContainer上移除，但节点未被销毁                     | Pass   |
| 拉起ExtraAbility               | 设备正常运行   | 点击"start new ability"按钮     | 成功拉起ExtraAbility，跳转到ExtraIndex页面                           | Pass   |
| 销毁BuilderNode节点              | 设备正常运行   | 在ExtraIndex页面点击"dispose node"按钮 | BuilderNode节点被销毁，globalBuilderNode变为undefined              | Pass   |
| 跨Ability迁移-挂载组件              | 设备正常运行   | 在ExtraIndex页面点击"add node to tree"按钮 | 之前创建的BuilderNode节点成功挂载到新的NodeContainer下                    | Pass   |
| 跨Ability迁移-状态变量更新            | 设备正常运行   | 点击"change message"按钮        | 状态变量message更新成功，UI正常刷新，@Watch回调被触发                          | Pass   |
| module.json5配置验证              | 设备正常运行   | 检查metadata配置                | metadata中name为enableCustomComponentCrossAbility，value为true | Pass   |
| NodeController功能验证           | 设备正常运行   | 验证MyNodeController          | makeNode、addBuilderNode、removeBuilderNode、disposeNode方法正常工作 | Pass   |

