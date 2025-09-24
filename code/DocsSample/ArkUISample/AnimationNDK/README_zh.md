# UseAnimationNDK

## 介绍

本示例展示了keyFrameAnimeteto、animateTo、tranisation及animator动画。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./screenshots/Animation.gif" width="300" />

## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 点击关键帧动画下的组件，触发关键帧动画；
3. 点击Animeteto下的组件，触发AnimateTo动画；
4. 点击transition按键，触发组件显隐动画；
5. 点击create后点击play，触发Animator动画；


## 工程目录

```
TextAreaEventNDK
entry/src/main/ets/
└── pages
    └── Index.ets (显示动画页面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libentry
│   │       └── Index.d.ts (对应的js映射)
│   ├── ArkUIAnimate.h (动画页面实现)
|   ├── ArkUIBaseNode.h (提供组件挂载与卸载)
|   ├── ArkUIButtonNode.h (button组件实现)
|   ├── ArkUIColumnNode.h (column组件实现)
|   ├── ArkUIListItemNode.h (listItem实现)
|   ├── ArkUIListNode.h (list组件实现)
|   ├── ArkUINode.h (通用属性实现)
|   ├── ArkUIScrollNode.h (scroll实现)
|   ├── ArkUITextNode.h (text组件实现)
|   ├── NativeEntry.cpp (使动画节点挂载到页面节点)
│   └── napi_init.cpp
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

1. 本示例支持标准系统上运行，支持设备：RK3568。

2. 本示例为Stage模型，支持API19版本full-SDK，版本号：5.1.1.208，镜像版本号：OpenHarmony_5.1.1 Release。

3. 本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.830, built on August 4, 2025)及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/TextAreaEventNDK > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```