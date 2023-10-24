# ArkTS卡片计算器

### 介绍

本示例展示了使用ArkTS卡片开发的计算器模型。

### 效果预览

| 添加卡片                                         | 卡片预览                                                 | 操作卡片                                         |
| ------------------------------------------------ | -------------------------------------------------------- | ------------------------------------------------ |
| ![CalculatorAdd](screenshots/CalculatorAdd.jpeg) | ![CalculatorPreview](screenshots/CalculatorPreview.jpeg) | ![CalculatorUse](screenshots/CalculatorUse.jpeg) |

### 使用说明

1.部分设备的桌面不支持卡片，可以通过自己的开发卡片使用方，进行卡片的创建、更新和删除等操作。

### 工程目录

```
entry/src/main/ets/
|---entryability
    |---EntryAbility.ts                    // Ability声明周期处理文件
|---entryformability
|   |---EntryFormAbility.ts                // 卡片声明周期处理文件
|---pages
|   |---index.ets                          // 首页
|---calc
|   |---pages
|   |   |---CardCalc.ets                       // 计算器卡片页面
```

### 相关权限

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。