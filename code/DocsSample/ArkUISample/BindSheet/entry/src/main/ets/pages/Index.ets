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
struct Index {
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: "bindContentCover",
      // 请将$r('app.string.bindContentCover_label')替换为实际资源文件，在本示例中该资源文件的value值为"全模态转场"
      label: $r('app.string.bindContentCover_label'),
      children: [
        // 请将$r('app.string.bindContentCover_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（使用全屏模态转场）"
        { name:"template1/ModalTransitionExample", label: $r('app.string.bindContentCover_label1') },
        // 请将$r('app.string.bindContentCover_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（自定义转场动画）"
        { name:"template2/ModalTransitionExample2", label: $r('app.string.bindContentCover_label2') },
        // 请将$r('app.string.bindContentCover_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（上下切换转场）"
        { name:"template3/ModalTransitionExample3", label: $r('app.string.bindContentCover_label3') },
        // 请将$r('app.string.bindContentCover_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（透明度渐变转场）"
        { name:"template4/ModalTransitionExample4", label: $r('app.string.bindContentCover_label4') },
        // 请将$r('app.string.bindContentCover_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（设置不同效果的自定义转场）"
        { name:"template5/ModalTransitionExample5", label: $r('app.string.bindContentCover_label5') },
        // 请将$r('app.string.bindContentCover_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（使用bindContentCover构建全屏模态内容覆盖半模态）"
        { name:"template6/BindContentCoverDemo", label: $r('app.string.bindContentCover_label6') },
        // 请将$r('app.string.bindContentCover_label7')替换为实际资源文件，在本示例中该资源文件的value值为""示例7（使用bindContentCover构建全屏模态转场效果）"
        { name:"template7/BindContentCoverDemo", label: $r('app.string.bindContentCover_label7') },

      ]
    }, {
      name: "bindSheet",
      // 请将$r('app.string.bindSheet_label')替换为实际资源文件，在本示例中该资源文件的value值为"半模态转场"
      label: $r('app.string.bindSheet_label'),
      children: [
        // 请将$r('app.string.bindSheet_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（不同高度的半模态弹窗）"
        { name:"template1/SheetTransitionExample1", label: $r('app.string.bindSheet_label1') },
        // 请将$r('app.string.bindSheet_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（设置三个不同高度的档位）"
        { name:"template2/SheetTransitionExample2", label: $r('app.string.bindSheet_label2') },
        // 请将$r('app.string.bindSheet_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（使用边框宽度和颜色）"
        { name:"template3/SheetTransitionExample3", label: $r('app.string.bindSheet_label3') },
        // 请将$r('app.string.bindSheet_label4')替换为实际资源文件，在本示例中该资源文件的value值为"示例4（使用关闭回调函数）"
        { name:"template4/bindSheetExample4", label: $r('app.string.bindSheet_label4') },
        // 请将$r('app.string.bindSheet_label5')替换为实际资源文件，在本示例中该资源文件的value值为"示例5（设置内容区刷新时机）"
        { name:"template5/bindSheetExample5", label: $r('app.string.bindSheet_label5') },
        // 请将$r('app.string.bindSheet_label6')替换为实际资源文件，在本示例中该资源文件的value值为"示例6（设置压缩模态内容）"
        { name:"template6/ListenKeyboardHeightChange", label: $r('app.string.bindSheet_label6') },
        // 请将$r('app.string.bindSheet_label7')替换为实际资源文件，在本示例中该资源文件的value值为"示例7（镜像场景下如何设置圆角属性）"
        { name:"template7/SheetTransitionExample7", label: $r('app.string.bindSheet_label7') },
        // 请将$r('app.string.bindSheet_label8')替换为实际资源文件，在本示例中该资源文件的value值为"示例8（半模态Side侧边样式）"
        { name:"template8/SheetSideExample8", label: $r('app.string.bindSheet_label8') },
        // 请将$r('app.string.bindSheet_label9')替换为实际资源文件，在本示例中该资源文件的value值为"示例9（使用bindSheet构建半模态转场效果）"
        { name:"template9/BindSheetDemo9", label: $r('app.string.bindSheet_label9') },
        // 请将$r('app.string.bindSheet_label10')替换为实际资源文件，在本示例中该资源文件的value值为"示例10（使用嵌套滚动交互）"
        { name:"template10/SheetDemo", label: $r('app.string.bindSheet_label10') },
        // 请将$r('app.string.bindSheet_label11')替换为实际资源文件，在本示例中该资源文件的value值为"示例11（二次确认）"
        { name:"template11/OnWillDismiss_Dismiss", label: $r('app.string.bindSheet_label11') },
        // 请将$r('app.string.bindSheet_label12')替换为实际资源文件，在本示例中该资源文件的value值为"示例12（半模态支持避让中轴）"
        { name:"template12/SheetTransitionExample", label: $r('app.string.bindSheet_label12') },
      ]
    }, {
      name: "bindSheetCmd",
      // 请将$r('app.string.bindSheetCmd_label')替换为实际资源文件，在本示例中该资源文件的value值为"命令式打开半模态"
      label: $r('app.string.bindSheetCmd_label'),
      children: [
        // 请将$r('app.string.bindSheetCmd_label1')替换为实际资源文件，在本示例中该资源文件的value值为"示例1（openBindSheet）"
        { name:"template1/UIContextBindSheet", label: $r('app.string.bindSheetCmd_label1') },
        // 请将$r('app.string.bindSheetCmd_label2')替换为实际资源文件，在本示例中该资源文件的value值为"示例2（updateBindSheet）"
        { name:"template2/UIContextBindSheet", label: $r('app.string.bindSheetCmd_label2') },
        // 请将$r('app.string.bindSheetCmd_label3')替换为实际资源文件，在本示例中该资源文件的value值为"示例3（closeBindSheet）"
        { name:"template3/UIContextBindSheet", label: $r('app.string.bindSheetCmd_label3') },
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
    }
  }
}