# Weather 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|	设备正常运行|		|成功拉起应用|Pass|
|侧边栏隐藏和显示| 位于首页、侧边栏显示状态 | 1、判断当前断点是lg<br>2、点击**侧边栏控制按钮**隐藏侧边栏<br>3、点击**侧边栏控制按钮**显示侧边栏 |1、是lg开始执行侧边栏下面的用例，否则用例结束<br>2、侧边栏隐藏<br>3、侧边栏显示|Pass|
|侧边栏点击切换当前城市| 位于首页、侧边栏显示状态 | 1、侧边栏中点击城市切换城市<br/>2、点击侧边栏中控制按钮隐藏侧边栏 |1、切换城市成功<br>2、侧边栏隐藏||
| 主页切换城市 | 位于首页 | 1、注入左右滑动事件，左右滑动界面 | 1、滑动成功切换当前城市信息<br> |Pass|
| 主页上下滑动 | 位于首页 | 1、主页下滑到顶部<br>2、上滑到顶部 | 1、上下滑动后显示正常，可以查询到底部和顶部组件 ||
| 更新间隔弹窗 | 位于首页 | 1、点击左上角**更多**按钮<br>2、点击**更新间隔**<br/>3、点击**取消** | 1、弹出菜单<br/>2、弹出更新间隔弹窗<br/>3、弹窗消失 |Pass|
|城市管理| 位于首页 | 1、点击左上角**更多**按钮<br/>2、点击**城市管理** | 1、弹出菜单<br>2、进入城市管理页面，显示默认的两个城市 |Pass|
| 添加城市 | 位于城市管理页面 | 1、点击**添加城市**<br/>2、点击**武汉** | 1、进入添加城市页面<br/>2、返回城市管理页面，武汉添加成功 |Pass|

