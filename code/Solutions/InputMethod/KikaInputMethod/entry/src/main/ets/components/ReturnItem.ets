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
import { KeyStyle } from '../common/StyleConfiguration';

enum EntryKey {
  Send = 'Send',
  Search = 'Search',
  Go = 'Go'
}
// 返回组件
@Component
export struct ReturnItem {
  private returnWidth: Resource;
  @StorageLink('enterKeyType') enterKeyType:EnterKeyType = EnterKeyType.Done
  @Link inputStyle: KeyStyle;

  @Styles pressedStyles() {
    .backgroundColor($r('app.color.key_item_gray_pressed'))
  }

  @Styles normalStyles() {
    .backgroundColor($r('app.color.key_item_gray'))
  }

  build() {
    Stack() {
      if(this.enterKeyType === EnterKeyType.Send){
        Text(EntryKey.Send)
          .fontSize(this.inputStyle.symbol_fontSize)
          .fontColor(Color.Black)
      }else if(this.enterKeyType === EnterKeyType.Search){
        Text(EntryKey.Search)
          .fontSize(this.inputStyle.symbol_fontSize)
          .fontColor(Color.Black)
      }else if(this.enterKeyType === EnterKeyType.Go){
        Text(EntryKey.Go)
          .fontSize(this.inputStyle.symbol_fontSize)
          .fontColor(Color.Black)
      }else{
        Image($rawfile('return.svg'))
          .width(this.inputStyle.returnPicSize)
          .height(this.inputStyle.returnPicSize)
      }
    }
    .backgroundColor($r('app.color.key_item_gray'))
    .width(this.returnWidth)
    .borderRadius(4)
    .height('100%')
    .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 })
    .onClick(() => {
      InputHandler.getInstance().sendKeyFunction();
    })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}