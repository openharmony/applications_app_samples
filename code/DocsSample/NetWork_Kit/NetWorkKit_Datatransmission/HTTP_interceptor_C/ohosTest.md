# 测试用例归档

## 用例表

| 测试功能          | 预置条件     | 输入                                                         | 预期输出                                            | 是否自动 | 测试结果 |
| ----------------- | ------------ | ------------------------------------------------------------ | --------------------------------------------------- | -------- | -------- |
| 添加只读响应拦截器     | 设备正常运行 | 点击“Add ReadOnly Response Interceptor”按钮                           | 日志输出“AddReadOnlyResponseInterceptor ret: 0”，表示成功添加拦截器 | 是       | pass     |
| 移除只读响应拦截器        | 设备正常运行 | 点击“Remove ReadOnly Response Interceptor”按钮                                | 日志输出“RemoveReadOnlyResponseInterceptor ret: 0”，表示成功移除拦截器 | 是       | pass     |
| 启用只读响应拦截器        | 设备正常运行 | 点击“Start ReadOnly Response Interceptors”按钮                                | 日志输出“StartReadOnlyResponseInterceptors ret: 0”，表示成功启用拦截器 | 是       | pass     |
| 停用只读响应拦截器        | 设备正常运行 | 点击“Stop ReadOnly Response Interceptors”按钮                                 | 日志输出“StopReadOnlyResponseInterceptors ret: 0”，表示成功停用拦截器 | 是       | pass     |
| 移除所有只读响应拦截器     | 设备正常运行 | 点击“Remove All ReadOnly Response Interceptors”按钮                           | 日志输出“RemoveAllReadOnlyResponseInterceptors ret: 0”，表示成功移除所有只读响应拦截器 | 是       | pass     |
| 发送HTTP请求       | 设备正常运行 | 点击“Send HTTP Request”按钮                                | 日志输出Http响应信息，表示拦截器工作正常 | 是       | pass     |
| 添加可修改请求拦截器     | 设备正常运行 | 点击“Add Modify Request Interceptor”按钮                           | 日志输出“AddModifyRequestInterceptor ret: 0”，表示成功添加可修改请求拦截器 | 是       | pass     |
| 启用可修改请求拦截器组        | 设备正常运行 | 点击“Start Modify Request Interceptors”按钮                                | 日志输出“StartModifyRequestInterceptors ret: 0”，表示成功启用可修改请求拦截器组 | 是       | pass     |
| 停用可修改请求拦截器组        | 设备正常运行 | 点击“Stop Modify Request Interceptors”按钮                                 | 日志输出“StopModifyRequestInterceptors ret: 0”，表示成功停用可修改请求拦截器组 | 是       | pass     |
| 移除可修改请求拦截器     | 设备正常运行 | 点击“Remove Modify Request Interceptor”按钮                           | 日志输出“RemoveModifyRequestInterceptor ret: 0”，表示成功移除可修改请求拦截器 | 是       | pass     |
| 移除所有可修改请求拦截器        | 设备正常运行 | 点击“Remove All Modify Request Interceptors”按钮                                | 日志输出“RemoveAllModifyRequestInterceptors ret: 0”，表示成功移除所有可修改请求拦截器 | 是       | pass     |
| 添加可修改响应拦截器     | 设备正常运行 | 点击“Add Modify Response Interceptor”按钮                           | 日志输出“AddModifyResponseInterceptor ret: 0”，表示成功添加可修改响应拦截器 | 是       | pass     |
| 启用可修改响应拦截器组        | 设备正常运行 | 点击“Start Modify Response Interceptors”按钮                                | 日志输出“StartModifyResponseInterceptors ret: 0”，表示成功启用可修改响应拦截器组 | 是       | pass     |
| 停用可修改响应拦截器组        | 设备正常运行 | 点击“Stop Modify Response Interceptors”按钮                                 | 日志输出“StopModifyResponseInterceptors ret: 0”，表示成功停用可修改响应拦截器组 | 是       | pass     |
| 移除可修改响应拦截器     | 设备正常运行 | 点击“Remove Modify Response Interceptor”按钮                           | 日志输出“RemoveModifyResponseInterceptor ret: 0”，表示成功移除可修改响应拦截器 | 是       | pass     |
| 移除所有可修改响应拦截器        | 设备正常运行 | 点击“Remove All Modify Response Interceptors”按钮                                | 日志输出“RemoveAllModifyResponseInterceptors ret: 0”，表示成功移除所有可修改响应拦截器 | 是       | pass     |
| 测试可修改拦截器功能        | 设备正常运行 | 先添加并启用请求和可修改响应拦截器，然后点击“Send HTTP Request”按钮 | 日志输出请求和响应修改前后的对比信息，表示可修改拦截器工作正常 | 是       | pass     |
