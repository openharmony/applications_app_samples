# Stage模型卡片小游戏

### 简介

本示例展示了如何通过Stage模型实现一个简单的游戏卡片。

- 通过卡片支持的[点击事件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/js-service-widget-ui/js-service-widget-common-events.md)进行交互，让用户通过点击的先后顺序把一个乱序的成语排列成正确的成语。

- 使用了C++和TS的混合编程方式，将获取随机数的能力下沉到C++实现，并通过[NAPI](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/napi/napi-guidelines.md)的能力将C++实现的能力暴露到TS中。

使用说明：

1.部分设备的桌面不支持卡片，可以通过自己的开发卡片使用方，进行卡片的创建、更新和删除等操作。具体参考：[卡片使用方说明](../FormLauncher/README_zh.md)。

2.安装应用，并在桌面上长按本应用的桌面图标，长按后弹出选项列表。

3.点击弹出列表中的**服务卡片**选项进入卡片添加界面。

4.点击正下方的**添加到桌面**按钮，卡片就会出现在桌面上。

### 实现效果

| 添加卡片                                    | 操作卡片                                     |
| ------------------------------------------- | -------------------------------------------- |
| ![FormGameAdd](screenshots/FormGameAdd.png) | ![FormGameAdd](screenshots/FormGamePlay.png) |

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，从API version 9开始支持。

3.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.992, built on July 14, 2022)才可编译运行。