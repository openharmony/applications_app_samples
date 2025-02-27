# FileUriDevelopment_C 测试用例归档

## 用例表

| 测试功能                           | 预置条件           | 输入 | 预期输出                                 | 是否自动 | 测试结果 |
| ---------------------------------- | ------------------ | ---- | ---------------------------------------- | -------- | -------- |
| 拉起应用                           | 设备正常运行       |      | 成功拉起应用                             | 是       | Pass     |
| 调用OH_FileUri_GetUriFromPath      | 安装应用，进入首页 |      | 获取到的URI输出到应用页面文本框内        | 是       | Pass     |
| 调用OH_FileUri_GetPathFromUri      | 安装应用，进入首页 |      | 获取到的PATH输出到应用页面文本框内       | 是       | Pass     |
| 调用OH_FileUri_GetFullDirectoryUri | 安装应用，进入首页 |      | 获取URI所在路径的URI输出到应用页面文本框 | 是       | Pass     |
| 调用OH_FileUri_IsValidUri          | 安装应用，进入首页 |      | 将URI判断结果输出到应用页面文本框        | 是       | Pass     |
| 调用OH_FileUri_GetFileName         | 安装应用，进入首页 |      | 获取URI中的文件名称输出到应用页面文本框  | 是       | Pass     |

