# 密钥加解密测试用例归档

## 用例表

| 测试功能                            | 预置条件     | 输入 | 预期输出           | 是否自动 | 测试结果 |
| ----------------------------------- | ------------ | ---- | ------------------ | -------- | -------- |
| 拉起应用                            | 设备正常运行 |      | 成功拉起应用       | 是       | Pass     |
| 点击按钮，加解密AES/CBC/PKCS7       | 成功拉起应用 |      | 成功执行，输出日志 | 是       | Pass     |
| 点击按钮，加解密AES/GCM/NoPadding   | 成功拉起应用 |      | 成功执行，输出日志 | 是       | Pass     |
| 点击按钮，加解密RSA/ECB/PKCS1_V1_5  | 成功拉起应用 |      | 成功执行，输出日志 | 是       | Pass     |
| 点击按钮，加解密RSA/ECB/OAEP/SHA256 | 成功拉起应用 |      | 成功执行，输出日志 | 是       | Pass     |
| 点击按钮，加解密SM2                 | 成功拉起应用 |      | 成功执行，输出日志 | 是       | Pass     |
| 点击按钮，加解密C/C++               | 成功拉起应用 |      | 成功执行，输出日志 | 是       | Pass     |