# 使用ECC压缩/非压缩格式转换

### 介绍

可通过指定ECC公钥数据，生成公钥对象（PubKey）；也可从公钥对象（PubKey）中，获取ECC公钥数据。当前仅支持ECC算法中，满足X509规范的压缩/非压缩格式的公钥数据。此处的公钥数据应当是完整的X509公钥，对于只使用点数据的情况.

本示例主要展示了使用ECC压缩/非压缩公钥格式转换(ArkTS)、使用ECC压缩/非压缩公钥格式转换(C/C++)、使用ECC压缩/非压缩点格式转换场景。该工程中展示的代码详细描述可查如下链接中业务扩展场景介绍部分。

- [使用ECC压缩/非压缩公钥格式转换(ArkTS)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-convert-compressed-or-uncompressed-ECC-pubkey.md)
- [使用ECC压缩/非压缩公钥格式转换(C/C++)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-convert-compressed-or-uncompressed-ECC-pubkey-ndk.md)
- [使用ECC压缩/非压缩点格式转换](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-convert-compressed-or-uncompressed-ECC-point.md)

### 效果预览

| 首页效果图                                                   | 执行结果图                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/ECCCompressPublicKeyFormatConversion1.png" style="zoom: 50%;" /> | <img src="./screenshots/ECCCompressPublicKeyFormatConversion2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述执行结果图效果，点击不同按钮可以跳转到不同功能页面，点击跳转页面中按钮可以执行对应操作，并更新文本内容。
3. 运行测试用例ECCCompressPublicKeyFormatConversion.test.ets文件对页面代码进行测试可以全部通过。

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
 │   │   |       ├── specifyUncompressedPublicKey.cpp
 │   │   |       ├── file.h
 │   │   ├── CMakeList.txt
 │   │   ├── napi_init.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 使用ECC压缩/非压缩格式转换示例代码
 │   │       ├── CompressedPointData.ets
 │   │       ├── GetKeyObject.ets
 │   │       ├── SpecifyUncompressedPublicKey.ets
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── ECCCompressPublicKeyFormatConversion.test.ets  // 自动化测试代码
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
echo code/DocsSample/Security/CryptoArchitectureKit/KeyGenerationConversion/ECCCompressPublicKeyFormatConversion > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````