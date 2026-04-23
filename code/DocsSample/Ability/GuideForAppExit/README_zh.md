# 应用退出指南

### 介绍
本示例展示了应用退出的相关场景和方法，包含[UIAbility终止](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/uiability-lifecycle.md)和[返回键处理](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ui-cases.md#%E7%9B%91%E5%90%AC%E7%B3%BB%E7%BB%9F%E8%BF%94%E5%9B%9E%E9%94%AE)等功能。当用户执行返回操作或应用需要主动退出时，开发者可以通过相应的方法来控制应用的行为。

本示例包含以下子模块：
- **terminateSelf**：演示如何使用 `terminateSelf()` 方法主动退出 UIAbility
- **onBackPressed**：演示如何监听系统返回键事件并自定义处理逻辑

### 效果预览
- terminateSelf：应用启动2秒后自动退出
![应用启动2秒后自动退出](screenshots/TerminateSelf.gif)
- onBackPressed：点击返回键时应用退出
![点击返回键时应用退出](screenshots/OnBackPressedAbility.gif)

### 使用说明
#### terminateSelf
1. 打开工程
2. 进入 `terminateSelf/src/main/ets/terminateselfability` 目录，查看 `TerminateSelfAbility.ets` 文件
3. 运行应用，应用会在启动2秒后自动调用 `terminateSelf()` 退出

**关键代码**：
```typescript
onForeground(): void {
  // 获取UIAbilityContext
  let context = this.context;

  setTimeout(() => {
    context.terminateSelf().then(() => {
      console.info('Succeeded in terminating self.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to terminate self. Code is ${err.code}, message is ${err.message}`);
    });
  }, 2000);
}
```

#### onBackPressed
1. 打开工程
2. 进入 `onBackPressed/src/main/ets/onbackpressedability` 目录，查看 `OnBackPressedAbility.ets` 文件
3. 运行应用，点击返回键时应用会退出

**关键代码**：
```typescript
onBackPressed() {
  // 调用terminateSelf退出UIAbility
  this.context.terminateSelf().then(() => {
    console.info('Succeeded in terminating self.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to terminate self. Code is ${err.code}, message is ${err.message}`);
  });

  // 返回true表示消费该事件，不再进行默认处理
  return true;
}
```

### 工程目录
```
GuideForAppExit/
├── AppScope
│   ├── resources
│   ├── app.json5                        // 应用级配置文件
├── onBackPressed                        // 返回键处理示例
│   ├── src/main/ets
│   │   ├── onbackpressedability
│   │   │   └── OnBackPressedAbility.ets // onBackPressed处理逻辑
│   │   └── pages
│   │       └── Index.ets                // 首页
│   ├── src/ohosTest/ets/test
│   │   ├── Ability.test.ets             // Ability测试用例
│   │   └── List.test.ets                // List测试用例
│   └── build-profile.json5              // 模块级配置文件
├── terminateSelf                        // 主动退出示例
│   ├── src/main/ets
│   │   ├── terminateselfability
│   │   │   └── TerminateSelfAbility.ets // terminateSelf逻辑
│   │   └── pages
│   │       └── Index.ets                // 首页
│   ├── src/ohosTest/ets/test
│   │   ├── Ability.test.ets             // Ability测试用例
│   │   └── List.test.ets                // List测试用例
│   └── build-profile.json5              // 模块级配置文件
└── oh-package.json5                      // 依赖配置文件
```

### 具体实现

#### terminateSelf
演示如何主动退出 UIAbility，源码参考: [TerminateSelfAbility.ets](terminateSelf/src/main/ets/terminateselfability/TerminateSelfAbility.ets)
- 使用 `context.terminateSelf()` 方法主动终止当前 UIAbility 实例
- 支持Promise异步处理，可以在成功/失败回调中进行相应操作
- 适用于需要主动退出应用的场景，如任务完成、用户点击退出按钮等

#### onBackPressed
演示如何监听和处理返回键事件，源码参考: [OnBackPressedAbility.ets](onBackPressed/src/main/ets/onbackpressedability/OnBackPressedAbility.ets)
- 实现 `onBackPressed()` 方法监听返回键事件
- 返回 `true` 表示消费该事件，阻止系统默认行为
- 返回 `false` 表示不消费该事件，继续系统默认处理
- 适用于自定义返回键行为的场景

### 相关权限
不涉及

### 依赖
不涉及

### 约束与限制
1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.47。
3. 本示例需要使用DevEco Studio 6.0.0及以上版本才可编译运行。
4. `terminateSelf()` 方法只能在 UIAbility 的生命周期中调用，不能在Worker线程中调用。
5. `onBackPressed()` 方法需要在 UIAbility 中实现，系统返回键事件才会被捕获。

