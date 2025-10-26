# EmbeddedUIExtensionAbility简介

### 介绍

[EmbeddedUIExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-embeddedUIExtensionAbility.md)是EMBEDDED_UI类型的[ExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-extensionAbility.md)组件，提供了跨进程界面嵌入的能力。

EmbeddedUIExtensionAbility需要和[EmbeddedComponent](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-embedded-component.md)一起配合使用，开发者可以在[UIAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-uiAbility.md)的页面中通过EmbeddedComponent嵌入本应用的EmbeddedUIExtensionAbility提供的UI。EmbeddedUIExtensionAbility在独立进程中运行，完成其页面的布局和渲染，与UIAbility数据不互通，适用于有进程隔离诉求的模块化开发场景。

### 效果预览
不涉及。

### 使用说明

1. 拉起应用。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── embeddeduiextability
 │   │       ├── ExampleEmbeddedAbility.ets   // 自定义类继承EmbeddedUIExtensionAbility
 │   │   ├── pages
 │   │       ├── BasicClass.ets                   
 │   │       ├── Extension.ets                   // EmbeddedUIExtensionAbility的onSessionCreate中加载了入口页面文件
 │   │       ├── Index.ets                   // 首页
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```

### 具体实现

1.创建EmbeddedUIExtAbility文件

entry/src/main/ets/embeddeduiextability/ExampleEmbeddedAbility.ets

```ts
import { EmbeddedUIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';

const TAG: string = '[ExampleEmbeddedAbility]';

export default class ExampleEmbeddedAbility extends EmbeddedUIExtensionAbility {
  onCreate() {
    console.info(TAG, `onCreate`);
  }

  onForeground() {
    console.info(TAG, `onForeground`);
  }

  onBackground() {
    console.info(TAG, `onBackground`);
  }

  onDestroy() {
    console.info(TAG, `onDestroy`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    console.info(TAG, `onSessionCreate, want: ${JSON.stringify(want)}`);
    let param: Record<string, UIExtensionContentSession> = {
      'session': session
    };
    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('pages/extension', storage);
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    console.info(TAG, `onSessionDestroy`);
  }
}
```

2.EmbeddedUIExtensionAbility的onSessionCreate中加载了入口页面文件pages/extension.ets内容如下。

entry/src/main/ets/pages/Extension.ets

```ts
import { UIExtensionContentSession } from '@kit.AbilityKit';

@Entry()
@Component
struct Extension {
  @State message: string = 'EmbeddedUIExtensionAbility Index';
  localStorage: LocalStorage | undefined = this.getUIContext().getSharedLocalStorage();
  private session: UIExtensionContentSession | undefined = this.localStorage?.get<UIExtensionContentSession>('session');

  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button('terminateSelfWithResult').fontSize(20).onClick(() => {
        this.session?.terminateSelfWithResult({
          resultCode: 1,
          want: {
            bundleName: 'com.example.embeddeddemo',
            abilityName: 'ExampleEmbeddedAbility'
          }});
      })
    }.width('100%').height('100%')
  }
}
```

3.在工程Module对应的module.json5配置文件中注册EmbeddedUIExtensionAbility，type标签需要设置为“embeddedUI”，srcEntry标签表示当前EmbeddedUIExtensionAbility组件所对应的代码路径

entry/src/main/module.json5

```json
{
  "module": {
    "extensionAbilities": [
      {
        "name": "EmbeddedUIExtAbility",
        "icon": "$media:icon",
        "description": "EmbeddedUIExtAbility",
        "type": "embeddedUI",
        "srcEntry": "./ets/EmbeddedUIExtAbility/EmbeddedUIExtAbility.ets"
      }
    ]
  }
}
```


4.开发EmbeddedUIExtensionAbility使用方

entry/src/main/ets/pages/Index.ets

```ts
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Message: '
  private want: Want = {
    bundleName: 'com.samples.embeddeduiextensionability',
    abilityName: 'EmbeddedUIExtAbility',
    parameters: {
      'ohos.extension.processMode.hostInstance': 'true'
    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message).fontSize(30)
        EmbeddedComponent(this.want, EmbeddedType.EMBEDDED_UI_EXTENSION)
          .width('100%')
          .height('90%')
          .onTerminated((info: TerminationInfo) => {
            this.message = 'Termination: code = ' + info.code + ', want = ' + JSON.stringify(info.want);
          })
          .onError((error: BusinessError) => {
            this.message = 'Error: code = ' + error.code;
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.当前EmbeddedUIExtensionAbility和EmbeddedComponent仅支持在拥有多进程配置的设备上使用，目前支持多进程配置的设备有2in1与Tablet。。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/EmbeddedUIExtensionAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
