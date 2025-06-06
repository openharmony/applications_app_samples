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

import { TitleBar } from '../../../../common/TitleBar'
import Logger from '../../../../util/Logger'
import { fruitArray } from '../../ComponentData'
import { getStringArrayData } from '../../../../data//ResourceDataHandle'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle) function colorPicker(color: Color | string, callback: () => void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct TextPickerSample {
  private select: number = 1
  private fruits: string[] = getStringArrayData(fruitArray)

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_picker') })
      Text($r('app.string.normal_display'))
        .leftTitleStyle()
      Column() {
        TextPicker({ range: this.fruits, selected: this.select })
          .onChange((value: string | string[], index: number | number[]) => {
            Logger.info(`Picker item changed, value: ${value}, index: ${index}`);
          })
      }.height('40%')
      .cardStyle()
      .width('100%')
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 })
  }
}
