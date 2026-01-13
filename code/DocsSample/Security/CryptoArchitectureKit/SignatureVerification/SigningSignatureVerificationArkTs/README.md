# 签名验签(ArkTS)

### 介绍

当需要判断接收的数据是否被篡改、数据是否为指定对象发送的数据时，可以使用签名验签操作。接下来将说明系统目前支持的算法及其对应的规格。

本示例主要展示了签名验签(ArkTS)的多种场景，包括RSA（PKCS1和PSS模式）、ECDSA、SM2等算法的签名验签功能，以及SM2签名数据格式转换功能。该示例提供了异步和同步两种调用方式。该工程中展示的代码详细描述可查如下链接。

- [使用RSA密钥对（PKCS1模式）签名验签(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pkcs1.md)
- [使用RSA密钥对（PKCS1模式）签名及签名恢复(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-recover-pkcs1.md)
- [使用RSA密钥对分段签名验签（PKCS1模式）(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pkcs1-by-segment.md)
- [使用RSA密钥对签名验签（PSS模式）(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pss.md)
- [使用ECDSA密钥对签名验签(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-ecdsa-sign-sig-verify.md)
- [使用SM2密钥对签名验签(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-sm2-sign-sig-verify-pkcs1.md)
- [SM2签名数据格式转换(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-sm2-sign-data-format-conversion.md)

### 效果预览

| 首页效果图                                                   | 执行结果图                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/SigningSignatureVerificationArkTs1.png" style="zoom: 50%;" /> | <img src="./screenshots/SigningSignatureVerificationArkTs2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述执行结果图效果，主界面包含以下功能按钮：
   - **RSA PKCS1模式签名验签**：异步、同步
   - **RSA PKCS1模式签名恢复**：异步、同步
   - **RSA PKCS1模式分段签名验签**：异步、同步
   - **RSA PSS模式签名验签**：异步、同步
   - **ECDSA签名验签**：异步、同步
   - **SM2签名验签**：异步、同步
   - **SM2签名数据格式转换**：DER转RS、RS转DER
3. 点击不同按钮可以跳转到对应功能页面，点击跳转页面中按钮可以执行对应操作，并更新文本内容。
4. 运行测试用例SigningSignatureVerificationArkTs.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   └── pages
 │   │       ├── Index.ets                                    // 签名验签(ArkTS)主界面
 │   │       ├── ecdsa_signature_verification
 │   │       │   ├── ecdsa_signature_verification_asynchronous.ets
 │   │       │   └── ecdsa_signature_verification_synchronous.ets
 │   │       ├── rsa_pkcs1_segment_signature
 │   │       │   ├── rsa_pkcs1_segment_signature_asynchronous.ets
 │   │       │   └── rsa_pkcs1_segment_signature_synchronous.ets
 │   │       ├── rsa_pkcs1_signature_restoration
 │   │       │   ├── rsa_pkcs1_signature_restoration_asynchronous.ets
 │   │       │   └── rsa_pkcs1_signature_restoration_synchronous.ets
 │   │       ├── rsa_pkcs1_signature_validator
 │   │       │   ├── rsa_pkcs1_signature_validator_asynchronous.ets
 │   │       │   └── rsa_pkcs1_signature_validator_synchronous.ets
 │   │       ├── rsa_pss_signature_verification
 │   │       │   ├── rsa_pss_signature_verification_asynchronous.ets
 │   │       │   └── rsa_pss_signature_verification_synchronous.ets
 │   │       ├── sm2_data_format_convertion
 │   │       │   ├── sm2_sign_data_der_to_rs.ets
 │   │       │   └── sm2_sign_data_rs_to_der.ets
 │   │       └── sm2_signature_verification
 │   │           ├── sm2_signature_verification_asynchronous.ets
 │   │           └── sm2_signature_verification_synchronous.ets
 │   ├── module.json5
 │   └── resources
 └── ohosTest
     ├── ets
     │   └── test
     │       ├── Ability.test.ets 
     │       ├── SigningSignatureVerificationArkTs.test.ets  // 自动化测试代码
     │       └── List.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行， 支持设备：RK3568。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.1.0.17，镜像版本号：OpenHarmony_6.1.0.17。

3.本示例需要使用DevEco Studio 6.0.1 Release(6.0.1.251)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/CryptoArchitectureKit/SignatureVerification/SigningSignatureVerificationArkTs > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````