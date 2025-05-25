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
struct Index {
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: 'navigation',
      label: 'Navigation',
      children: [
        { name: 'template1/Index', label: '示例1（Navigation页面布局）' },
        { name: 'template2/Index', label: '示例2（使用路由栈方法）' },
        { name: 'template3/Index', label: '示例3（设置可交互转场动画）' },
        { name: 'template4/Index', label: '示例4（Navigation带参返回）' },
        { name: 'template5/Index', label: '示例5（设置背景颜色和模糊效果）' },
        { name: 'template6/Index', label: '示例6（嵌套场景下获取外层栈）' },
        { name: 'template7/Index', label: '示例7（通过onReady获取栈）' },
        { name: 'template8/Index', label: '示例8（NavDestination生命周期时序）' },
        { name: 'template9/Index', label: '示例9（标题栏布局效果）' },
        { name: 'template10/Index', label: '示例10（定义路由栈派生类）' },
        { name: 'template11/Index', label: '示例11（使用Symbol组件）' },
        { name: 'template12/Index', label: '示例12（设置自定义标题栏边距）' },
        { name: 'template13/Index', label: '示例13（自定义转场动画）' },
      ]
    },
    {
      name: 'navDestination',
      label: 'NavDestination',
      children: [
        { name: 'template1/Index', label: '示例1（标题栏工具栏与可滚动类组件联动）' },
        { name: 'template2/Index', label: '示例2（设置NavDestination自定义转场）' },
        { name: 'template3/Index', label: '示例3（设置指定的NavDestination系统转场）' },
        { name: 'template4/Index', label: '示例4（NavDestination配置页面方向和对应状态栏、导航条显隐）' },
      ]
    }, {
      name: 'observer',
      label: '无感监听',
      children: [
        { name: 'template1/Index', label: "uiObserver.on('navDestinationUpdate')" },
        { name: 'template2/Index', label: "uiObserver.on('navDestinationUpdate')指定监听" },
        { name: 'template3/Index', label: "uiObserver.on('navDestinationSwitch')" },
        { name: 'template4/Index', label: "uiObserver.on('navDestinationSwitch')指定监听" },
      ]
    }, {
      name: 'sideBarContainer',
      label: 'SideBarContainer',
      children: [
        { name: 'template1/Index', label: '示例1' },
      ]
    }, {
      name: "navPathStackExtend",
      label: 'NavPathStack派生类',
      children: [
        { name: 'template1/Index', label: "queryNavDestinationInfo18+" },
      ]
    }, {
      name: 'router',
      label: 'Router',
      children: [
        { name: 'template1/Index', label: '基于TS扩展的声明式开发范式' },
      ]
    }, {
      name: 'stepper',
      label: 'Stepper',
      children: [
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
      Text("Index")
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