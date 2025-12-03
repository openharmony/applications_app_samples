## 生成密钥(ArkTS)

### 介绍

1. 本工程实现了对以下 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-key-generation-arkts.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

####  Call ArkTS

##### 介绍

1. 本示例主要介绍生成密钥，以生成DH密钥为例生成随机密钥，指定待生成的密钥别名keyAlias。

##### 效果预览

| 主页                                                 |                                                      |
| ---------------------------------------------------- | ---------------------------------------------------- |
| <img src="./screenshots/ArkTS_1.png" width="360;" /> | <img src="./screenshots/ArkTS_2.png" width="360;" /> |

使用说明

1. 点击Call ArkTS按钮调用huks.generateKeyItem，传入密钥别名和密钥属性集，生成密钥。

## 生成密钥(C/C++)

### 介绍

1. 本工程实现了对以下示例代码片段的工程化，目标是实现指南中示例代码与sample工程文件同源。示例代码来源：https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/UniversalKeystoreKit/huks-key-generation-ndk.md

#### Call C/C++

##### 介绍

1. 本示例主要介绍生成密钥，以生成ECC密钥为例，生成随机密钥。

##### 效果预览

| 主页                                               |                                                    |
| -------------------------------------------------- | -------------------------------------------------- |
| <img src="./screenshots/Cpp_1.png" width="360;" /> | <img src="./screenshots/Cpp_2.png" width="360;" /> |

使用说明

1. 点击Call C/C++按钮调用OH_Huks_GenerateKeyItem，传入密钥别名和密钥属性集，生成密钥。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---cpp
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---GenerateKey.test.ets        // 自动化测试用例
```


## 相关权限

无。

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
echo code/DocsSample/Security/UniversalKeystoreKit/KeyGenerationImport/KeyGeneration/DevelopmentGuidelines/GenerateKey > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```