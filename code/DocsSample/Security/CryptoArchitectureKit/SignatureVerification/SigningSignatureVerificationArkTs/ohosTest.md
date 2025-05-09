# 签名验签(ArkTS)测试用例归档

## 用例表

| 测试功能                                                 | 预置条件     | 输入 | 预期输出       | 是否自动 | 测试结果 |
| -------------------------------------------------------- | ------------ | ---- | -------------- | -------- | -------- |
| 拉起应用                                                 | 设备正常运行 |      | 成功拉起应用   | 是       | Pass     |
| 点击按钮，使用RSA密钥对（PKCS1模式）签名验签(异步)       | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对（PKCS1模式）签名验签(同步)       | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对（PKCS1模式）签名及签名恢复(异步) | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对（PKCS1模式）签名及签名恢复(同步) | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对分段签名验签（PKCS1模式）(异步)   | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对分段签名验签（PKCS1模式）(同步)   | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对签名验签（PSS模式）(异步)         | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用RSA密钥对签名验签（PSS模式）(同步)         | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用ECDSA密钥对签名验签(异步)                  | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用ECDSA密钥对签名验签(同步)                  | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用SM2密钥对签名验签(异步)                    | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |
| 点击按钮，使用SM2密钥对签名验签(同步)                    | 成功拉起应用 |      | 成功并输出日志 | 是       | Pass     |