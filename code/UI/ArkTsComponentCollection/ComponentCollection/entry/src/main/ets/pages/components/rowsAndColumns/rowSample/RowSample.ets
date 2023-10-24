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
import { ArgumentsControlPanel, PropertyControlPanel } from './RowControlPanel';

@Extend(Row) function backgroundStyle() {
  .width('100%')
  .height(400)
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
}

@Extend(Column) function columnStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Entry
@Component
struct RowSample {
  @State elementSpacing: number = 5;
  @State alignItems: VerticalAlign = VerticalAlign.Center;
  @State justifyContent: FlexAlign = FlexAlign.Center;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.row_title') })
      Scroll() {
        Column() {
          Row({ space: this.elementSpacing }) {
            Text()
              .height(50)
              .width(50)
              .backgroundColor($r('app.color.background_green'))
            Text()
              .height(50)
              .width(50)
              .backgroundColor($r('app.color.background_orange'))
            Text()
              .height(50)
              .width(50)
              .backgroundColor($r('app.color.background_dark'))
          }
          .backgroundStyle()
          .justifyContent(this.justifyContent)
          .alignItems(this.alignItems)

          IntroductionTitle({ introduction: $r('app.string.row_introduction_arguments') })
          Column() {
            ArgumentsControlPanel({ elementSpacing: $elementSpacing })
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.row_introduction_properties') })
          Column() {
            PropertyControlPanel({ alignItems: $alignItems, justifyContent: $justifyContent })
          }.columnStyle()

          IntroductionTitle({ introduction: $r('app.string.row_introduction_tips') })
          Column() {
            Text($r('app.string.row_tips'))
              .fontSize(20)
          }
          .columnStyle()
        }
        .width('100%')
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 80 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}