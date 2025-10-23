# Native_node_napi

## 介绍

本示例基于[native_node.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-node-h.md)、[native_node_napi.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-node-napi-h.md)展示了如何通过调用CAPI提供的相关方法来获取、设置navigation组件等组件的相关属性和信息，以及将ArkTS侧创建的DrawableDescriptor对象映射到native侧的ArkUI_DrawableDescriptor。

## 效果预览

| 首页 | navigation页面                                           |
| ---- | -------------------------------------------------------- |
|      | <img src='.\screenshots\page_navigation.jpeg' width=300> |
|      | <img src='.\screenshots\mappingDescriptor.jpeg' width=300> |

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 进入首页，可选择不同模块页面。
3. 点击navigation选择框进入navigation组件相关的CAPI接口展示界面，通过点击不同的按钮来触发不同的事件，具体结果在log中查看；
4. 点击accessibility选择框进入accessibility组件相关的CAPI接口展示界面，在屏幕朗读模式下，通过点击等行为来感知具体的无障碍属性，具体结果在log中查看；
5. 点击embedded component选择框进入embedded component组件相关的CAPI接口展示界面，通过hdc设置不同的参数配置来触发不同的事件，具体结果在log中查看；
6. 点击Mapping DrawableDescriptor选择项进入DrawableDescriptor映射页面，通过点击按钮方式1:GetDrawableDescriptorFromNapiValue，来触发DrawableDescriptor的映射接口，若接口成功调用可以在DevEco Studio开发环境中的日志界面看到如下相关日志信息：
```
"success to get drawable descriptor"
```

## 工程目录

```
native_type_sample
entry/src/main/ets/
└── pages
    ├── Index.ets (获取导航页面)
    ├── page_navigation.ets (获取导航页面)
    ├── page_accessibility.ets (无障碍界面)
    ├── page_embedded_component.ets (嵌入式组件界面)
    └── GetDrawableDescriptor.ets (映射DrawableDescriptor页面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libentry
│   │       └── Index.d.ts (函数对应的js映射)
│   ├── CMakeLists.txt (CMake脚本)
|   ├── manager.cpp 
|   ├── manager.h
│   ├── napi_init.cpp
|   ├── .......
|   ├── AccessibilityMaker.h
|   ├── AccessibilityMaker.cpp
|   ├── EmbeddedComponentMaker,cpp
|   ├── EmbeddedComponentMaker.h
|   ├── NavigationContext.cpp
│   └── NavigationContext.h
└── resources
    ├── base
    │   ├── element
    │   │   ├── color.json
    │   │   ├── float.json
    │   │   └── string.json
    │   └── media
```

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API20版本SDK，版本号：6.0.0.36;

3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年9月20日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeNodeNapi/native_node_napi > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```