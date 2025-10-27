# Asset Store Kit开发指导(ArkTS)

### 介绍

Asset Store Kit（关键资产存储开发套件）包含了关键资产存储服务（ASSET）开放的接口能力集合，提供了用户短敏感数据的安全存储及管理能力。其中，短敏感数据可以是密码类（账号/密码）、Token类（应用凭据）、关键明文（如银行卡号）等长度较短的用户敏感数据。

本示例主要展示了Asset Store Kit开发指导(ArkTS)中新增关键资产、删除关键资产、更新关键资产、查询关键资产等场景。该工程中展示的代码详细描述可查如下链接中业务扩展场景介绍部分。

- [新增关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-add.md)
- [删除关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-remove.md)
- [更新关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-update.md)
- [查询关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-query.md)
- [查询需要用户的关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-query-auth.md)
- [管理群组关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-group-access-control.md)
- [同步（备份恢复）关键资产(ArkTS)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/security/AssetStoreKit/asset-js-sync.md)

### 效果预览

| 首页效果图                                                               | 执行结果图                                                               |
|---------------------------------------------------------------------|---------------------------------------------------------------------|
| <img src="./screenshots/AssetStoreArkTS1.png" style="zoom: 50%;" /> | <img src="./screenshots/AssetStoreArkTS2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现为上述首页效果图，点击对应文本的按钮可以管理关键资产，其中'Query User-Auth Asset'按钮需要设置锁屏密码才能查询成功。
3. 运行测试用例AssetStoreArkTS.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── operations                    // Asset Store Kit开发指导(ArkTS)示例代码
 │   │       ├── add.ets
 │   │       ├── add_auth.ets
 │   │       ├── add_group.ets
 │   │       ├── add_sync.ets
 │   │       ├── index.ets
 │   │       ├── query_attr.ets
 │   │       ├── query_auth.ets
 │   │       ├── query_batch_attrs.ets
 │   │       ├── query_group_attr.ets
 │   │       ├── query_group_plaintext.ets
 │   │       ├── query_plaintext.ets
 │   │       ├── query_sync_result.ets
 │   │       ├── remove.ets
 │   │       ├── remove_auth.ets
 │   │       ├── remove_group.ets
 │   │       ├── update.ets
 │   │       ├── update_group.ets
 │   │   ├── pages
 │   │       ├── Index.ets
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── AssetStoreArkTS.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
```

### 相关权限

ohos.permission.ACCESS_BIOMETRIC

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.47。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/AssetStoreKit/AssetStoreArkTS > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````