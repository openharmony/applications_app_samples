# AbilityStage组件管理器 简介

### 介绍

AbilityStage是应用程序中的一个模块，用于管理和控制应用的生命周期组件。

该工程中展示的代码详细描述可查如下链接：

- [AbilityStage简介](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/abilitystage.md)

### 效果预览
不涉及。

### 使用说明

1. 拉起应用，触发EnvironmentCallback中的onConfigurationUpdated()回调，并打印相关信息。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── exampleabilitystage
 │   │       ├── MyAbilityStage.ets   // 自定义类继承AbilityStage并加上需要的生命周期回调
 │   │   ├── myabilitystage
 │   │       ├── MyAbilityStage.ets   // 监听系统环境变量的变化
 │   │   ├── pages
 │   │       ├── Index.ets                   // 首页
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

1.创建AbilityStage文件

entry/src/main/ets/exampleabilitystage/MyAbilityStage.ets

```ts
import { AbilityStage, Want } from '@kit.AbilityKit';

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    // 应用HAP首次加载时触发，可以在此执行该Module的初始化操作（例如资源预加载、线程创建等）。
  }

  onAcceptWant(want: Want): string {
    // 仅specified模式下触发
    return 'MyAbilityStage';
  }
}
```

2.在module.json5配置文件中，通过配置 srcEntry 参数来指定模块对应的代码路径，以作为HAP加载的入口。

entry/src/main/module.json5

```json
{
  "module": {
    "name": "entry",
    "type": "entry",
    "srcEntry": "./ets/myabilitystage/MyAbilityStage.ets"
  }
}
```

3.监听系统环境变量的变化

entry/src/main/ets/pages/Index.ets

```ts
import { EnvironmentCallback, AbilityStage } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    console.info('AbilityStage onCreate');
    let envCallback: EnvironmentCallback = {
      onConfigurationUpdated(config) {
        console.info(`envCallback onConfigurationUpdated success: ${JSON.stringify(config)}`);
        let language = config.language; //应用程序的当前语言
        let colorMode = config.colorMode; //深浅色模式
        let direction = config.direction; //屏幕方向
        let fontSizeScale = config.fontSizeScale; //字体大小缩放比例
        let fontWeightScale = config.fontWeightScale; //字体粗细缩放比例
      },
      onMemoryLevel(level) {
        console.info(`onMemoryLevel level: ${level}`);
      }
    };
    try {
      let applicationContext = this.context.getApplicationContext();
      let callbackId = applicationContext.on('environment', envCallback);
      console.info(`callbackId: ${callbackId}`);
    } catch (paramError) {
      console.error(`error: ${(paramError as BusinessError).code}, ${(paramError as BusinessError).message}`);
    }
  }

  onDestroy(): void {
    // 通过onDestroy()方法，可以监听到Ability的销毁事件。
    console.info('AbilityStage onDestroy');
  }
}
```
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/AbilityStage > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
