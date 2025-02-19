## 非匿名密钥证明(ArkTS)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-key-attestation-arkts.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

####  NonAnonymousKeyProof

##### 介绍

1. 本示例主要介绍非匿名密钥证明，非匿名密钥证明是一种安全机制，用于验证密钥的合法性和有效性。

##### 效果预览

| 主页                                                         | 删除                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/NonAnonymousKeyProof_1.png" width="360;" /> | <img src="./screenshots/NonAnonymousKeyProof_2.png" width="360;" /> |

使用说明

1. 点击Call NonAnonymousKeyProof按钮将密钥别名与参数集作为参数传入huks.attestKeyItem方法中，即可证明密钥。

## 非匿名密钥证明(C/C++)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-key-attestation-ndk.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### Call C/C++

##### 介绍

1. 本示例主要介绍非匿名密钥证明，非匿名密钥证明是一种安全机制，用于验证密钥的合法性和有效性。

##### 效果预览

| 主页                                               | 跳转页                                             |
| -------------------------------------------------- | -------------------------------------------------- |
| <img src="./screenshots/Cpp_1.png" width="360;" /> | <img src="./screenshots/Cpp_2.png" width="360;" /> |

使用说明

1. 点击Call C/C++按钮将密钥别名与参数集作为参数传入OH_Huks_AttestKeyItem方法中，即可证明密钥。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---|---|---AnonymousKeyProof.ets
|---cpp
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---NonAnonymousKeyProof.test.ets        // 自动化测试用例
```


## 相关权限

[ohos.permission.ATTEST_KEY](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionattestkey)

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API14版本SDK，SDK版本号(API Version 14 Release)。
3. 本示例需要使用DevEco Studio 版本号(5.0.1Release)才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/UniversalKeystoreKit/KeyProving/DevelopmentGuidelines/NonanonymousKeyProof > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```