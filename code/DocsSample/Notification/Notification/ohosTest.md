# Notification 测试用例归档

## 用例表

| 测试功能            | 预置条件       | 输入                    | 预期输出                                                     | 是否自动 | 测试结果 |
| ------------------- | -------------- | ----------------------- | ------------------------------------------------------------ | :------- | -------- |
| 应用请求通知使能    | 设备正常运行   | 点击使能通知            | 底部弹出提示对话框，显示是否允许"Notification"发送通知.点击确认后开启通知权限 | 是       | Pass     |
| 发布设置角标通知    | 已开启通知授权 | 点击设置角标            | 查看角标数量                                                 | 否       | Pass     |
| 发布普通文本通知    | 已开启通知授权 | 点击发布普通文本        | 通知栏显示通知图标，下拉后标题为'test_title',文本内容为'test_text',附加信息为'test_additionalText' | 是       | Pass     |
| 发布长文本类型通知  | 已开启通知授权 | 点击长文本通知          | 通知栏显示通知图标，下拉后文本标题为 test_expandedTitle 文本内容为 test_longText | 是       | Pass     |
| 发布多行文本通知    | 已开启通知授权 | 点击多行文本通知        | 通知栏显示通知图标，下拉后存在文本标题test_longTitle 文本内容为纵向的 'line_01', 'line_02', 'line_03', 'line_04' | 是       | Pass     |
| 发布图片类型通知    | 已开启通知授权 | 点击图片通知            | 通知栏显示通知图标，下拉后文本标题为Test_Title 文本内容 为test_text， 弹窗右侧存在图片 | 是       | Pass     |
| 发布进度条通知      | 已开启通知授权 | 点击发布进度条通知      | 通知栏显示通知图标，下拉后存在文件下载的进度条               | 否       | Pass     |
| 发布公共事件通知    | 已开启通知授权 | 点击发布公共事件通知    | 通知栏显示通知图标，下拉后文本标题 Test_Title 文本内容 test_text | 是       | Pass     |
| 发布启动Ability通知 | 已开启通知授权 | 点击发布启动Ability通知 | 通知栏显示通知图标，下拉后存在文本标题 Test_Title 文本内容 test_text，点击后打开 SecondAbility，并进入 | 是       | Pass     |

