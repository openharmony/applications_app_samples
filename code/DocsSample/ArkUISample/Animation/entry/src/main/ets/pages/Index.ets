/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Styles
function CardPressedStyle() {
  .backgroundColor('rgba(0,0,0,0.1)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Styles
function CardNormalStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Styles
function CardDisabledStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(0.5)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}


@Entry
@Component
struct AnimateIndex {
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: "animateTo",
      label: "显示动画（animateTo）",
      children: [
        { name: 'template1/Index', label: '示例1（在组件出现时创建动画）' },
        { name: 'template2/Index', label: '示例2（动画执行结束后组件消失）' },
        { name: 'template3/Index', label: '示例3（在状态管理V2中使用animateTo）' },
      ]
    },{
    name: "animation",
    label:"属性动画（animation）",
    children:[
      { name: 'template1/Index', label: '示例1' },
      { name: 'template2/Index', label: '示例2（使用animateTo产生属性动画）' },
      { name: 'template3/Index', label: '示例3（使用animation产生属性动画）' },
      { name: 'template4/Index', label: '示例4（使用keyframeAnimateTo产生属性动画）' },
    ]
  }, {
    name: "cohesion",
    label: "动画衔接",
    children:[
      { name: 'template1/Index', label: '示例1（动画衔接）' },
      { name: 'template2/Index', label: '示例2（手势与动画的衔接）' },
    ]
  }, {
    name: "keyframeAnimateTo",
    label: "关键帧动画",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "pageTransition",
    label: "页面间转场",
    children:[
      { name: 'template1/Index', label: '示例1（设置退入场动画）' },
      { name: 'template2/Index', label: '示例2（设置退入场平移效果）' },
      { name: 'template3/pageTransitionSrc1', label: '示例3（不推荐)（利用pushUrl跳转能力）' },
      { name: 'template4/pageTransitionSrc2', label: '示例4（不推荐)（type为None的页面转场）' },
    ]
  }, {
    name: "compTransition",
    label: "组件内转场",
    children:[
      { name: 'template1/Index', label: '示例1（使用同一接口实现图片出现消失）' },
      { name: 'template2/Index', label: '示例2（使用不同接口实现图片出现消失）' },
      { name: 'template3/Index', label: '示例3（设置父子组件为transition）' },
      { name: 'template4/Index', label: '示例4（出现/消失转场）' },
      { name: 'template5/Index', label: '示例5（多个组件渐次出现消失）' },
    ]
  }, {
    name: "shareTransition",
    label: "共享元素转场",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "motionPath",
    label: "路径动画",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "particle",
    label: "粒子动画",
    children:[
      { name: 'template1/Index', label: '示例1（圆形初始化粒子）' },
      { name: 'template2/Index', label: '示例2（图片初始化粒子）' },
      { name: 'template3/Index', label: '示例3（粒子扰动场的干扰下运动轨迹发生变化）' },
      { name: 'template4/Index', label: '示例4（调整粒子发射器位置）' },
      { name: 'template5/Index', label: '示例5（环形发射器创建）' },
      { name: 'template6/Index', label: '示例6（环形发射器更新）' },
    ]
  }, {
    name: "animator",
    label: "帧动画",
    children:[
      { name: 'template1/Index', label: '示例1（基于ArkTS扩展的声明式开发范式）' },
      { name: 'template2/Index', label: '示例2（位移动画示例）' },
      { name: 'template3/Index', label: '示例3（使用帧动画实现小球抛物运动）' },
    ]
  }, {
    name: "animateToImmediately",
    label: "显式动画立即下发",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "rotation",
    label: "旋转屏动画",
    children:[
      { name: 'template1/Index', label: '示例1（布局切换的旋转屏动画）' },
      { name: 'template2/Index', label: '示例2（透明度变化的旋转屏动画）' },
    ]
  }
  ];
  @State selection: string | null = null;

  @Builder
  ListItemGroupHeader(route: RouteGroup) {
    Row() {
      Text(route.label)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)

      Blank()

      Text(`${route.children.length}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .opacity(this.selection === route.name ? 0 : 1)

      Image($r('sys.media.ohos_ic_public_arrow_right'))
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
      pressed: CardPressedStyle,
      normal: CardNormalStyle,
      disabled: CardDisabledStyle,
    })
    .onClick(() => {
      animateTo(
        { curve: curves.interpolatingSpring(0, 1, 228, 25) },
        () => {
          if (this.selection === route.name) {
            this.selection = null;
          } else {
            this.selection = route.name;
          }
        });
    })
  }

  aboutToAppear(): void{
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }
  build() {
    Column() {
      Text("AnimateIndex")
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
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                      .fillColor($r('sys.color.ohos_id_color_fourth'))
                      .height(24)
                      .width(24)
                  }
                  .stateStyles({
                    pressed: CardPressedStyle,
                    normal: CardNormalStyle,
                    disabled: CardDisabledStyle,
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
                    router.pushUrl({url: name})
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