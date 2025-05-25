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
struct VisionEffectIndex {
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: "transform",
      label: "图形变换",
      children: [
        { name: 'template1/Index', label: '示例1（为组件添加图形变换效果）' },
        { name: 'template2/Index', label: '示例2（设置旋转视距）' },
        { name: 'template3/Index', label: '示例3（按中心点旋转）' },
      ]
    },{
    name: "opacity",
    label:"透明度设置",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "clip",
    label: "形状裁剪",
    children:[
      { name: 'template1/Index', label: '示例1（使用不同裁剪属性）' },
      { name: 'template2/Index', label: '示例2（裁剪属性动画）' },
    ]
  }, {
    name: "imageEffect",
    label: "图像效果",
    children:[
      { name: 'template1/Index', label: '示例1（设置图片不同属性效果）' },
      { name: 'template2/Index', label: '示例2（设置组件线性渐变模糊效果）' },
      { name: 'template3/Index', label: '示例3（设置离屏渲染效果）' },
      { name: 'template4/Index', label: '示例4（当前组件内容与下方画布内容混合）' },
      { name: 'template5/Index', label: '示例5（前景智能取反色）' },
      { name: 'template6/Index', label: '示例6（设置同层阴影不重叠效果）' },
      { name: 'template7/Index', label: '示例7（设置组件图像球面效果）' },
      { name: 'template8/Index', label: '示例8（设置组件图像渐亮效果）' },
      { name: 'template9/Index', label: '示例9（设置组件图像边缘像素扩展效果）' },
      { name: 'template10/Index', label: '示例10（系统导航条智能反色）' },
    ]
  }, {
    name: "background",
    label: "背景设置",
    children:[
      { name: 'template1/Index', label: '示例1（设置背景基础样式）' },
      { name: 'template2/Index', label: '示例2（设置背景模糊样式）' },
      { name: 'template3/Index', label: '示例3（设置组件背景）' },
      { name: 'template4/Index', label: '示例4（设置组件背景提亮效果）' },
      { name: 'template5/Index', label: '示例5（设置模糊属性）' },
      { name: 'template6/Index', label: '示例6（设置文字异形模糊效果）' },
      { name: 'template7/Index', label: '示例7（模糊效果对比）' },
    ]
  }, {
    name: "foregroundBlurStyle",
    label: "组件内容模糊",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "foregroundColor",
    label: "前景色设置",
    children:[
      { name: 'template1/Index', label: '示例1（使用前景色设置）' },
      { name: 'template2/Index', label: '示例2（设置前景色为组件背景色反色）' },
      { name: 'template3/Index', label: '示例3（前置景色未继承父组件）' },
    ]
  }, {
    name: "clickEffect",
    label: "点击回弹效果",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "useEffect",
    label: "特效绘制合并",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "renderFit",
    label: "组件内容填充方式",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "outline",
    label: "外描边设置",
    children:[
      { name: 'template1/Index', label: '示例1（使用外描边属性）' },
      { name: 'template2/Index', label: '示例2（使用LocalizedEdgeColors类型）' },
    ]
  }, {
    name: "motionBlur",
    label: "运动模糊",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "linearGradient",
    label: "颜色渐变",
    children:[
      { name: 'template1/Index', label: '示例1（颜色从右向左线性渐变）' },
      { name: 'template2/Index', label: '示例2（颜色按旋转角度渐变）' },
      { name: 'template3/Index', label: '示例3（颜色按径向渐变）' },
    ]
  }, {
    name: "foregroundEffect",
    label: "前景属性设置",
    children:[
      { name: 'template1/Index', label: '示例1' },
    ]
  }, {
    name: "visualEffect",
    label: "视效设置",
    children:[
      { name: 'template1/Index', label: '示例1' },
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
      Text("VisionEffectIndex")
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