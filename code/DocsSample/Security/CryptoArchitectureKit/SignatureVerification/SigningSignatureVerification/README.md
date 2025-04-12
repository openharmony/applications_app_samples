# 签名验签(C/C++)

### 介绍

当需要判断接收的数据是否被篡改、数据是否为指定对象发送的数据时，可以使用签名验签操作。接下来将说明系统目前支持的算法及其对应的规格。

本示例主要展示了签名验签(C/C++)的多种场景 。该工程中展示的代码详细描述可查如下链接。

- [使用RSA密钥对（PKCS1模式）验签(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pkcs1-ndk.md)
- [使用RSA密钥对（PKCS1模式）签名恢复(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-recover-pkcs1-ndk.md)
- [使用RSA密钥对分段验签（PKCS1模式）(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pkcs1-by-segment-ndk.md)
- [使用RSA密钥对验签（PSS模式）(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pss-ndk.md)
- [使用ECDSA密钥对验签(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-ecdsa-sign-sig-verify-ndk.md)
- [使用SM2密钥对验签(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-sm2-sign-sig-verify-pkcs1-ndk.md)

### 效果预览

| 首页效果图                                                   | 执行结果图                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/SigningSignatureVerification1.png" style="zoom: 50%;" /> | <img src="./screenshots/SigningSignatureVerification2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述执行结果图效果，点击不同按钮可以跳转到不同功能页面，点击跳转页面中按钮可以执行对应操作，并更新文本内容。
3. 运行测试用例SigningSignatureVerification.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   |   ├── libentry
 │   │   |       ├── index.d.ts
 │   │   |       ├── oh-package.json5
 │   │   |   ├── project
 │   │   |       ├── ecdsa_signature_verification.cpp
 │   │   |       ├── rsa_pkcs1_segment_signature.cpp
 │   │   |       ├── rsa_pkcs1_signature_restoration.cpp
 │   │   |       ├── rsa_pkcs1_signature_validator.cpp
 │   │   |       ├── rsa_pss_verification_tool.cpp
 │   │   |       ├── signing_signature_verification.h
 │   │   |       ├── sm2_signature_verification.cpp
 │   │   ├── CMakeList.txt
 │   │   ├── napi_init.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 签名验签(C/C++)示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── SigningSignatureVerification.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/CryptoArchitectureKit/SignatureVerification/SigningSignatureVerification > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````