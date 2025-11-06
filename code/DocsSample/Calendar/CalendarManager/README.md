# CalendarManager

### 介绍

日历账户‌用于存储和管理个人或团队的日程，通过日历账户，用户可以方便地查看、编辑和共享日程信息。

日历管理器[CalendarManager](../reference/apis-calendar-kit/js-apis-calendarManager.md#calendarmanager)用于管理日历账户[Calendar](../reference/apis-calendar-kit/js-apis-calendarManager.md#calendar)。日历账户主要包含账户信息[CalendarAccount](../reference/apis-calendar-kit/js-apis-calendarManager.md#calendaraccount)和配置信息[CalendarConfig](../reference/apis-calendar-kit/js-apis-calendarManager.md#calendarconfig)。

开发者可以创建属于应用特有的日历账户，还可以对日历账户进行新增、删除、更新和查询。此外，每个日程[Event](../reference/apis-calendar-kit/js-apis-calendarManager.md#event)归属于某一个特定的日历账户，可以通过日历账户对该账户下面的日程进行管理，具体相关指导可见[日程管理](calendarmanager-event-developer.md)。

### 效果预览

![Index](screenshots/index.png)

### 使用说明

1. 创建日历账户对象。
2. 设置日历配置信息。
3. 查询指定日历账户。
4. 查询默认日历账户。
5. 查询所有日历账户。
6. 删除指定日历账户。

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
* 创建日历账户对象:调用calendarMgr.createCalendar()创建日历账户。
* 设置日历配置信息:调用calendarMgr.getCalendar()获取刚刚创建的日历账户对象data，调用data.setConfig()设置日历配置信息。
* 查询指定日历账户:调用calendarMgr.getCalendar()，传入对应日历账户，查询指定日历账户。
* 查询默认日历账户:调用calendarMgr.getCalendar()查询默认日历账户。
* 查询所有日历账户:调用calendarMgr.getCalendars()查询所有日历账户。
* 删除指定日历账户:调用calendarMgr.deleteCalendar()，传入对应日历账户来删除日历对象。

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
echo code/DocsSample/Calendar/CalendarManager > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````