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
struct ComponentExtension {
  @Provide('router') router: NavPathStack = new NavPathStack();
  //$r('app.string.xxx')需要替换为开发者所需的字符串资源文件
  @State routes: RouteGroup[] = [
    {
      name: 'FocusOnclickExample',
      label: $r('app.string.FocusOnclick'),
      children: [
        { name: 'FocusOnclickExample', label: $r('app.string.FocusOnclickExample') },
      ]
    },
    {
      name: 'PreventBubbling',
      label: $r('app.string.PreventBubbling'),
      children: [
        { name: 'PreventBubbling', label: $r('app.string.PreventBubblingExample') },
      ]
    },
    {
      name: 'sampling',
      label: $r('app.string.sampling'),
      children: [
        { name: 'Sampling', label: $r('app.string.samplingExample') },
      ]
    },
    {
      name: 'MultipleFingerInformation',
      label: $r('app.string.MultipleFingerInformation'),
      children: [
        { name: 'MultipleFingerInformation', label: $r('app.string.MultipleFingerInformationExample') },
      ]
    },
    {
      name: 'mouseMove',
      label: $r('app.string.mouseMove'),
      children: [
        { name: 'MouseMove', label: $r('app.string.mouseMoveExample') },
      ]
    },
    {
      name: 'stopPropagation',
      label: $r('app.string.stopPropagation'),
      children: [
        { name: 'StopPropagation', label: $r('app.string.stopPropagationExample') },
      ]
    },
    {
      name: 'onHover',
      label: $r('app.string.onHover'),
      children: [
        { name: 'OnHover', label: $r('app.string.onHoverExample') },
      ]
    },
    {
      name: 'MouseButton',
      label: $r('app.string.MouseButton'),
      children: [
        { name: 'MouseButton', label: $r('app.string.MouseButtonExample') },
      ]
    },
    {
      name: 'MouseWheel',
      label: $r('app.string.MouseWheel'),
      children: [
        { name: 'MouseWheel', label: $r('app.string.MouseWheelExample') },
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
  }

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  build() {
    Column() {
      Text('ComponentExtension')
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
                    router.pushUrl({ url: name })
                  })
                }
                .width('100%')
              })
            }
          }
          .padding(2)
          .divider({ strokeWidth: 0.5 })
        })
      }.padding({ bottom: 10 })
    }
  }
}