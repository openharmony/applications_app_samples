# FormProvider 添加主动刷新服务卡片

### 介绍

本示例展示了在一个Stage模型中，开发基于ArkTS UI的卡片管理加桌指导。

在桌面添加服务卡片。

### 效果预览

| "1x1" | "1x2" | "2x2" | "2x4" | "4x4" | "4x6" |
|-------|-------|-------|-------|-------|-------|
| ![image](screenshot/Form11.jpg) | ![image](screenshot/Form12.jpg) | ![image](screenshot/Form22.jpg) | ![image](screenshot/Form24.jpg) | ![image](screenshot/Form44.jpg) | ![image](screenshot/Form46.jpg) |

使用说明

1. 在桌面长按应用图标，拉起卡片管理页面。

2. 用户可在卡片管理页面， 左右滑动切换卡片，点击“添加至桌面”按钮，此时在桌面即可看到新添加的卡片。

### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets                   // 主进程UIAbility
|---entryformability
|   |---EntryFormAbility.ets               // 卡片进程Ability
|---pages
|   |---Index.ets                          // 应用内添加拉起卡片管理页面入口页面
|---widget_1_1
|   |---pages
|   |   |---Widget_1_1Card.ets             // 卡片页
|---widget_1_2
|   |---pages
|   |   |---Widget_1_2Card.ets             // 卡片页
|---widget_2_2
|   |---pages
|   |   |---Widget_2_2Card.ets             // 卡片页
|---widget_2_4
|   |---pages
|   |   |---Widget_2_4Card.ets             // 卡片页
|---widget_4_4
|   |---pages
|   |   |---Widget_4_4Card.ets             // 卡片页
|---widget_6_4
|   |---pages
|   |   |---Widget_6_4Card.ets             // 卡片页
```

### 具体实现

  * 创建卡片，参考[创建卡片](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/form/arkts-ui-widget-creation.md)。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568。

2. 本示例支持API version 20版本SDK，版本号：6.0.0.47。

3.  本示例已支持使DevEco Studio 6.0.0 Release (构建版本：6.0.0.858，构建 2025年10月21日)编译运行。

4. 高等级APL特殊签名说明：无。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code\DocsSample\Form\FormProvider > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```