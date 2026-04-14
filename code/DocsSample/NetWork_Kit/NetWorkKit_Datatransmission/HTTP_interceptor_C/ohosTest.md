# 测试用例归档

## 用例表

| 测试功能          | 预置条件     | 输入                                                         | 预期输出                                            | 是否自动 | 测试结果 |
| ----------------- | ------------ | ------------------------------------------------------------ | --------------------------------------------------- | -------- | -------- |
| 添加响应拦截器     | 设备正常运行 | 点击“Add Response Interceptor”按钮                           | 日志输出“AddResponseInterceptor ret: 0”，表示成功添加拦截器 | 是       | pass     |
| 移除拦截器        | 设备正常运行 | 点击“Remove Interceptor”按钮                                | 日志输出“RemoveInterceptor ret: 0”，表示成功移除拦截器 | 是       | pass     |
| 启用拦截器        | 设备正常运行 | 点击“Start Interceptors”按钮                                | 日志输出“StartInterceptors ret: 0”，表示成功启用拦截器 | 是       | pass     |
| 停用拦截器        | 设备正常运行 | 点击“Stop Interceptors”按钮                                 | 日志输出“StopInterceptors ret: 0”，表示成功停用拦截器 | 是       | pass     |
| 移除所有拦截器     | 设备正常运行 | 点击“Remove All Interceptors”按钮                           | 日志输出“RemoveAllInterceptors ret: 0”，表示成功移除所有拦截器 | 是       | pass     |
| 发送HTTP请求       | 设备正常运行 | 点击“Send HTTP Request”按钮                                | 日志输出Http响应信息，表示拦截器工作正常 | 是       | pass     |
