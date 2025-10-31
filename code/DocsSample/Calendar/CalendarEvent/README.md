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
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````