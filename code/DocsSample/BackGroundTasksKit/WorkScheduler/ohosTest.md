# WorkScheduler 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|测试结果|
|---|---|---|---|---|
|打开应用|设备正常运行| |正常拉起WorkScheduler|Pass|
|申请延迟任务|应用已连接过可用wifi|点击申请延迟任务|有日志"startWork success"|Pass|
|延迟任务回调|应用已连接过可用wifi|点击申请延迟任务</br>应用退后台|有日志"WorkSchedulerAbility start"|Pass|
|取消延迟任务|应用已连接过可用wifi|点击取消延迟任务|有日志"stopWork success"|Pass|