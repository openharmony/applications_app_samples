# FormExtAbility 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|关闭应用|应用正常启动|根据坐标点击屏幕上的返回按钮|应用返回到桌面|是|Pass|
|打开服务列表|桌面存在app|长按app|应用弹出服务列表，其中存在服务卡片选项|是|Pass|
|打开卡片列表|服务列表正常显示|点击服务卡片选项|进入卡片列表页面，底部存在“添加到桌面”按钮|是|Pass|
|添加卡片|进入卡片列表页面|点击“添加到桌面”|页面中存在名为eTSFormExtAbility的卡片|是|Pass|
|在仿桌面应用里添加卡片| 安装Launcher与卡片应用 | 长按卡片应用图标，在弹出菜单中点击“服务卡片”，点击“添加卡片到桌面“ | 成功添加一张ArkTs卡片到仿桌面 |是|Pass|
|在仿桌面应用里添加卡片| 安装Launcher与卡片应用 | 长按卡片应用图标，在弹出菜单中点击“服务卡片”，向左滑动打开第二张服务卡片添加页面，点击“添加卡片到桌面“ | 成功添加一张Js卡片到仿桌面 |是|Pass|
|在仿桌面应用里添加卡片| 安装Launcher与FormProvider应用 | 长按FormProvider应用图标，在弹出菜单中点击“服务卡片”，点击“添加卡片到桌面“ | 成功添加一张ArkTs卡片到仿桌面 |是|Pass|
|在仿桌面应用里添加卡片| 安装Launcher与FormProvider应用 | 长按FormProvider应用图标，在弹出菜单中点击“服务卡片”，向左滑动打开第二张服务卡片添加页面，点击“添加卡片到桌面“ | 成功添加一张Js卡片到仿桌面 |是|Pass|
|在仿桌面应用里删除卡片| 安装Launcher与卡片应用 | 长按已添加在桌面的ArkTs卡片，在弹出菜单中选择”移除“，在弹出的弹窗中选择”移除” | 一张应用的ArkTs卡片从仿桌面移除 |是|Pass|
|在仿桌面应用里删除卡片| 安装Launcher与卡片应用 | 长按已添加在桌面的Js卡片，在弹出菜单中选择”移除“，在弹出的弹窗中选择”移除” | 一张应用的Js卡片从仿桌面移除 |是|Pass|
|在仿桌面应用里删除卡片| 安装Launcher与FormProvider应用 | 长按已添加在桌面的ArkTs卡片，在弹出菜单中选择”移除“，在弹出的弹窗中选择”移除” | 一张应用的ArkTs卡片从仿桌面移除 |是|Pass|
|在仿桌面应用里删除卡片| 安装Launcher与FormProvider应用 | 长按已添加在桌面的Js卡片，在弹出菜单中选择”移除“，在弹出的弹窗中选择”移除” | 一张应用的Js卡片从仿桌面移除 |是|Pass|
|通过push更新卡片| 仿桌面上已有一张卡片应用的Js卡片 | 点击卡片应用图标，点击“修改发布数据”按钮，点击温度输入框，删除原有数据，并输入‘0’，点击“发布数据”按钮，点击Home键 |数据发布页面下方卡片使用方信息正确，launcher桌面上的卡片内容刷新，温度从-30°C显示为0°C|否|Pass|
|通过push更新卡片| 安装Launcher与卡片应用 | 点击卡片应用图标，点击“修改发布数据”按钮，点击温度输入框，删除原有数据，并输入‘0’，点击“发布数据”按钮，点击Home键 |数据发布页面下方卡片使用方信息正确，launcher桌面上的卡片内容刷新，温度从-30°C显示为0°C|否|Pass|
|在仿桌面应用里刷新卡片 | 仿桌面上已有一张卡片应用的Js卡片 | 点击卡片应用图标，点击“修改发布数据”按钮，点击输入框修改温度数据，如0°C，点击“发布数据”，立刻在控制台执行命令“aa dump -a”，点击Home键返回桌面 | Js卡片中温度数据更新为0°C，Js卡片提供方应用没有被拉起 |否|Pass|
|在仿桌面应用里刷新卡片 | 仿桌面上已有一张卡片应用的ArkTs卡片 | 点击卡片应用图标，点击“修改发布数据”按钮，点击输入框修改温度数据，如9°C，点击“发布数据”，立刻在控制台执行命令“aa dump -a”，点击Home键返回桌面 | ArkTs卡片中温度数据更新为9°C，ArkTs卡片提供方应用没有被拉起 |否|Pass|
|在仿桌面应用里刷新卡片 | 仿桌面上已有一张FormProvider应用的Js卡片 | 点击FormProvider应用图标，点击“修改发布数据”按钮，点击输入框修改温度数据，如0°C，点击“发布数据”，立刻在控制台执行命令“aa dump -a”，点击Home键返回桌面 | Js卡片中温度数据更新为0°C，Js卡片提供方应用没有被拉起 |否|Pass|
|在仿桌面应用里刷新卡片 | 仿桌面上已有一张FormProvider应用的ArkTs卡片 | 点击FormProvider应用图标，点击“修改发布数据”按钮，点击输入框修改温度数据，如9°C，点击“发布数据”，立刻在控制台执行命令“aa dump -a”，点击Home键返回桌面 | ArkTs卡片中温度数据更新为9°C，ArkTs卡片提供方应用没有被拉起 |否|Pass|
|在应用中设置订阅条件 | 仿桌面上已有一张卡片应用的Js卡片 | 点击卡片应用图标，点击"修改订阅条件"，选择城市”杭州“，点击Back键返回；点击“修改发布数据”按钮，选择城市”杭州“，点击“发布数据”，点击Home键返回桌面 | Js卡片中城市信息从”沈阳“更新为”杭州“ |否|Pass|
|在应用中设置订阅条件 | 仿桌面上已有一张卡片应用的ArkTs卡片 | 点击卡片应用图标，点击"修改订阅条件"，选择城市”杭州“，点击Back键返回；点击“修改发布数据”按钮，选择城市”杭州“，点击“发布数据”，点击Home键返回桌面 | ArkTs卡片中城市信息从”沈阳“更新为”杭州“ |否|Pass|
|在应用中设置订阅条件 | 仿桌面上已有一张FormProvider应用的Js卡片 | 点击FormProvider应用图标，点击"修改订阅条件"，选择城市”杭州“，点击Back键返回；点击“修改发布数据”按钮，选择城市”杭州“，点击“发布数据”，点击Home键返回桌面 | Js卡片中城市信息从”沈阳“更新为”杭州“ |否|Pass|
|在应用中设置订阅条件 | 仿桌面上已有一张FormProvider应用的ArkTs卡片 | 点击FormProvider应用图标，点击"修改订阅条件"，选择城市”杭州“，点击Back键返回；点击“修改发布数据”按钮，选择城市”杭州“，点击“发布数据”，点击Home键返回桌面 | ArkTs卡片中城市信息从”沈阳“更新为”杭州“ |否|Pass|