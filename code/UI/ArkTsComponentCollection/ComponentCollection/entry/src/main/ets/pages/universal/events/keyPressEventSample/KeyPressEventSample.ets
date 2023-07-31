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
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Entry
@Component
struct KeyPressEventSample {
  @State text: string = '';
  @State eventType: string = '';

  build() {
    Column() {
      TitleBar({ title: $r('app.string.keyPress_event') })
      Scroll() {
        Column({ space: 16 }) {
          IntroductionTitle({ introduction: $r('app.string.key_press_description') })
          Row() {
            Text(this.text)
              .margin(15)
          }
          .borderRadius(24)
          .backgroundColor(Color.White)
          .height(150)
          .width('100%')
          .margin({ left: 12, right: 12 })

          Button($r('app.string.key_event'))
            .onKeyEvent((event: KeyEvent) => {
              if (event.type === KeyType.Down) {
                this.eventType = getStringData($r('app.string.key_press_down'));
              }
              if (event.type === KeyType.Up) {
                this.eventType = getStringData($r('app.string.key_press_up'));
              }
              this.text = getStringData($r('app.string.key_press_keyType'))
              + this.eventType + getStringData($r('app.string.key_press_keyCode'))
              + event.keyCode + getStringData($r('app.string.key_press_keyText')) + event.keyText;
            })
            .margin({ bottom: 4 })
            .width('90%')
            .height(40)
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}