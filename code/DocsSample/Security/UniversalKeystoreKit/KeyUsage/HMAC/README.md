## HMAC(ArkTS)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-hmac-arkts.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### HMAC

##### 介绍

1. 本示例主要介绍HMAC，HMAC是密钥相关的哈希运算消息认证码（Hash-based Message Authentication Code），是一种基于Hash函数和密钥进行消息认证的方法。

##### 效果预览

| 主页                                                | 删除                                                |
| --------------------------------------------------- | --------------------------------------------------- |
| <img src="./screenshots/HMAC_1.png" width="360;" /> | <img src="./screenshots/HMAC_2.png" width="360;" /> |

使用说明

1. 点击Call HMAC按钮确定密钥别名生成密钥并获取密钥别名和待哈希数据，获取 HMAC 算法参数配置。

## HMAC(C/C++)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-hmac-ndk.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### Call C/C++

##### 介绍

1. 本示例主要介绍HMAC，HMAC是密钥相关的哈希运算消息认证码（Hash-based Message Authentication Code），是一种基于Hash函数和密钥进行消息认证的方法。

##### 效果预览

| 主页                                               |                                                    |
| -------------------------------------------------- | -------------------------------------------------- |
| <img src="./screenshots/cpp_1.png" width="360;" /> | <img src="./screenshots/cpp_2.png" width="360;" /> |

使用说明

1. 点击Call C/C++按钮确定密钥别名生成密钥并获取密钥别名和待哈希数据，获取 HMAC 算法参数配置。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---HWAC.ets
|---|---|---Index.ets						// 首页
|---cpp
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---HMAC.test.ets        // 自动化测试用例
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
echo code/DocsSample/Security/UniversalKeystoreKit/KeyUsage/HMAC > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
