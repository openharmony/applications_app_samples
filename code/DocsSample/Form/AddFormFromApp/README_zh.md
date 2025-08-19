# 应用内拉起卡片管理加桌

### 介绍
卡片开发服务支持将应用的ArkTS卡片添加到桌面。

### 效果预览

### 工程目录

```
entry/src/main/ets/
├── entryability
│   └── EntryAbility.ets
└── pages
    └── Index.ets             // 拉起卡片管理界面

```

### 具体实现 
桌面提供统一的卡片管理页面。应用通过[formProvider](../reference/apis-form-kit/js-apis-app-form-formProvider.md)模块提供的[openFormManager](../reference/apis-form-kit/js-apis-app-form-formProvider.md#formprovideropenformmanager18)接口，能够拉起卡片管理页面，触发卡片添加至桌面操作，点击“添加至桌面”，实现卡片添加至桌面的功能。


### 相关权限

不涉及。

### 依赖


### 约束与限制


### 下载
