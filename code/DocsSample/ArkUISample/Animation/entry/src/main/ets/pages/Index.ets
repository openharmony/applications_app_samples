/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import curves from '@ohos.curves';
import { Route, RouteGroup } from './common/Index';
import { KeyboardAvoidMode } from '@kit.ArkUI';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';

@Styles
function cardPressedStyle() {
  .backgroundColor('rgba(0,0,0,0.1)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Styles
function cardNormalStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Styles
function cardDisabledStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(0.5)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}


@Entry
@Component
struct AnimateIndex {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: "animateTo",
      // 请将$r('app.string.animate_to_label')替换为实际资源文件，在本示例中该资源文件的value值为"显示动画（animateTo）"
      label: $r('app.string.animate_to_label'),
      children: [
        // 请将$r('app.string.animate_to_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（在组件出现时创建动画）"
        { name: 'template1/Index', label: $r('app.string.animate_to_temp_label1') },
        // 请将$r('app.string.animate_to_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（动画执行结束后组件消失）"
        { name: 'template2/Index', label: $r('app.string.animate_to_temp_label2') },
        // 请将$r('app.string.animate_to_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（在状态管理V2中使用animateTo）"
        { name: 'template3/Index', label: $r('app.string.animate_to_temp_label3') }
      ]
    },{
    name: "animation",
    // 请将$r('app.string.animation_label')替换为实际资源文件，在本示例中该资源文件的value值为"属性动画（animation）"
    label: $r('app.string.animation_label'),
    children:[
      // 请将$r('app.string.temp1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1" 
      { name: 'template1/Index', label: $r('app.string.temp1') },
      // 请将$r('app.string.animation_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（使用animateTo产生属性动画）"
      { name: 'template2/Index', label: $r('app.string.animation_temp_label2') },
      // 请将$r('app.string.animation_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（使用animation产生属性动画）"
      { name: 'template3/Index', label: $r('app.string.animation_temp_label3') },
      // 请将$r('app.string.animation_temp_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（使用keyframeAnimateTo产生属性动画）"
      { name: 'template4/Index', label: $r('app.string.animation_temp_label4') }
    ]
  }, {
    name: "animationBlur",
    // 请将$r("app.string.animation_blur_label")替换为实际资源文件，在本示例中该资源文件的value值为"模糊动画"
    label: $r("app.string.animation_blur_label"),
    children:[
      // 请将$r("app.string.animation_blur_label1")替换为实际资源文件，在本示例中该资源文件的value值为"示例1（使用backdropBlur为组件添加背景模糊）"
      { name: 'template1/BlurEffectsExample', label: $r("app.string.animation_blur_label1") },
      // 请将$r("app.string.animation_blur_label2")替换为实际资源文件，在本示例中该资源文件的value值为"示例2（使用blur为组件添加内容模糊）"
      { name: 'template2/Index', label: $r("app.string.animation_blur_label2") },
      // 请将$r("app.string.animation_blur_label3")替换为实际资源文件，在本示例中该资源文件的value值为"示例3（使用backgroundBlurStyle为组件添加背景模糊效果）"
      { name: 'template3/BackDropBlurStyleDemo', label: $r("app.string.animation_blur_label3") },
      // 请将$r("app.string.animation_blur_label4")替换为实际资源文件，在本示例中该资源文件的value值为"示例4（使用foregroundBlurStyle为组件添加内容模糊效果）"
      { name: 'template4/ForegroundBlurStyleDemo', label: $r("app.string.animation_blur_label4") },
      // 请将$r("app.string.animation_blur_label5")替换为实际资源文件，在本示例中该资源文件的value值为"示例5（使用motionBlur为组件添加运动模糊效果）"
      { name: 'template5/MotionBlurTest', label: $r("app.string.animation_blur_label5") }
    ]
  }, {
    name: "cohesion",
    // 请将$r('app.string.cohesion_label')替换为实际资源文件，在本示例中该资源文件的value值为"动画衔接"
    label: $r('app.string.cohesion_label'),
    children:[
      // 请将$r('app.string.cohesion_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（动画衔接）"
      { name: 'template1/Index', label: $r('app.string.cohesion_temp_label1') },
      // 请将$r('app.string.cohesion_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（手势与动画的衔接）"
      { name: 'template2/Index', label: $r('app.string.cohesion_temp_label2') }
    ]
  }, {
    name: "keyframeAnimateTo",
    // 请将$r('app.string.keyframeAnimateTo_label')替换为实际资源文件，在本示例中该资源文件的value值为"关键帧动画"
    label: $r('app.string.keyframeAnimateTo_label'),
    children:[
      // 请将$r('app.string.temp1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1"
      { name: 'template1/Index', label: $r('app.string.temp1') }
    ]
  }, {
    name: "pageTransition",
    // 请将$r('app.string.pageTransition_label')替换为实际资源文件，在本示例中该资源文件的value值为"页面间转场"
    label: $r('app.string.pageTransition_label'),
    children:[
      // 请将$r('app.string.pageTransition_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（设置退入场动画）"
      { name: 'template1/Index', label: $r('app.string.pageTransition_temp_label1') },
      // 请将$r('app.string.pageTransition_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（设置退入场平移效果）"
      { name: 'template2/Index', label: $r('app.string.pageTransition_temp_label2') },
      // 请将$r('app.string.pageTransition_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（不推荐)，（利用pushUrl跳转能力）"
      { name: 'template3/pageTransitionSrc1', label: $r('app.string.pageTransition_temp_label3') },
      // 请将$r('app.string.pageTransition_temp_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（不推荐)（type为None的页面转场）"
      { name: 'template4/pageTransitionSrc2', label: $r('app.string.pageTransition_temp_label4') },
      // 请将$r('app.string.pageTransition_temp_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（不推荐)（type配置为RouteType.None）"
      { name: 'template5/PageTransitionSrc3', label: $r("app.string.pageTransition_temp_label5") },
      // 请将$r('app.string.pageTransition_temp_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（不推荐)（type配置为RouteType.Push或RouteType.Pop）"
      { name: 'template6/PageTransitionSrc4', label: $r("app.string.pageTransition_temp_label6") }
    ]
  }, {
    name: "compTransition",
    // 请将$r('app.string.compTransition_label')替换为实际资源文件，在本示例中该资源文件的value值为"组件内转场"
    label: $r('app.string.compTransition_label'),
    children:[
      // 请将$r('app.string.compTransition_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（使用同一接口实现图片出现消失）"
      { name: 'template1/Index', label: $r('app.string.compTransition_temp_label1') },
      // 请将$r('app.string.compTransition_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（使用不同接口实现图片出现消失）"
      { name: 'template2/Index', label: $r('app.string.compTransition_temp_label2') },
      // 请将$r('app.string.compTransition_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（设置父子组件为transition）"
      { name: 'template3/Index', label: $r('app.string.compTransition_temp_label3') },
      // 请将$r('app.string.compTransition_temp_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（出现/消失转场）"
      { name: 'template4/Index', label: $r('app.string.compTransition_temp_label4') },
      // 请将$r('app.string.compTransition_temp_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（多个组件渐次出现消失）"
      { name: 'template5/Index', label: $r('app.string.compTransition_temp_label5') },
      // 请将$r('app.string.compTransition_temp_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（旋转转场效果出现/消失）"
      { name: 'template6/Index', label: $r('app.string.compTransition_temp_label6') }
    ]
  }, {
    name: "shareTransition",
    // 请将$r('app.string.shareTransition_label')替换为实际资源文件，在本示例中该资源文件的value值为"共享元素转场"
    label: $r('app.string.shareTransition_label'),
    children:[
      // 请将$r('app.string.shareTransition_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（共享元素转场）"
      { name: 'template1/Index', label: $r("app.string.shareTransition_label1") },
      // 请将$r('app.string.shareTransition_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（不新建容器并直接变化原容器）"
      { name: 'template2/Index', label: $r("app.string.shareTransition_label2") },
      // 请将$r('app.string.shareTransition_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（新建容器并跨容器迁移组件-结合Stack使用）"
      { name: 'template3/Index', label: $r("app.string.shareTransition_label3") },
      // 请将$r('app.string.shareTransition_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（新建容器并跨容器迁移组件-结合Navigation使用）"
      { name: 'template4/Index', label: $r("app.string.shareTransition_label4") },
      // 请将$r('app.string.shareTransition_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（新建容器并跨容器迁移组件-结合BindSheet使用）"
      { name: 'template5/Index', label: $r("app.string.shareTransition_label5") },
      // 请将$r('app.string.shareTransition_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（使用geometryTransition共享元素转场-geometryTransition的简单使用）"
      { name: 'template6/IfElseGeometryTransition', label: $r("app.string.shareTransition_label6") },
      // 请将$r('app.string.shareTransition_label7')替换为实际资源文件，在本示例中该资源文件的value值为"示例7（使用geometryTransition共享元素转场-geometryTransition结合模态转场使用）"
      { name: 'template7/Index', label: $r("app.string.shareTransition_label7") }
    ]
  }, {
    name: "motionPath",
    // 请将$r('app.string.motionPath_label')替换为实际资源文件，在本示例中该资源文件的value值为"路径动画"
    label: $r('app.string.motionPath_label'),
    children:[
      // 请将$r('app.string.temp1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1"
      { name: 'template1/Index', label: $r('app.string.temp1') }
    ]
  }, {
    name: "particle",
    // 请将$r('app.string.particle_label')替换为实际资源文件，在本示例中该资源文件的value值为"粒子动画"
    label: $r('app.string.particle_label'),
    children:[
      // 请将$r('app.string.particle_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（圆形初始化粒子）"
      { name: 'template1/Index', label: $r('app.string.particle_temp_label1') },
      // 请将$r('app.string.particle_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（图片初始化粒子）"
      { name: 'template2/Index', label: $r('app.string.particle_temp_label2') },
      // 请将$r('app.string.particle_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（粒子扰动场的干扰下运动轨迹发生变化）"
      { name: 'template3/Index', label: $r('app.string.particle_temp_label3') },
      // 请将$r('app.string.particle_temp_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（调整粒子发射器位置）"
      { name: 'template4/Index', label: $r('app.string.particle_temp_label4') },
      // 请将$r('app.string.particle_temp_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（环形发射器创建）"
      { name: 'template5/Index', label: $r('app.string.particle_temp_label5') },
      // 请将$r('app.string.particle_temp_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（环形发射器更新）"
      { name: 'template6/Index', label: $r('app.string.particle_temp_label6') }
    ]
  }, {
    name: "animator",
    // 请将$r('app.string.animator_label')替换为实际资源文件，在本示例中该资源文件的value值为"帧动画"
    label: $r('app.string.animator_label'),
    children:[
      // 请将$r('app.string.animator_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（基于ArkTS扩展的声明式开发范式）"
      { name: 'template1/Index', label: $r("app.string.animator_temp_label1") },
      // 请将$r('app.string.animator_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（位移动画示例）"
      { name: 'template2/Index', label: $r("app.string.animator_temp_label2") },
      // 请将$r('app.string.animator_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（使用帧动画实现小球抛物运动）"
      { name: 'template3/Index', label: $r("app.string.animator_temp_label3") },
      // 请将$r('app.string.animator_temp_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（使用帧动画实现小球抛物运动）"
      { name: 'template4/Index', label: $r("app.string.animator_temp_label4") }
    ]
  }, {
    name: "animateToImmediately",
    // 请将$r('app.string.animateToImmediately_label')替换为实际资源文件，在本示例中该资源文件的value值为"显式动画立即下发"
    label: $r('app.string.animateToImmediately_label'),
    children:[
      // 请将$r('app.string.temp1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1"
      { name: 'template1/Index', label: $r('app.string.temp1') }
    ]
  }, {
    name: "rotation",
    // 请将$r('app.string.rotation_label')替换为实际资源文件，在本示例中该资源文件的value值为"旋转屏动画"
    label: $r('app.string.rotation_label'),
    children:[
      // 请将$r('app.string.rotation_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（布局切换的旋转屏动画）"
      { name: 'template1/Index', label: $r('app.string.rotation_temp_label1') },
      // 请将$r('app.string.rotation_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（透明度变化的旋转屏动画）"
      { name: 'template2/Index', label: $r('app.string.rotation_temp_label2') }
    ]
  }, {
    name: "animatableProperty",
    // 请将$r('app.string.animatableProperty_label')替换为实际资源文件，在本示例中该资源文件的value值为"自定义属性动画"
    label: $r("app.string.animatableProperty_label"),
    children:[
      // 请将$r('app.string.animatableProperty_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（改变Text组件宽度）"
      { name: 'template1/Index', label: $r("app.string.animatableProperty_temp_label1") },
      // 请将$r('app.string.animatableProperty_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（改变图形形状）"
      { name: 'template2/Index', label: $r("app.string.animatableProperty_temp_label2") },
      ]
  }, {
    name: "component",
    // 请将$r('app.string.component_label')替换为实际资源文件，在本示例中该资源文件的value值为"组件动画"
    label: $r('app.string.component_label'),
    children:[
      // 请将$r('app.string.component_temp_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（使用组件默认动画）"
      { name: 'template1/Index', label: $r('app.string.component_temp_label1') },
      // 请将$r('app.string.component_temp_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（Scroll组件滑动动效）"
      { name: 'template2/Index', label: $r('app.string.component_temp_label2') },
      // 请将$r('app.string.component_temp_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（List组件动态替换动效）"
      { name: 'template3/Index', label: $r('app.string.component_temp_label3') },
    ]
  }, {
    name: "traditionalCurve",
    // 请将$r('app.string.traditionalCurve_label')替换为实际资源文件，在本示例中该资源文件的value值为"传统曲线"
    label: $r("app.string.traditionalCurve_label"),
    children:[
      // 请将$r('app.string.temp1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1"
      { name: 'template1/CurveDemo', label: $r("app.string.temp1") }
    ]
  }, {
    name: "springCurve",
    // 请将$r('app.string.springCurve_label')替换为实际资源文件，在本示例中该资源文件的value值为"弹簧曲线"
    label: $r("app.string.springCurve_label"),
    children:[
      // 请将$r('app.string.temp1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1"
      { name: 'template1/SpringCurve', label: $r("app.string.temp1") }
    ]
  }, {
    name: "modalTransition",
    // 请将$r('app.string.modal_transition_label')替换为实际资源文件，在本示例中该资源文件的value值为"模态转场"
    label: $r("app.string.modal_transition_label"),
    children:[
      // 请将$r('app.string.modal_transition_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（使用bindContentCover构建全屏模态转场效果）"
      { name: 'template1/BindContentCoverDemo', label: $r("app.string.modal_transition_label1") },
      // 请将$r('app.string.modal_transition_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（使用bindSheet构建半模态转场效果）"
      { name: 'template2/BindSheetDemo', label: $r("app.string.modal_transition_label2") },
      // 请将$r('app.string.modal_transition_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（使用bindMenu实现菜单弹出效果）"
      { name: 'template3/BindMenuDemo', label: $r("app.string.modal_transition_label3") },
      // 请将$r('app.string.modal_transition_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（使用bindContextMenu实现菜单弹出效果）"
      { name: 'template4/BindContextMenuDemo', label: $r("app.string.modal_transition_label4") },
      // 请将$r('app.string.modal_transition_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（使用bindPopup实现气泡弹窗效果）"
      { name: 'template5/BindPopupDemo', label: $r("app.string.modal_transition_label5") },
      // 请将$r('app.string.modal_transition_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（使用if实现模态转场）"
      { name: 'template6/ModalTransitionWithIf', label: $r("app.string.modal_transition_label6") }
    ]
  }
  ];
  @State selection: string | null = null;

  @Builder
  ListItemGroupHeader(route: RouteGroup) {
    Row() {
      Text(route.label)
      // 请将$r('app.string.ohos_id_color_text_primary')替换为实际资源文件，在本示例中该资源文件的value值为"#FFFFFF"
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)

      Blank()

      Text(`${route.children.length}`)
      // $r('sys.color.ohos_id_color_text_secondary')需要替换为开发者所需的资源文件
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .opacity(this.selection === route.name ? 0 : 1)

      // $r('sys.media.ohos_ic_public_arrow_right')需要替换为开发者所需的资源文件
      Image($r('sys.media.ohos_ic_public_arrow_right'))
         // $r('sys.color.ohos_id_color_fourth')需要替换为开发者所需的资源文件
        .fillColor($r('sys.color.ohos_id_color_fourth'))
        .height(24)
        .width(24)
        .rotate({ angle: this.selection === route.name ? 90 : 0 })
        .animation({ curve: curves.interpolatingSpring(0, 1, 228, 30) })
    }
    .borderRadius(20)
    .width('100%')
    .padding(8)
    .enabled(!!route.children.length)
    .stateStyles({
      pressed: cardPressedStyle,
      normal: cardNormalStyle,
      disabled: cardDisabledStyle,
    })
    .onClick(() => {
      this.getUIContext().animateTo(
        { curve: curves.interpolatingSpring(0, 1, 228, 25) },
        () => {
          if (this.selection === route.name) {
            this.selection = null;
          } else {
            this.selection = route.name;
          }
        }
      );
    })
  }

  aboutToAppear(): void{
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }
  build() {
    Column() {
      // 请将$r('app.string.AnimateIndex')替换为实际资源文件，在本示例中该资源文件的value值为"AnimateIndex"
      Text($r('app.string.AnimateIndex'))
      List() {
        ForEach(this.routes, (routeGroup: RouteGroup) => {
          ListItemGroup({
            header: this.ListItemGroupHeader(routeGroup),
            style: ListItemGroupStyle.CARD,
          }) {
            if (routeGroup.name === this.selection) {
              ForEach(routeGroup.children, (route: Route) => {
                ListItem() {
                  Row() {
                    Text(route.label).fontSize(16)
                    Blank()
                    // $r('sys.media.ohos_ic_public_arrow_right')需要替换为开发者所需的资源文件
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                       // $r('sys.color.ohos_id_color_fourth')需要替换为开发者所需的资源文件
                      .fillColor($r('sys.color.ohos_id_color_fourth'))
                      .height(24)
                      .width(24)
                  }
                  .stateStyles({
                    pressed: cardPressedStyle,
                    normal: cardNormalStyle,
                    disabled: cardDisabledStyle,
                  })
                  .borderRadius(20)
                  .padding(8)
                  .transition(
                    TransitionEffect.OPACITY.animation({
                      curve: curves.interpolatingSpring(0, 1, 228, 30)
                    })
                  )
                  .width('100%')
                  .onClick(() => {
                    const name = `pages/${routeGroup.name}/${route.name}`;
                    this.getUIContext().getRouter().pushUrl({url:name});
                  })
                }
                .width('100%')
              })
            }
          }
          .padding(2)
          .divider({ strokeWidth: 0.5 })
        })
      }.padding({bottom: 10})
    }
  }
}