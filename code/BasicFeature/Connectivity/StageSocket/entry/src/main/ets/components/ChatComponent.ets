/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import { ChatBox } from '../data/ChatBox';

@Component
export default struct ChatComponent {
  private item?: ChatBox;
  private userId: number = 0;

  build() {
    Row() {
      if (!this.item?.isSend) {
        Text(this.userId === 1 ? $r('app.string.wen') : $r('app.string.feng'))
          .width(32)
          .height(32)
          .fontSize(16)
          .fontColor($r('app.color.COLOR_FFFFFF'))
          .fontFamily($r('app.string.font_family'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.COLOR_33000000'))
          .borderRadius(52)
          .margin({ left: 24, right: 8 })
      }
      Column() {
        Text(this.item?.message)
          .maxLines(5)
          .padding(10)
          .fontSize(20)
          .borderRadius(10)
          .alignSelf(this.item?.isSend ? ItemAlign.End : ItemAlign.Start)
          .backgroundColor(this.item?.isSend ? $r('app.color.COLOR_5BA854') : $r('app.color.COLOR_FFFFFF'))
      }
      .width('70%')
      .margin({ right: 5 })

      if (this.item?.isSend) {
        Text(this.userId === 1 ? $r('app.string.feng') : $r('app.string.wen'))
          .width(32)
          .height(32)
          .fontSize(16)
          .fontColor($r('app.color.COLOR_FFFFFF'))
          .fontFamily($r('app.string.font_family'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.COLOR_33000000'))
          .borderRadius(52)
          .margin({ left: 8, right: 24 })
      }
    }
  }
}
