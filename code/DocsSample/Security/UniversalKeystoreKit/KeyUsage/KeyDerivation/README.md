## 密钥派生(ArkTS)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-key-derivation-arkts.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

####  HKDF

##### 介绍

1. 本示例主要介绍密钥派生，以HKDF为例，完成密钥派生。

##### 效果预览

| 主页                                                | 执行结果                                            |
| --------------------------------------------------- | --------------------------------------------------- |
| <img src="./screenshots/HKDF_1.png" width="360;" /> | <img src="./screenshots/HKDF_2.png" width="360;" /> |

使用说明

1. 点击HKDF按钮生成密钥并派生密钥，删除密钥。

####  PBKDF2

##### 介绍

1. 本示例主要介绍密钥派生，以PBKDF为例，完成密钥派生。

##### 效果预览

| 主页                                                  | 执行结果                                              |
| ----------------------------------------------------- | ----------------------------------------------------- |
| <img src="./screenshots/PBKDF2_1.png" width="360;" /> | <img src="./screenshots/PBKDF2_2.png" width="360;" /> |

使用说明

1. 点击PBKDF2按钮生成密钥并派生密钥，删除密钥。

## 密钥派生(C/C++)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-key-derivation-ndk.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### Call C/C++

##### 介绍

1. 本示例主要介绍密钥派生，以HKDF256密钥为例，完成密钥派生。

##### 效果预览

| 主页                                               | 执行结果                                           |
| -------------------------------------------------- | -------------------------------------------------- |
| <img src="./screenshots/Cpp_1.png" width="360;" /> | <img src="./screenshots/Cpp_2.png" width="360;" /> |

使用说明

1. 点击Call C/C++按钮生成密钥并派生密钥，删除密钥。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---HKDF.ets
|---|---|---PBKDF2.ets
|---|---|---Index.ets						// 首页
|---cpp
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---KeyDerivation.test.ets        // 自动化测试用例
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
echo code/DocsSample/Security/UniversalKeystoreKit/KeyUsage/KeyDerivation > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```