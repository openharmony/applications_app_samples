# 交互协同

### 介绍

本示例是Stage模型开发指导的测试Hap，用于测试其相关功能。

本示例参考[应用模型](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/application-models)。 

### 效果预览

|主页|多设备协同界面| 热启动界面                                                  |冷启动界面|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|<img src="screenshot/mainpage.png" style="zoom: 50%;" />| <img src="screenshot/synergypage.png" style="zoom: 50%;" /> | <img src="screenshot/hotstartuppage.png" style="zoom: 50%;" /> | <img src="screenshot/coldstartuppage.png" style="zoom: 50%;" /> |

使用说明



### 工程目录
```
entry/src/main/ets/
├── calleeability
│   └── Calleeability.ts												// Callee通信
├── collaborateability
│   └── CollaborateAbility.ts											// 跨端迁移
├── entryability
│   └── EntryAbility.ts													// 主Ability
├── funcability
│   └── FuncAbility.ts												   	// 指定启动模式
├── funcabilitya
│   └── FuncAbilityA.ts												    // 指定启动模式
├── funcabilitya
│   └── FuncAbilityA.ts												    // 指定启动模式
├── IdlServiceExt
│   ├── i_idl_service_ext.ts											// 生成文件
│   ├── idl_service_ext_proxy.ts										// 生成文件
│   ├── idl_service_ext_stub.ts											// 生成文件
│   └── idl_service_ext_impl.ts											// 开发者自定义文件，对idl接口的具体实现
├── serviceextability
│   └── ServiceExtAbility.ts										   	// ServiceExtAbility
└── pages
    ├── Index.ets														// 应用主界面
    ├── Page_ColdStartUp.ets											// 冷启动界面
    ├── Page_Calleeability.ets											// Callee通信界面
    ├── Page_CollaborateAbility.ets										// 协同界面
    ├── Page_FromStageModel.ets											// 指定启动界面
    └── Page_HotStartUp.ets											    // 热启动界面

```
### 具体实现

* 本示例是Stage模型开发指导的测试依赖的Hap包，无其它功能。


### 相关权限

无。

### 依赖

详见Stage模型开发指导。

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568。

2.本示例为Stage模型，已适配API version 11版本SDK，版本号：4.1.3.1

3.本示例需要使用DevEco Studio 3.1.1 Release (Build Version: 3.1.0.501, built on June 20, 2023)及以上版本才可编译运行。

4.本示例涉及实现ServiceExtensionAbility功能，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://gitee.com/link?target=https%3A%2F%2Fdocs.openharmony.cn%2Fpages%2Fv3.2%2Fzh-cn%2Fapplication-dev%2Fquick-start%2Ffull-sdk-switch-guide.md%2F)。

5.本示例涉及申请AssociatedWakeUp特权，只有具有AllowAppUsePrivilegeExtension特权的应用才允许开发ServiceExtensionAbility，具体申请方式可参考[应用特权配置指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)。

6.本示例涉及相关权限为system_core级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://gitee.com/link?target=https%3A%2F%2Fdocs.openharmony.cn%2Fpages%2Fv3.2%2Fzh-cn%2Fapplication-dev%2Fsecurity%2Fhapsigntool-overview.md%2F))。

7.本示例类型为系统应用，需要手动配置对应级别的应用类型("app-feature": "hos_system_app")。具体可参考profile配置文件[bundle-info对象内部结构]( https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/app-provision-structure.md#bundle-info%E5%AF%B9%E8%B1%A1%E5%86%85%E9%83%A8%E7%BB%93%E6%9E%84 )

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/ApplicationModels/StageModelAbilityInteraction/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
