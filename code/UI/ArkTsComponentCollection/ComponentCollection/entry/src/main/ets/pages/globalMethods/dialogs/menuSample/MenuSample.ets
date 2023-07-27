/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Row) function rowStyle() {
  .height(50)
  .padding(12)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12, bottom: 12 })
}

@Extend(Button) function buttonStyle() {
  .margin(8)
  .fontSize(16)
  .layoutWeight(1)
  .height(40)
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Entry
@Component
struct MenuSample {
  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.text_picker_text_banana'))
        .fontSize(16)
        .width('90%')
      Divider().strokeWidth(1).margin(8).color(Color.Brown)
      Text($r('app.string.text_picker_text_orange'))
        .fontSize(16)
        .width('90%')
      Divider().strokeWidth(1).margin(8).color(Color.Brown)
      Text($r('app.string.text_picker_text_grape'))
        .fontSize(16)
        .width('90%')
        .margin({ bottom: 10 })
    }
    .width(200)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.global_menu') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.global_menu_create_way') })
          Row({ space: 16 }) {
            Button($r('app.string.global_menu_click_right'))
              .buttonStyle()
              .bindContextMenu(this.MenuBuilder(), ResponseType.RightClick)
              .id('right_clickButton')

            Button($r('app.string.global_menu_long_press'))
              .buttonStyle()
              .bindContextMenu(this.MenuBuilder(), ResponseType.LongPress)
              .id('long_pressButton')
          }
          .justifyContent(FlexAlign.Center)
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
      .id('menu_scroll')
      .onClick(() => {
        // 点击时关闭菜单
        ShowToast.shortToast($r('app.string.global_menu_close'));
        ContextMenu.close();
      })
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}