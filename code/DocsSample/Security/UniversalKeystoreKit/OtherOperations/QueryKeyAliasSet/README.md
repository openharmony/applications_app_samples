## 查询密钥别名集(ArkTS)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-list-aliases-arkts.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

####  QueryKeyAliasSet

##### 介绍

1. 本示例主要介绍查询密钥别名集，HUKS提供了接口供应用查询密钥别名集。

##### 效果预览

| 主页                                                         | 查询密钥别名                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/QueryKeyAliasSet_1.png" width="360;" /> | <img src="./screenshots/QueryKeyAliasSet_2.png" width="360;" /> |

使用说明

1. 点击Call ArkTS按钮调用接口listAliases，查询密钥别名集。

## 查询密钥别名集(C/C++)

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/UniversalKeystoreKit/huks-list-aliases-ndk.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### Call C/C++

##### 介绍

1. 本示例主要介绍查询密钥别名集，HUKS提供了接口供应用查询密钥别名集。

##### 效果预览

| 主页                                               | 查询密钥别名                                       |
| -------------------------------------------------- | -------------------------------------------------- |
| <img src="./screenshots/Cpp_1.png" width="360;" /> | <img src="./screenshots/Cpp_2.png" width="360;" /> |

使用说明

1. 点击Call C/C++按钮调用接口OH_Huks_ListAliases，查询密钥别名集。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---QueryKeyAliasSet.ets
|---|---|---Index.ets						// 首页
|---cpp
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---QueryKeyAliasSet.test.ets   // 自动化测试用例
```


## 相关权限

无。

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API20版本SDK，SDK版本号(API Version 20 Release)。
3. 本示例需要使用DevEco Studio 版本号(5.0.5Release)以上才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/UniversalKeystoreKit/OtherOperations/QueryKeyAliasSet > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```