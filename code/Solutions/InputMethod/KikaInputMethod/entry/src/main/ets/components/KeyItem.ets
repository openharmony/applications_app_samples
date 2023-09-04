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

import { keySourceListType, } from '../model/KeyboardKeyData';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { InputHandler } from '../model/KeyboardController';


@Styles function pressedStyles() {
  .backgroundColor($r('app.color.key_item_normal_pressed'))
}

@Styles function normalStyles() {
  .backgroundColor($r('app.color.key_item_normal'))
}

// 无大小写的按键组件
@Component
export struct KeyItem {
  private keyValue: keySourceListType | undefined = undefined;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.keyValue) {
        Text(this.keyValue.content)
          .fontSize(this.inputStyle.symbol_fontSize)
          .fontColor(Color.Black)
      }
    }
    .backgroundColor($r('app.color.key_item_normal'))
    .borderRadius(4)
    .width(this.inputStyle.basicButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 })
    .onClick(() => {
      if (this.keyValue) {
        InputHandler.getInstance().insertText(this.keyValue.content);
      }
    })
    .stateStyles({
      normal: normalStyles, pressed: pressedStyles
    })
  }
}