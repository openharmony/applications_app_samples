/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import curves from '@ohos.curves';
import { Route, RouteGroup } from './common/Index';
import { KeyboardAvoidMode } from '@kit.ArkUI';
import router from '@ohos.router';

@Styles
function cardPressedStyle() {
  .backgroundColor('rgba(0,0,0,0.1)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
};

@Styles
function cardNormalStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
};

@Styles
function cardDisabledStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(0.5)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
};

@Entry
@Component
struct Index {
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: 'navigation',
      label: 'Navigation',
      children: [
        { name: 'template1/PageDisplayModeAuto', label: $r('app.string.pageDisplayModeAuto') },
        { name: 'template1/PageDisplayModeStack', label: $r('app.string.pageDisplayModeStack') },
        { name: 'template1/PageDisplayModeSplit', label: $r('app.string.pageDisplayModeSplit') },
        { name: 'template1/TitleModeMini', label: $r('app.string.titleModeMini') },
        { name: 'template1/TitleModeFull', label: $r('app.string.titleModeFull') },
        { name: 'template1/MenusThreeResource', label: $r('app.string.menusThreeResource') },
        { name: 'template1/MenusThreeImage', label: $r('app.string.menusThreeImage') },
        { name: 'template1/MenusFour', label: $r('app.string.menusFour') },
        { name: 'template1/ToolBar', label: $r('app.string.toolBar') },
        { name: 'template1/PageDisplayType', label: $r('app.string.pageDisplayType') },
        { name: 'template1/PageAnimated', label: $r('app.string.pageAnimated') },
        { name: 'template1/PageOnceClose', label: $r('app.string.pageOnceClose') },
        { name: 'template1/GeometryTransition', label: $r('app.string.geometryTransition') },
        { name: 'template1/PageOne', label: $r('app.string.systemRoutingTable') },
        { name: 'template1/CustomRoutingTable', label: $r('app.string.customRoutingTable') },
        { name: 'template7/PageOne', label: $r('app.string.onReadyParam_text7') },
        { name: 'template7/PageTwo', label: $r('app.string.onResultParam_text7') },
        { name: 'template1/NavigationExample', label: $r('app.string.navigationExample') },
        { name: 'template2/Index', label: $r('app.string.stepperIndex_text2') },
        { name: 'template4/Index', label: $r('app.string.stepperIndex_text4') },
      ]
    },
    {
      name: 'observer',
      label: $r('app.string.stepperIndex_text18'),
      children: [
        { name: 'template1/Index', label: $r('app.string.watchPageInfo') },
        { name: 'template2/Index', label: $r('app.string.stepperIndex_text19') },
        { name: 'template3/Index', label: $r('app.string.uiObserverCallbackFunc') }
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
      pressed: cardPressedStyle,
      normal: cardNormalStyle,
      disabled: cardDisabledStyle,
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
  };

  aboutToAppear(): void{
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }
  build() {
    Column() {
      Text('Index')
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
      .id('list')
    }
  }
}