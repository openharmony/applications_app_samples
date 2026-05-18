'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import {
  Component,
  StorageLink,
  Stack,
  Resource,
  ForEach,
  Flex,
  Consume,
  State,
  Provide,
  StateStyles,
  FlexDirection,
  ItemAlign,
  FlexAlign,
  ShadowOptions,
  Padding,
  FlexOptions,
  Image,
  $rawfile,
  $r
} from '@kit.ArkUI';
import { DeleteItem } from './DeleteItem';
import {
  MenuKey,
  KeyState,
  keySourceListType,
  keySourceListData
} from '../InputMethodExtensionAbility/pages/KeyboardKeyData';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { KeyItem } from './KeyItem';
import { KeyItemGray } from './KeyItemGray';
import { KeyItemNumber } from './KeyItemNumber';
import { SpaceItem } from './SpaceItem';
import { ReturnItem } from './ReturnItem';
import { inputMethodEngine } from '@kit.IMEKit';

// key键盘
@Component
export struct KeyMenu {
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();
  @Consume menuType: number;
  @Provide keyState: number = KeyState.LOWER_CASE;
  private keyList: Array<keySourceListType> = keySourceListData;
  private spaceWidth: Resource = this.inputStyle.spaceButtonWidth1;
  @State styleMode: number = 1;

  // 如果是沉浸模式，设置新样式
  aboutToAppear(): void {

    inputMethodEngine.getKeyboardDelegate()?.onEditorAttributeChanged((attr: inputMethodEngine.EditorAttribute | undefined): void => {
      if (attr?.immersiveMode == inputMethodEngine.ImmersiveMode.IMMERSIVE) {
        this.styleMode = 0;
      } else {
        this.styleMode = 1;
      }
    })
  }

  build(): void {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center } as FlexOptions) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        ForEach(this.keyList.slice(0, 10), (item: keySourceListType) => {
          KeyItemNumber({ keyValue: item })
        }, (item: keySourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        Stack() {
        }.width('4%').height(0)

        ForEach(this.keyList.slice(10, 19), (item: keySourceListType) => {
          KeyItemNumber({ keyValue: item })
        }, (item: keySourceListType) => item.content)
        Stack() {
        }.width('4%').height(0)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        Stack() {
          Image($rawfile(this.keyState === KeyState.ONCE_UPPER_CASE ? 'shift light.svg' :
            this.keyState === KeyState.UPPER_CASE ? 'shift light long.svg' : 'shift.svg'))
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
        .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 } as ShadowOptions)
        .stateStyles({
          normal: () => {
            this.backgroundColor($r('app.color.key_item_gray'))
          },
          pressed: () => {
            this.backgroundColor($r('app.color.key_item_gray_pressed'))
          }
        } as StateStyles)

        ForEach(this.keyList.slice(19), (item: keySourceListType) => {
          KeyItemNumber({ keyValue: item })
        }, (item: keySourceListType) => item.content)
        DeleteItem()
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop } as Padding)

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        KeyItemGray({ keyValue: MenuKey.NUMBER_KEY })
        KeyItem({ keyValue: { content: ',', title: ',', upperContent: ',' } })
        SpaceItem({ spaceWith: this.spaceWidth })
        KeyItem({ keyValue: { content: '.', title: '.', upperContent: '.' } })
        ReturnItem({ returnWidth: this.inputStyle.returnButtonWidthType1 })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop } as Padding)

    }
    .width('100%')
    .height('100%')
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    } as Padding)
    .backgroundColor(this.styleMode === 1 ? '' : '#ffffff')
  }
}