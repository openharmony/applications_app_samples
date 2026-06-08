# arkts-immersive-light-sense

## 介绍

本示例展示了沉浸光感（Immersive Light Sense）的使用。沉浸光感是ArkUI从API版本26.0.0起新增的一套高品质视觉与动效体系，通过沉浸式系统材质（ImmersiveMaterial）与空间动效的结合，为应用组件带来通透、精致的视觉表现。沉浸光感包含两部分能力：

- **沉浸式系统材质**：通过影响组件的背景色、边框颜色、边框宽度和阴影，让组件呈现具有层次感和通透感的视觉表现。提供ULTRA_THIN、THIN、REGULAR、THICK、ULTRA_THICK五种材质样式。
- **空间动效**：为组件的弹出过程增添形变、流光等动态表现，使动画更加灵动流畅。

[沉浸光感](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-immersive-light-sense.md)

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 首页面会出现示例列表，点击列表项进入对应的沉浸光感示例页面；
3. 各示例页面展示了不同场景下沉浸式系统材质的设置方式和效果。

## 工程目录

```
ImmersiveLightSense
├── AppScope
│   ├── app.json5
│   └── resources
│       └── base
│           ├── element
│           │   └── string.json
│           └── media
│               ├── background.png
│               ├── foreground.png
│               └── layered_image.json
├── entry
│   └── src
│       ├── main
│       │   ├── ets
│       │   │   ├── entryability
│       │   │   │   └── EntryAbility.ets
│       │   │   ├── entrybackupability
│       │   │   │   └── EntryBackupAbility.ets
│       │   │   └── pages
│       │   │       ├── Index.ets                          // 首页导航
│       │   │       └── immersiveLightSense
│       │   │           ├── MaterialInfo.ets               // MaterialState配置示例
│       │   │           ├── ColumnMaterial.ets             // Column通用属性设置材质
│       │   │           ├── ButtonInteractive.ets          // Button交互形变
│       │   │           ├── LightEffect.ets                // 光感交互反馈
│       │   │           ├── ToastMaterial.ets              // Toast系统材质
│       │   │           ├── PopupMaterial.ets              // Popup系统材质
│       │   │           ├── TipsMaterial.ets               // Tips系统材质
│       │   │           ├── SheetMaterial.ets              // bindSheet系统材质
│       │   │           ├── MenuMaterial.ets               // Menu系统材质
│       │   │           ├── CloseMaterial.ets              // 关闭组件材质
│       │   │           ├── AllStyles.ets                  // 五种材质样式展示
│       │   │           └── ColorInvert.ets                // 自动反色
│       │   ├── module.json5
│       │   └── resources
│       │       └── base
│       │           ├── element
│       │           │   ├── color.json
│       │           │   └── string.json
│       │           ├── media
│       │           │   ├── img.jpg
│       │           │   └── startIcon.png
│       │           └── profile
│       │               ├── backup_config.json
│       │               └── main_pages.json
│       └── ohosTest
│           └── ohosTest.md
```

## 具体实现

1. **MaterialState配置示例**：通过`uiMaterial.getMaterialInfo()`获取当前应用的材质配置状态，根据MaterialState枚举值（DEFAULT/ENABLE/DISABLE）动态展示不同组件的沉浸式系统材质行为，支持通过`uiMaterial.Material.empty`单独关闭组件材质。
2. **Column通用属性设置材质**：通过通用属性`systemMaterial`为Column组件设置ULTRA_THIN样式，展示最基本的沉浸式系统材质接入方式。
3. **Button交互形变**：通过设置`interactive: true`为组件开启交互形变效果，用户按压组件时产生弹性形变，松手后自动恢复。
4. **光感交互反馈**：通过设置`lightEffect: { color: undefined }`为组件开启光感交互反馈效果，用户手指触摸组件时产生流光跟随效果。
5. **Toast/Popup/Tips/Sheet/Menu系统材质**：分别展示弹窗类组件通过自身接口的systemMaterial参数设置沉浸式系统材质的方式，覆盖THIN、THICK、ULTRA_THICK等不同样式。
6. **关闭组件材质**：展示在ENABLE模式下，通过设置`uiMaterial.Material.empty`单独关闭默认开启的沉浸式系统材质。
7. **五种材质样式展示**：在同一页面展示ULTRA_THIN、THIN、REGULAR、THICK、ULTRA_THICK五种沉浸式系统材质样式的视觉效果差异。
8. **自动反色**：通过设置`colorInvert: true/false`对比展示自动反色功能，开启后组件内文字颜色自动适配材质到背景色的反色，确保可读性。

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行。

2. 本示例为Stage模型，支持API26版本SDK，版本号：26.0.0。

3. 本示例需使用DevEco Studio配套API26版本才可编译运行。

4. 沉浸光感功能从API版本26.0.0开始支持，需要确保设备的targetAPIVersion不低于26.0.0。

5. 沉浸光感效果会根据设备算力档位自动适配，高档设备呈现完整效果，中低档设备自动降级。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ImmersiveLightSense > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
