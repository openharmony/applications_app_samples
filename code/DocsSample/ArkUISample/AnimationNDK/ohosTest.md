# AnimationNDK 测试用例归档

## 用例表

| 测试功能                         | 预置条件   | 输入                                     | 预期输出                                   | 是否自动 | 测试结果 |
|------------------------------|--------|----------------------------------------|----------------------------------------|:-----|------|
| AnimationNDK 示例运行正常         | 设备正常运行 | 进入首页                                   | 预期显示“关键帧动画，animateTo动画，transition，以及animator” 四个模块动画   | 是    | Pass |
| KeyFrameAnimeteto动画运行正常             | 设备正常运行 | 进入首页-点击UseFrameAnimation进入动画页面-滑动到页面底部-点击关键帧动画下的组件                   | 预期动画可以正常执行                  | 是    | Pass |
| Animeteto动画运行正常 | 设备正常运行 | 进入首页-点击UseFrameAnimation进入动画页面-点击Animeteto下的组件 | 预期Animeteto动画正常执行 | 是    | Pass |
| Transition动画运行正常                  | 设备正常运行 | 进入首页-点击TransitionAnimation进入转场动画页面-点击show按钮                           | 组件显隐动画正常执行                      | 是    | Pass |
| 一镜到底转场动画运行正常                  | 设备正常运行 | 进入首页-点击TransitionAnimation进入转场动画页面-点击下方显示的圆形图片                           | 组件显隐动画正常执行                      | 是    | Pass |
| animator动画运行正常          | 设备正常运行 | 进入首页-点击UseFrameAnimation进入动画页面-点击create-点击play              | animator动画可以正常执行                                 | 是    | Pass |