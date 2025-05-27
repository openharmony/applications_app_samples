# ArkUI使用动效组件指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [显示动画（animateTo）](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-explicit-animation.md)。
2. [属性动画（animation）](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-animatorproperty.md)。
3. [动画衔接](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-animation-smoothing.md)。
4. [关键帧动画](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-keyframeAnimateTo.md)。
5. [页面间转场](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-page-transition-animation.md)。
6. [组件内转场](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-transition-animation-component.md)。
7. [共享元素转场](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-transition-animation-shared-elements.md)。
8. [路径动画](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-motion-path-animation.md)。
9. [粒子动画](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-particle-animation.md)。
10. [帧动画](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/js-apis-animator.md)。
11. [显式动画立即下发](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-explicit-animatetoimmediately.md)。
12. [旋转屏动画](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-rotation-transition-animation.md)。


### 效果预览

| 首页                                 |
|------------------------------------|
| ![](screenshots/device/image1.png) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---entryability
|---pages
|   |---animateTo                       //显示动画（animateTo） 
|   |   |---template1         
|   |   |   |---Index.ets           //示例1（在组件出现时创建动画）
|   |   |---template2    
|   |   |   |---Index.ets                //示例2（动画执行结束后组件消失）
|   |   |---template3                    
|   |   |   |---Index.ets            //示例3（在状态管理V2中使用animateTo）
|   |---animateToImmediately                      //显式动画立即下发
|   |   |---template1
|   |   |   |---Index.ets
|   |---animation                             //属性动画（animation）
|   |   |---template1
|   |   |   |---Index.ets
|   |   |---template2                   
|   |   |   |---Index.ets          //示例2（使用animateTo产生属性动画）
|   |   |---template3             
|   |   |   |---Index.ets        //示例3（使用animation产生属性动画）
|   |   |---template4         
|   |   |   |---Index.ets         //示例4（使用keyframeAnimateTo产生属性动画）
|   |---animator              //帧动画
|   |   |---template1        //示例1（基于ArkTS扩展的声明式开发范式）
|   |   |   |---Index.ets
|   |   |---template2          //示例2（位移动画示例）
|   |   |   |---Index.ets
|   |   |---template3           //示例3（使用帧动画实现小球抛物运动）
|   |   |   |---Index.ets
|   |---cohesion                  //动画衔接
|   |   |---template1
|   |   |   |---Index.ets
|   |   |---template2
|   |   |   |---Index.ets
|   |---compTransition                 //组件内转场
|   |   |---template1     
|   |   |   |---Index.ets            //示例1（使用同一接口实现图片出现消失）
|   |   |---template2       
|   |   |   |---Index.ets       //示例2（使用不同接口实现图片出现消失）
|   |   |---template3       
|   |   |   |---Index.ets       //示例3（设置父子组件为transition）
|   |   |---template4      
|   |   |   |---Index.ets        //示例4（出现/消失转场）
|   |   |---template5       
|   |   |   |---Index.ets    //示例5（多个组件渐次出现消失）
|   |---keyframeAnimateTo                      //关键帧动画
|   |   |---template1
|   |   |   |---Index.ets     
|   |---motionPath                   //路径动画
|   |   |---template1
|   |   |   |---Index.ets          
|   |---pageTransition                       //页面间转场
|   |   |---template1      
|   |   |   |---Index.ets         //示例1（设置退入场动画）
|   |   |---template2      
|   |   |   |---Index.ets      //示例2（设置退入场平移效果）
|   |   |---template3    
|   |   |   |---Index.ets     //示例3（不推荐)（利用pushUrl跳转能力）
|   |   |---template4     
|   |   |   |---Index.ets         //示例4（不推荐)（type为None的页面转场）
|   |---particle                          //粒子动画
|   |   |---template1       
|   |   |   |---Index.ets      //示例1（圆形初始化粒子）
|   |   |---template2      
|   |   |   |---Index.ets     //示例2（图片初始化粒子）
|   |   |---template3     
|   |   |   |---Index.ets     //示例3（粒子扰动场的干扰下运动轨迹发生变化）
|   |   |---template4         
|   |   |   |---Index.ets         //示例4（调整粒子发射器位置）  
|   |   |---template5     
|   |   |   |---Index.ets          //示例5（环形发射器创建）
|   |   |---template6       
|   |   |   |---Index.ets        //示例6（环形发射器更新）
|   |---rotation                          //旋转屏动画
|   |   |---template1
|   |   |   |---Index.ets       
|   |   |---template2
|   |   |   |---Index.ets       
|   |---shareTransition                        //共享元素转场
|   |   |---template1
|   |   |   |---Index.ets        
|---pages
|   |---Index.ets                       // 应用主页面
entry/src/ohosTest/
|---ets
|   |---test
|   |   |---AnimateTo.test.ets                      // 显示动画（animateTo）示例代码测试代码
|   |   |---AnimateToImmediately.test.ets                     // 显式动画立即下发示例代码测试代码
|   |   |---Animation.test.ets                            // 属性动画（animation）示例代码测试代码
|   |   |---Animator.test.ets             // 帧动画示例代码测试代码
|   |   |---Cohesion.test.ets                 //动画衔接示例代码测试代码
|   |   |---ComponentTransition.test.ets                //组件内转场示例代码测试代码
|   |   |---KeyFrameAnimateTo.test.ets                     // 关键帧动画示例代码测试代码
|   |   |---MotionPath.test.ets                  // 路径动画示例代码测试代码
|   |   |---PageTransition.test.ets                      // 页面间转场示例代码测试代码
|   |   |---Particle.test.ets                         // 粒子动画示例代码测试代码
|   |   |---Rotation.test.ets                         // 旋转屏动画示例代码测试代码
|   |   |---ShareTransition.test.ets                       // 共享元素转场示例代码测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Canary1 (Build Version: 6.0.0.270， built on May 9, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/Animation > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````