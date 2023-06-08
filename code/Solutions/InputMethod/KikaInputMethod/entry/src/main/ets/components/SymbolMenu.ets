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

import { DeleteItem } from './DeleteItem';
import { KeyStyle } from '../common/StyleConfiguration';
import { KeyItem } from './KeyItem';
import { KeyItemGray } from './KeyItemGray';
import { ReturnItem } from './ReturnItem';
import { MenuKey, sourceListType } from '../model/keyboardKeyData';
import { SpaceItem } from './SpaceItem';

// 符号键盘
@Component
export struct SymbolMenu {
  private symbolList: sourceListType[];
  @Link inputStyle: KeyStyle;
  @Link menuType: number;

  @Styles pressedStyles() {
    .backgroundColor($r('app.color.key_item_normal_pressed'))
  }

  @Styles normalStyles() {
    .backgroundColor($r('app.color.key_item_normal'))
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(0, 10), (item: sourceListType) => {
          KeyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(10, 20), (item: sourceListType) => {
          KeyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        KeyItemGray({ keyValue: MenuKey.NUMBER_KEY, menuType: $menuType, inputStyle: $inputStyle })
        ForEach(this.symbolList.slice(20), (item: sourceListType) => {
          KeyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
        DeleteItem({ inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })


      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        KeyItemGray({ keyValue: MenuKey.NORMAL_KEY, menuType: $menuType, inputStyle: $inputStyle })
        KeyItem({
          keyValue: { content: '<', title: '<', upperContent: '<' },
          inputStyle: $inputStyle
        })
        KeyItem({
          keyValue: { content: '>', title: '>', upperContent: '>' },
          inputStyle: $inputStyle
        })
        SpaceItem({ spaceWith: this.inputStyle.spaceButtonWidth_2, inputStyle: $inputStyle })
        KeyItem({
          keyValue: { content: '.', title: '.', upperContent: '.' },
          inputStyle: $inputStyle
        })
        ReturnItem({ returnWidth: this.inputStyle.returnButtonWidthType_2, inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })
    }
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    })
  }
}