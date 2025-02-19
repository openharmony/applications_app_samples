## 加密导入密钥(ArkTS)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/UniversalKeystoreKit/huks-import-wrapped-key-arkts.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

####  ImportEncryptedKey

##### 介绍

1. 本示例主要介绍为保证数据安全性加密导入ECDH密钥对。

##### 效果预览

| 主页                                                       | 删除                                                       |
| ---------------------------------------------------------- | ---------------------------------------------------------- |
| <img src="./screenshots/ImportEncryptedKey_1.png" width="360;" /> | <img src="./screenshots/ImportEncryptedKey_2.png" width="360;" /> |

使用说明

1. 点击Call ArkTS按钮调用接口ImportWrappedKey，加密导入密钥对为。

## 加密导入密钥(C/C++)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/UniversalKeystoreKit/huks-import-wrapped-key-ndk.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### Call C/C++

##### 介绍

1. 本示例主要介绍为保证数据安全性加密导入ECDH密钥对。

##### 效果预览

| 主页                                                         | 跳转页                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/ImportEncryptedKeyCpp_1.png" width="360;" /> | <img src="./screenshots/ImportEncryptedKeyCpp_2.png" width="360;" /> |

使用说明

1. 点击Call C/C++按钮调用接口importWrappedKey，加密导入密钥对为。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						 // 首页
|---|---|---ImportEncryptedKey.ets
|---cpp
|---resources								 // 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---ImportEncryptedKey.test.ets  // 自动化测试用例
```


## 相关权限

无。

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API15版本SDK，SDK版本号(API Version 15 Release)。
3. 本示例需要使用DevEco Studio 版本号(5.0.3Release)才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/ocsSample/Security/UniversalKeystoreKit/KeyGenerationImport/KeyImport/DevelopmentGuidelines/ImportEncryptedKey > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```