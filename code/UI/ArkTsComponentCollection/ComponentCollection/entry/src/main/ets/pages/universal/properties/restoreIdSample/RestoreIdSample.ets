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

import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Extend(Button) function buttonStyle() {
  .margin(8)
  .fontSize(16)
  .width('100%')
  .margin({ left: 24, right: 24, top: 12 })
}

@Entry
@Component
struct RestoreIdExample {
  private apple: string = getStringData($r('app.string.text_picker_text_apple'));
  private orange: string = getStringData($r('app.string.text_picker_text_orange'));
  private peach: string = getStringData($r('app.string.text_picker_text_peach'));
  private grape: string = getStringData($r('app.string.text_picker_text_grape'));
  private banana: string = getStringData($r('app.string.text_picker_text_banana'));
  private fruits: string[] = [this.apple, this.orange, this.peach, this.grape, this.banana];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.restore_id') })
      List({ space: 8 }) {
        ForEach(this.fruits, (item) => {
          ListItem() {
            Button(item)
              .buttonStyle()
          }
        }, item => item)
      }
      .alignListItem(ListItemAlign.Center)
      .width('100%')
      .restoreId(1)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}