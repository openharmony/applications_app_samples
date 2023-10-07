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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct RowSplitSample {
  @State isDrag: boolean = true;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.rowsplit_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.rowsplit_drag_divider') })
          Column() {
            RowSplit() {
              Text()
                .width('10%')
                .height(200)
                .backgroundColor($r('app.color.background_orange'))
              Text()
                .width('10%')
                .height(200)
                .backgroundColor($r('app.color.background_orange'))
              Text()
                .width('10%')
                .height(200)
                .backgroundColor($r('app.color.background_orange'))
              Text()
                .width('10%')
                .height(200)
                .backgroundColor($r('app.color.background_orange'))
            }
            .resizeable(this.isDrag)
            .width('100%')
            .height(200)
          }.backgroundStyle()
          .height(400)

          IntroductionTitle({ introduction: $r('app.string.rowsplit_introduction_properties') })
          Column() {
            Row() {
              Text($r('app.string.rowsplit_drag'))
                .leftTitleStyle()
                .width('50%')
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.isDrag })
                .onChange((isOn) => {
                  this.isDrag = isOn;
                })
                .id(`rowsplit_001`)
            }.width('100%')
          }
          .backgroundStyle()
        }
        .height('100%')
        .width('100%')
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 80 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
