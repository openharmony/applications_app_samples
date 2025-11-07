# DomainAccount 测试用例归档

## 用例表

| 测试功能                                    | 预置条件                                  | 输入             | 预期输出                                                                                                | 是否自动 | 测试结果 |
|-----------------------------------------|---------------------------------------|----------------|-----------------------------------------------------------------------------------------------------| -------- | -------- |
| 拉起应用                                    | 设备正常运行                                |                | 成功拉起应用                                                                                              | 是       | Pass     |
| 弹出 允许“CalendarManager”读取和修改你的日程？ 权限申请弹框 | 位于CalendarManager页面                   | 点击‘允许’         |                                                                                                     | 是       | Pass     |
| 1，创建日历账户对象                              | 位于CalendarManager页面        | 点击‘1，创建日历账户对象’ | 成功创建日历账户。<br/>日历应用打开侧边栏，新增了‘MyCalendar’账户 ![CreateCalendar](screenshots/createCalendar.png)         | 是       | Pass     |
| 2，设置日历配置信息                              | 位于CalendarManager页面        | 点击‘2，设置日历配置信息’ | 成功设置日历配置信息。<br/>观察日志打印 Succeeded in setting config, data->{"enableReminder":true,"color":"#aabbcc"} | 是       | Pass     |
| 3，查询指定日历账户                              | 位于CalendarManager页面        | 点击‘3，查询指定日历账户’ | 成功查询指定日历账户。<br/>观察日志打印 Succeeded in getting calendar, data -> {"id":xx}                             | 是       | Pass     |
| 4，查询默认日历账户                              | 位于CalendarManager页面        | 点击‘4，查询默认日历账户’ | 成功查询默认日历账户。<br/>观察日志打印 Succeeded in getting calendar, data -> {"id":xx}                             | 是       | Pass     |
| 5，查询所有日历账户                              | 位于CalendarManager页面 | 点击‘5，查询所有日历账户’ | 成功查询所有日历账户。<br/>观察日志打印 Succeeded in getting all calendars, data -> [{"id":1},{"id":xx}]             | 是       | Pass     |
| 6，删除指定日历账户                              | 位于CalendarManager页面 | 点击‘6，删除指定日历账户’ | 成功删除MyCalendar日历账户，日历应用MyCalendar账户已删除。<br/>观察日志打印 Succeeded in deleting calendar                             | 是       | Pass     |