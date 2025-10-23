# AppServiceExtensionAbility简介

### 介绍

[AppServiceExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-appServiceExtensionAbility.md) 是从 API version 20 开始支持的组件，允许开发者为应用提供后台服务能力。其他应用可以通过启动或连接该组件获取相应服务，实现无界面长期运行的功能（如数据监控、文件操作监听等）。

### 效果预览

不涉及。
### 使用说明

1. 应用在启动后展示首页，首页展示相关按钮，点击进入相应功能界面。
2. 点击对应按钮触发相关回调，并打印相关信息
3. 示例将被启动或被连接的AppServiceExtensionAbility组件称为服务端，将启动或连接AppServiceExtensionAbility组件的应用组件（当前仅支持UIAbility）称为客户端。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── myappserviceextability
 │   │       ├── MyAppServiceExtAbility.ets   
 │   │   ├── myappserviceextabilityfour
 │   │       ├── MyAppServiceExtAbility.ets            
 │   │   ├── myappserviceextabilitythree
 │   │       ├── MyAppServiceExtAbility.ets            
 │   │   ├── myappserviceextabilitytwo
 │   │       ├── MyAppServiceExtAbility.ets            
 │   │   ├── pages
 │   │       ├── ClientServerExt.ets                   // 客户端与服务端通信
 │   │       ├── ConnectAppServiceExt.ets                   // 连接一个后台服务
 │   │       ├── DisConnectAppServiceExt.ets                   // 使用disconnectAppServiceExtensionAbility()断开与后台服务的连接
 │   │       ├── Index.ets                   // 首页
 │   │       ├── StartAppServiceExt.ets                   // 启动一个后台服务
 │   │       ├── StopAppServiceExt.ets                   // 停止一个已启动的AppServiceExtensionAbility组件
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

1.实现一个后台服务

在MyAppServiceExtAbility.ets文件中，增加导入AppServiceExtensionAbility的依赖包，自定义类继承AppServiceExtensionAbility组件并实现生命周期回调。

entry/src/main/ets/myappserviceextability/MyAppServiceExtAbility.ets

```ts
import { AppServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[MyAppServiceExtAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

class StubTest extends rpc.RemoteObject {
  constructor(des: string) {
    super(des);
  }

  onRemoteMessageRequest(code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    options: rpc.MessageOption): boolean | Promise<boolean> {
    // 处理客户端发送的消息
    return true;
  }
}

export default class MyAppServiceExtAbility extends AppServiceExtensionAbility {
  onCreate(want: Want): void {
    let appServiceExtensionContext = this.context;
    hilog.info(DOMAIN_NUMBER, TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want, startId: number): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want): rpc.RemoteObject {
    hilog.info(DOMAIN_NUMBER, TAG, `onConnect, want: ${want.abilityName}`);
    return new StubTest("test");
  }

  onDisconnect(want: Want): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onDestroy');
  }
};
```

2.启动一个后台服务

应用通过startAppServiceExtensionAbility()方法启动一个后台服务，服务的onRequest()回调就会被调用，并在该回调方法中接收到调用者传递过来的Want对象。后台服务启动后，其生命周期独立于客户端，即使客户端已经销毁，该后台服务仍可继续运行。因此，后台服务需要在其工作完成时通过调用AppServiceExtensionContext的terminateSelf()来自行停止，或者由另一个组件调用stopAppServiceExtensionAbility()来将其停止。

entry/src/main/ets/pages/StartAppServiceExt.ets

```ts
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[Page_AppServiceExtensionAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_AppServiceExtensionAbility {
  build() {
    Column() {
      //...
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            //...
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '',
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'MyAppServiceExtAbility'
            };
            context.startAppServiceExtensionAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting AppServiceExtensionAbility.');
              // 成功启动后台服务
              this.getUIContext().getPromptAction().showToast({
                message: 'SuccessfullyStartBackendService'
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Failed to start AppServiceExtensionAbility. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }

        //...
      }

      //...
    }

    //...
  }
}
```
### 相关权限

应用集成AppServiceExtensionAbility组件需要申请ACL权限（ohos.permission.SUPPORT_APP_SERVICE_EXTENSION）。该ACL权限当前只对企业普通应用开放申请。

### 依赖

不涉及。

### 约束与限制

1.本示例AppServiceExtensionAbility组件当前仅支持2in1设备。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/AppServiceExtensionAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
