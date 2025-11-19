# UseAnimationNDK

## 介绍

本示例展示了keyFrameAnimeteto、animateTo、tranisation及animator动画。该工程中展示的接口详细描述可查如下链接：

[native_animate.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-animate-h.md)。

## 效果预览

| 预览                                      | 组件转场效果预览                                               |
| -------------------------------------------- |--------------------------------------------------------|
|<img src="./screenshots/Animation.gif" width="300" />| <img src="./screenshots/Animation2.gif" width="300" /> |

## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 点击关键帧动画下的组件，触发关键帧动画；
3. 点击Animeteto下的组件，触发AnimateTo动画；
4. 点击transition按键，触发组件显隐动画；
5. 点击create后点击play，触发Animator动画；

## 工程目录

```
AnimationNDK
entry/src/main/ets/
└── pages
    └── Index.ets
    └── TransitionAnimation.ets
    └── UseFrameAnimation.ets
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
|   ├── ArkUITransition.h
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
### 具体实现

1. 组件出现/消失转场
  组件内转场通过NODE_XX_TRANSITION属性（XX包括：OPACITY、TRANSLATE、SCALE、ROTATE、MOVE）配置转场参数，在组件插入和删除时显示过渡动效
  （通过NODE_TRANSFORM_CENTER属性设置NODE_SCALE_TRANSITION和NODE_ROTATE_ROTATE动效的中心点坐标）。主要用于容器组件中子组件插入和删除时，提升用户体验。
2. 使用关键帧动画
  keyframeAnimateTo接口来指定若干个关键帧状态，实现分段的动画。同属性动画，布局类改变宽高的动画，内容都是直接到终点状态。
3. 使用帧动画
  帧动画具有逐帧回调的特性，便于开发者在每一帧中调整所需属性。通过提供onFrame逐帧回调，帧动画允许开发者在应用的每一帧设置属性值，从而实现组件属性值变化的自然过渡，营造出流畅的动画效果。帧动画接口可参考createAnimator。
  与属性动画相比，帧动画能让开发者实时感知动画进程，即时调整UI值，并具备事件即时响应和可暂停的优势，但在性能方面略逊于属性动画。当属性动画能满足需求时，建议优先采用属性动画接口实现。animateTo接口的使用可参考使用属性动画。

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568。

2. 本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3. 本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.830, built on August 4, 2025)及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/AnimationNDK > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```