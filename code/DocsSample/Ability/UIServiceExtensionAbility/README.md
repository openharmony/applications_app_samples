# UIServiceExtensionAbility简介

### 介绍

UIServiceExtensionAbility组件是OpenHarmony中用于提供用户界面（UI）服务的扩展组件。系统应用可以通过该组件实现特定功能的UI服务，并将其开放给其他第三方应用调用。

### 效果预览
 不涉及。
### 使用说明

1. 通过UIExtensionContext调用startUIServiceExtensionAbility()方法启动UIServiceExtensionAbility。
2. 通过UIAbilityContext、UIExtensionContext调用connectUIServiceExtensionAbility()方法连接UIServiceExtensionAbility。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability

 │   │   ├── pages
 │   │       ├── Index.ets                   // 首页
 │   │       ├── Connect.ets                 //客户端连接服务
 │   │       ├── Start.ets                   // 启动
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```

### 具体实现

1.启动UIServiceExtensionAbility组件

应用通过startUIServiceExtensionAbility()方法启动一个UIServiceExtensionAbility组件。UIServiceExtensionAbility组件启动后，其生命周期独立于客户端，即使客户端已经销毁，该后台服务仍可继续运行，窗口创建失败或销毁后该服务会被销毁。

entry/src/main/ets/pages/Index.ets

```ts
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        // 创建启动按钮
        Button('start UIServiceExtensionAbility')
          .enabled(true)
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let startWant: Want = {
              bundleName: 'com.acts.uiserviceextensionability', // 仅作为示例代码，需要替换为实际的UIServiceExtensionAbility组件的包名。
              abilityName: 'UiServiceExtAbility', // 仅作为示例代码，需要替换为实际的UIServiceExtensionAbility组件名称。
            };
            try {
              // 启动UIServiceExtensionAbility组件
              context.startUIServiceExtensionAbility(startWant).then(() => {
                console.info('startUIServiceExtensionAbility success.');
              }).catch((error: BusinessError) => {
                console.error(`startUIServiceExtensionAbility failed, err code: ${error.code}, err msg: ${error.message}.`);
              });
            } catch (err) {
              let code = (err as BusinessError).code;
              let msg = (err as BusinessError).message;
              console.error(`startUIServiceExtensionAbility failed, err code: ${code}, err msg: ${msg}.`);
            }
          })
      }
    }
  }
}
```

2.客户端连接服务端

客户端通过connectUIServiceExtensionAbility()连接服务端，获取并保存UIServiceProxy对象。通过该proxy对象的sendData()方法发送数据给服务端。服务端通过UIServiceExtensionAbility类onData()（系统接口）方法接收客户端数据。

entry/src/main/ets/pages/Connect.ets
```ts
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  comProxy: common.UIServiceProxy | null = null;
  connectCallback: common.UIServiceExtensionConnectCallback = {
    onData: (data: Record<string, Object>) => {
      console.info(`data received, data: ${JSON.stringify(data)}.`);
    },
    onDisconnect: () => {
      console.info(`onDisconnect.`);
    }
  }

  build() {
    Column() {
      Row() {
        // 创建连接按钮
        Button('connect ability')
          .enabled(true)
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let startWant: Want = {
              bundleName: 'com.acts.uiserviceextensionability', // 仅作为示例代码，需要替换为实际的UIServiceExtensionAbility组件的包名。
              abilityName: 'UiServiceExtAbility', // 仅作为示例代码，需要替换为实际的UIServiceExtensionAbility组件名称。
            };
            try {
              // 连接UIServiceExtensionAbility组件
              context.connectUIServiceExtensionAbility(startWant, this.connectCallback)
                .then((proxy: common.UIServiceProxy) => {
                  this.comProxy = proxy;
                  let formData: Record<string, string> = {
                    'test': 'test'
                  };
                  try {
                    this.comProxy.sendData(formData);
                  } catch (err) {
                    let code = (err as BusinessError).code;
                    let msg = (err as BusinessError).message;
                    console.error(`sendData failed, err code:${code}, err msg:${msg}.`);
                  }
                })
                .catch((err: BusinessError) => {
                  console.error(`connectUIServiceExtensionAbility failed, err code: ${err.code}, err msg: ${err.message}.`);
                });
            } catch (err) {
              let code = (err as BusinessError).code;
              let msg = (err as BusinessError).message;
              console.error(`connectUIServiceExtensionAbility failed, err code:${code}, err msg:${msg}.`);
            }
          })
      }
    }
  }
}
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持2in1设备。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/UIServiceExtensionAbility > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
