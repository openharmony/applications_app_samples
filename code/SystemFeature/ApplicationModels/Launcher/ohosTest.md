# FileManager 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|不同页面的滑动切换| 位于Launcher第一页 | 向左与向右滑动 |回到Launcher第一页|是|Pass|
|添加服务卡片| 已安装相机应用 | 长按相机图标，在弹出的菜单中，点击“服务卡片” |将相机服务卡片添加到Launcher|是|Pass|
|卸载预置应用| 已安装相机应用 | 长按相机图标，在弹出的菜单中，点击“卸载” | 弹出确认卸载弹框，卸载按钮正常点击 |是|Pass|
|通过Launcher打开不同应用| 位于Launcher第一页 | 点击不同应用的图标 | 正常打开对应的应用 |是|Pass|
|清除近期任务| 位于Launcher第一页 | 在Launcher空白处上滑，点击底部清理图标 | 近期任务列表被成功清除 |是|Pass|
|启动上一次的组件实例 | 已安装startRecent应用 | 点击应用图标打开应用，点击home键，再次点击应用图标 | 把上次打开的Ability实例拉到前台，不会新建Ability实例 |是|Pass|
|启动上一次的组件实例 | 已安装startRecent应用 | 长按应用图标打开菜单，点击“打开”启动应用，点击home键，再次长按应用图标打开菜单，点击“打开” | 将上次打开的Ability实例拉到前台，不会新建Ability实例 |是|Pass|
|启动上一次的主组件实例 | 已安装startRecent应用 | 点击应用图标，点击EntryAbility中的"StartSingletonAbility"按钮，点击home键，再次点击应用图标 | 将上次打开的EntryAbility实例拉到前台，不会新建Ability实例，不会打开SecondAbility |是|Pass|
|跨任务链返回 | 已安装crossChain应用 | 点击应用图标，点击按钮打开SecondAbility，点击back键 | 返回到EntryAbility上，而不是返回桌面 |是|Pass|