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
import { MenuKey, KeyState, keySourceListType, } from '../model/keyboardKeyData';
import { KeyStyle } from '../common/StyleConfiguration';
import { KeyItem } from './KeyItem';
import { KeyItemGray } from './KeyItemGray';
import { KeyItemNumber } from './KeyItemNumber';
import { SpaceItem } from './SpaceItem';
import { ReturnItem } from './ReturnItem';

// key键盘
@Component
export struct KeyMenu {
  private keyList: keySourceListType[];
  @Link inputStyle: KeyStyle;
  @State public keyState: number = KeyState.LOWER_CASE;
  @Link menuType: number;

  @Styles pressedStyles() {
    .backgroundColor($r('app.color.key_item_gray_pressed'))
  }

  @Styles normalStyles() {
    .backgroundColor($r('app.color.key_item_gray'))
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.keyList.slice(0, 10), (item: keySourceListType) => {
          KeyItemNumber({ keyValue: item, keyState: $keyState, inputStyle: $inputStyle })
        }, (item: keySourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Stack() {
        }.width('4%').height(0)

        ForEach(this.keyList.slice(10, 19), (item: keySourceListType) => {
          KeyItemNumber({ keyValue: item, keyState: $keyState, inputStyle: $inputStyle })
        }, (item: keySourceListType) => item.content)
        Stack() {
        }.width('4%').height(0)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Stack() {
          Image($rawfile(this.keyState === KeyState.ONCE_UPPER_CASE ? 'shift light.svg' : this.keyState === KeyState.UPPER_CASE ? 'shift light long.svg' : 'shift.svg'))
            .width(this.inputStyle.featurePicSize)
            .height(this.inputStyle.featurePicSize)
        }
        .backgroundColor($r('app.color.key_item_gray'))
        .borderRadius(4)
        .onClick(() => {
          if (this.keyState === KeyState.LOWER_CASE) {
            this.keyState = KeyState.ONCE_UPPER_CASE;
          } else if (this.keyState === KeyState.ONCE_UPPER_CASE) {
            this.keyState = KeyState.UPPER_CASE;
          } else if (this.keyState === KeyState.UPPER_CASE) {
            this.keyState = KeyState.LOWER_CASE;
          }
        })
        .height('100%')
        .width(this.inputStyle.switchButtonWidth)
        .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 })
        .stateStyles({
          normal: this.normalStyles, pressed: this.pressedStyles
        })


        ForEach(this.keyList.slice(19), (item: keySourceListType) => {
          KeyItemNumber({ keyValue: item, keyState: $keyState, inputStyle: $inputStyle })
        }, (item: keySourceListType) => item.content)
        DeleteItem({ inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        KeyItemGray({ keyValue: MenuKey.NUMBER_KEY, menuType: $menuType, inputStyle: $inputStyle })
        KeyItem({
          keyValue: { content: ',', title: ',', upperContent: ',' },
          inputStyle: $inputStyle
        })
        SpaceItem({ spaceWith: this.inputStyle.spaceButtonWidth_1, inputStyle: $inputStyle })

        KeyItem({
          keyValue: { content: '.', title: '.', upperContent: '.' },
          inputStyle: $inputStyle
        })
        ReturnItem({ returnWidth: this.inputStyle.returnButtonWidthType_1, inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

    }
    .width('100%')
    .height('100%')
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    })
  }
}