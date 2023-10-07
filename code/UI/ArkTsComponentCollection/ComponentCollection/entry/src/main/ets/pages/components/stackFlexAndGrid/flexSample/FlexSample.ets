/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { DirectionControlPanel, WrapControlPanel, JustifyContentControlPanel, AlignItemsControlPanel, AlignContentControlPanel } from './FlexControlPanel'

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Extend(Text) function elementStyle(color: Resource) {
  .backgroundColor(color)
  .textAlign(TextAlign.Center)
}

@Entry
@Component
struct FlexSample {
  @State flexDirection : FlexDirection = FlexDirection.Column;
  @State wrap : FlexWrap = FlexWrap.NoWrap;
  @State justifyContent : FlexAlign = FlexAlign.Start;
  @State alignItems : ItemAlign = ItemAlign.Start;
  @State alignContent : FlexAlign = FlexAlign.Start;

  @Styles fixedSize(){
    .width('20%')
    .height('20%')
  }
  @Styles dynamicSize(){
    .width(this.flexDirection === FlexDirection.Row || this.flexDirection === FlexDirection.RowReverse ? '50%': 100)
    .height(this.flexDirection === FlexDirection.Column || this.flexDirection === FlexDirection.ColumnReverse ? '50%' : 50  )
  }

  @Styles alignContentDynamicSize(){
    .width(this.flexDirection === FlexDirection.Column || this.flexDirection === FlexDirection.ColumnReverse ? 20:'50%')
    .height(this.flexDirection === FlexDirection.Row || this.flexDirection === FlexDirection.RowReverse ? 20 : '50%')
  }
  build() {
    Column() {
      TitleBar({ title: $r('app.string.flex_title') })
      Scroll() {
        Column({space : 10}) {
          // direction
          Column(){
            DirectionControlPanel({
              flexDirection : $flexDirection
            })
          }
          .backgroundStyle()
          // wrap
          Column() {
            Column(){
              Flex({direction:this.flexDirection,wrap: this.wrap}) {
                Text('1')
                  .elementStyle($r('app.color.background_orange'))
                  .dynamicSize()
                Text('2')
                  .elementStyle($r('app.color.background_pink'))
                  .dynamicSize()
                Text('3')
                  .elementStyle($r('app.color.background_orange'))
                  .dynamicSize()
                Text('4')
                  .elementStyle($r('app.color.background_pink'))
                  .dynamicSize()
              }
            }
            .justifyContent(FlexAlign.Center)
            .height(200)
            WrapControlPanel({
              wrap: $wrap
            })
          }
          .backgroundStyle()

          // justifyContent
          Column(){
            Column(){
              Flex({direction:this.flexDirection,justifyContent:this.justifyContent, alignItems : ItemAlign.Center}) {
                Text('1')
                  .elementStyle($r('app.color.background_orange'))
                  .fixedSize()
                Text('2')
                  .elementStyle($r('app.color.background_pink'))
                  .fixedSize()
                Text('3')
                  .elementStyle($r('app.color.background_orange'))
                  .fixedSize()
              }
            }
            .justifyContent(FlexAlign.Center)
            .height(200)
            JustifyContentControlPanel({JustifyContent: $justifyContent})
          }
          .backgroundStyle()

          // alignItems
          Column(){
            Column(){
              Flex({direction:this.flexDirection,alignItems:this.alignItems,justifyContent : FlexAlign.Center}) {
                Text('1')
                  .width(this.flexDirection != FlexDirection.Row || this.flexDirection!= FlexDirection.RowReverse ? 30:'33%')
                  .height(30)
                  .elementStyle($r('app.color.background_orange'))
                Text('2')
                  .elementStyle($r('app.color.background_pink'))
                  .width(this.flexDirection != FlexDirection.Row || this.flexDirection!= FlexDirection.RowReverse ? 40:'33%')
                  .height(this.flexDirection != FlexDirection.Row || this.flexDirection!= FlexDirection.RowReverse? 30: 40)
                Text('3')
                  .elementStyle($r('app.color.background_orange'))
                  .width(this.flexDirection != FlexDirection.Row || this.flexDirection!= FlexDirection.RowReverse ? 50:'33%')
                  .height(this.flexDirection != FlexDirection.Row || this.flexDirection!= FlexDirection.RowReverse? 30: 50)
              }
              .height('100%')
              .width('100%')
            }
            .justifyContent(FlexAlign.Center)
            .height(200)
            AlignItemsControlPanel({alignItems: $alignItems})
          }
          .backgroundStyle()


          Column(){
            Column(){
              Flex({direction:this.flexDirection,justifyContent:FlexAlign.Start, alignItems : ItemAlign.Center,alignContent: this.alignContent,wrap:FlexWrap.Wrap}) {
                Text('1')
                  .elementStyle($r('app.color.background_orange'))
                  .alignContentDynamicSize()
                Text('2')
                  .elementStyle($r('app.color.background_pink'))
                  .alignContentDynamicSize()
                Text('3')
                  .elementStyle($r('app.color.background_orange'))
                  .alignContentDynamicSize()
              }
              .height('100%')
              .width('100%')
            }
            .justifyContent(FlexAlign.Center)
            .height(200)
            AlignContentControlPanel(
              {alignContent:$alignContent}
            )
          }
          .backgroundStyle()
        }
        .width('100%')
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 80 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}