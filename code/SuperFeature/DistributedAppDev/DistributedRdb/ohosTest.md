# 分布式关系型数据库测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|	设备正常运行|		|成功拉起应用|Pass|
| 允许权限     | 设备正常运行 | 1、点击权限弹窗允许按钮                | 1、授权后成功进入首页                         |Pass|
| 选择设备弹窗 | 位于首页 | 1、点击**更多**按钮<br/>2、点击**连接设备** | 1、弹出更多菜单<br/>2、弹出选择设备弹窗 |Pass|
| 设置 | 位于首页 | 1、点击**更多**按钮<br/>2、点击设置<br/>3、点击更改同步方式 | 1、弹出更多菜单<br/>2、进入设置页面<br/>3、成功修改同步方式 |Pass|
| 添加联系人 | 位于首页     | 1、点击**添加**按钮<br/>2、输入联系人信息，点击**提交**按钮 | 1、进入添加联系人界面<br/>2、返回首页，成功添加联系人 |Pass|
| 搜索联系人 | 位于首页 | 1、点击**搜索框**<br/>2、输入搜索文本 | 1、进入搜索界面<br/>2、显示搜索到的数据 |Pass|
| 进入和退出多选 | 位于首页 | 1、长按联系人数据<br/>2、点击**退出**按钮 | 1、进入多选状态<br/>2、退出多选状态 |Pass|
| 全选和删除 | 位于首页 | 1、长按联系人数据<br/>2、点击**全选**按钮<br/>3、点击**删除** | 1、进入多选状态<br/>2、全选联系人<br/>3、联系人删除成功，列表为空 |Pass|