# 嵌入ArkTS组件

## 介绍

ArkUI在Native侧提供的能力作为ArkTS的子集，部分能力不会在Native侧提供，如声明式UI语法，自定义struct组件，UI高级组件。

针对需要使用ArkTS侧独立能力的场景，ArkUI开发框架提供了Native侧嵌入ArkTS组件的能力，该能力依赖[ComponentContent](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/js-apis-arkui-ComponentContent.md)机制，通过ComponentContent完成对ArkTS组件的封装，然后将封装对象转递到Native侧，通过Native侧的[OH_ArkUI_GetNodeHandleFromNapiValue](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-node-napi-h.md#oh_arkui_getnodehandlefromnapivalue)接口转化为ArkUI_NodeHandle对象用于Native侧组件挂载使用。

本示例展示了ArkUI在Native侧提供的能力作为ArkTS的子集，部分能力不会在Native侧提供，如声明式UI语法，自定义struct组件，UI高级组件。

本示例为 [嵌入ArkTS组件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-embed-arkts-components.md) 的配套示例工程。

## 效果预览

| 预览                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/refresh_text_list.gif" width="300" /> |
## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 进入首页，可点击按钮。
3. 下拉组件可以查看到效果。


## 工程目录

```
├── cpp
│   ├── ArkUIBaseNode.h
│   ├── ArkUIListItemNode.h
│   ├── ArkUIListNode.h
│   ├── ArkUIMixedNode.h
│   ├── ArkUIMixedRefresh.cpp
│   ├── ArkUIMixedRefresh.h
│   ├── ArkUIMixedRefreshTemplate.cpp
│   ├── ArkUIMixedRefreshTemplate.h
│   ├── ArkUINode.h
│   ├── ArkUITextNode.h
│   ├── CMakeLists.txt
│   ├── MixedRefreshExample.h
│   ├── NativeEntry.cpp
│   ├── NativeEntry.h
│   ├── NativeModule.h
│   ├── NormalTextListExample.h
│   ├── UITimer.h
│   ├── napi_init.cpp
│   └── types
│       └── libentry
│           ├── Index.d.ts
│           └── oh-package.json5
└── ets
    └── pages
        ├── Index.ets
        └── MixedModule.ets
```

## 具体实现

1. 注册ArkTS组件创建函数给Native侧，以便Native侧调用，创建函数使用ComponentContent能力进行封装。
2. 将创建和更新函数注册给Native侧。
3. Native侧通过Node-API保存创建和更新函数，用于后续调用。
4. 抽象混合模式下组件的基类，用于通用逻辑管理。
5. 实现Refresh组件的混合模式封装对象。
6. 定时器模块相关简单实现。
7. 将Refresh组件作为文本列表的父组件。
8. 在Native侧提供Node-API的桥接方法，实现ArkTS侧的NativeNode模块接口。

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API22版本SDK，版本号：6.0.2.54;

3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年10月23日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeType/NdkEmbedArktsComponents > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```