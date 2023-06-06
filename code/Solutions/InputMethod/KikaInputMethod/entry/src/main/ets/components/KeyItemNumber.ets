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
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { InputHandler } from '../model/KeyboardController';
import { KeyState, keySourceListType, } from '../model/keyboardKeyData';
import { KeyStyle } from '../common/StyleConfiguration';
import deviceInfo from '@ohos.deviceInfo';

// 有大小写的按键组件
@Component
export struct KeyItemNumber {
  private keyValue: keySourceListType;
  @Link inputStyle: KeyStyle;
  @Link keyState: number;

  @Styles pressedStyles() {
    .backgroundColor($r('app.color.key_item_normal_pressed'))
  }

  @Styles normalStyles() {
    .backgroundColor($r('app.color.key_item_normal'))
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (AppStorage.Get('isLandscape') && deviceInfo.deviceType === 'phone') {
        Stack({ alignContent: Alignment.TopEnd }) {
          Text(this.keyState === KeyState.LOWER_CASE ? this.keyValue.content : this.keyValue.upperContent)
            .fontSize(this.inputStyle.en_fontSize)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
          Text(this.keyValue.title)
            .fontSize(this.inputStyle.litterNumberFontSize)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .width('12vp')
            .height('12vp')
            .textAlign(TextAlign.Center)
            .margin({ top: 1, right: 1 })
        }
        .width('100%')
        .height('100%')
      } else {
        Text(this.keyValue.title)
          .fontSize(this.inputStyle.litterNumberFontSize)
          .fontColor($r('app.color.key_item_normal_text'))
          .fontWeight(FontWeight.Regular)
          .margin({ top: 4 })
        Text(this.keyState === KeyState.LOWER_CASE ? this.keyValue.content : this.keyValue.upperContent)
          .fontSize(this.inputStyle.en_fontSize)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Regular)
      }
    }
    .backgroundColor($r('app.color.key_item_normal'))
    .borderRadius(4)
    .onClick(() => {
      if (this.keyState === KeyState.LOWER_CASE) {
        InputHandler.getInstance().insertText(this.keyValue.content);
      } else {
        if (this.keyState === KeyState.ONCE_UPPER_CASE) {
          this.keyState = KeyState.LOWER_CASE;
        }
        InputHandler.getInstance().insertText(this.keyValue.upperContent);
      }
    })
    .width(this.inputStyle.basicButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}
