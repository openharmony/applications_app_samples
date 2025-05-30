# CalendarViewSwitch年视图 测试用例归档

## 用例表

| 测试功能              | 预置条件            | 输入                                   | 预期输出                    | 是否自动 |测试结果|
|-------------------|-----------------|--------------------------------------|-------------------------|------|--------------|
| 拉起应用              | 	设备正常运行         | 		                                   | 成功拉起应用                  | 否   |Pass|
| 打开应用，弹窗“允许label访问日历？” | 成功拉起应用 | 点击“允许”       | 点击后弹窗消失     | 否  | Pass |
| 点击顶部”年“切换到年视图 | 成功拉起应用 | 点击”年“           | 成功切换到年视图 | 否      | Pass |
| 左滑切换下一年       | 成功切换到年视图 | 在年视图页面中左滑一次                   | 成功切换到下一年        | 否  | Pass |
| 右滑切换上一年 | 成功切换到年视图 | 在年视图页面右滑一次               | 成功切换到上一年 | 否      | Pass |
| 点击顶部”月“切换到月视图 | 成功切换到月视图 | 在月视图页面右滑一次               | 成功切换到上一个月 | 否      | Pass |
| 左滑切换下一个月 | 成功切换到月视图 | 在月视图页面左滑一次               | 成功切换到下一个月 | 否      | Pass |
| 右滑切换上一个月 | 成功切换到月视图 | 在月视图页面右滑一次               | 成功切换到上一个月 | 否      | Pass |
| 在月视图上点击日期，查看选中日期功能 | 成功切换到月视图 | 在月视图上点击本月非当日日期 | 点击的日期显示绿色边框选中效果 | 否      | Pass |
| 在月视图上点击日期，查看选中日期功能 | 成功切换到月视图 | 在月视图上点击当日日期   | 点击的日期显示红底白字 | 否      | Pass |
| 在月视图上点击日期，查看选中日期功能 | 成功切换到月视图 | 在月视图上点击非当月日期  | 切换到对应月 | 否      | Pass |
| 点击顶部”周“切换到周视图 | 成功切换到周视图 | 在周视图页面右滑一次               | 成功切换到上一周 | 否      | Pass |
| 左滑切换下一周 | 成功切换到周视图 | 在周视图页面左滑一次              | 成功切换到下一周 | 否      | Pass |
| 右滑切换上一周 | 成功切换到周视图 | 在周视图页面右滑一次              | 成功切换到上一周 | 否      | Pass |
| 在年视图中点击某个月，自动切换并跳转对应月的月视图 | 成功切换到年视图 | 在年视图中点击任意一个月   | 点击后，成功切换并显示对应月的月视图 | 否      | Pass |
| 在月视图中点击选择一个日期，然后切换到周视图，查看显示对应的周视图 | 成功切换到月视图 | 在月视图中点击选择一个日期，然后切换到周视图 | 周视图显示对应选择日期的周 | 否      | Pass |
| 在周视图中点击选择一个日期，然后切换到月视图，查看显示对应的月视图 | 成功切换到周视图 | 在周视图中点击选择一个日期，然后切换到月视图 | 月视图显示对应选择日期的月 | 否      | Pass |
| 在月视图点击选中一个日期，然后切换到年视图，查看显示对应的年视图 | 成功切换到月视图 | 在月视图点击选中一个日期，然后切换到年视图 | 年视图显示对应选择日期的年 | 否      | Pass |
| 在周视图点击选中一个日期，然后切换到年视图，查看显示对应的年视图 | 成功切换到周视图 | 在周视图点击选中一个日期，然后切换到年视图 | 年视图显示对应选择日期的年 | 否      | Pass |