# CalendarEvent

### 介绍

日程指特定的事件或者活动安排，日程管理即对这些事件、活动进行规划和控制，能更有效地利用相关资源、提高生产力和效率，使人们更好地管理时间和任务。

### 效果预览

![Index](screenshots/index.png)

### 使用说明

1. 创建日历账户。
2. 创建日程。
3. 修改日程。
4. 查询所有日程。
5. 查询指定日程。
6. 删除指定日程。

### 工程目录

```
entry/src/
|---main
|   |---ets
|   |   |---pages
|   |   |   |---Index.ets                          // 首页
|---ohosTest               
|   |---ets
|   |   |---tests
|   |   |   |---Ability.test.ets                   // 自动化测试用例
```

### 具体实现
* 在EntryAbility.ets导入相关模块import { calendarManager } from '@kit.CalendarKit'并初始化全局变量calendarMgr。
* 在index.ets引入全局变量calendarMgr。
* 创建日历账户:调用calendarMgr.createCalendar()创建日历账户对象calendar。
* 创建日程:构建calendarManager.Event类型对象event并配置日程信息，调用calendar.addEvent()并传入event来创建日程。创建成功后保持日程id到eventId。
* 修改日程:构建calendarManager.Event类型对象updateEvent并传入eventId，调用calendar.updateEvent()并传入updateEvent来修改日程。
* 查询所有日程:调用calendar.getEvents()查询所有日程。
* 查询指定日程:通过calendarManager.EventFilter.filterById传入eventId构造查询条件filterId，调用calendar.getEvents()并传入filterId来查询指定日程。
* 删除指定日程:调用calendar.deleteEvent()，并传入eventId来删除指定日程。

### 相关权限

[ohos.permission.READ_CALENDAR](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/permissions-for-all-user#ohospermissionread_calendar)

[ohos.permission.WRITE_CALENDAR](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/permissions-for-all-user#ohospermissionwrite_calendar)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568、PHONE、Tablet。

2.本示例仅支持API20版本SDK，镜像版本号：OpenHarmony 6.0.0.x及之后的版本。

3.本示例需要使用DevEco Studio 6.0.0 release (Build Version: 6.0.0.858)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Calendar/CalendarEvent > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````