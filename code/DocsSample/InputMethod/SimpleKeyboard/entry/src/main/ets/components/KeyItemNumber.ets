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
  Text,
  Consume,
  StateStyles,
  $r,
  ClickEvent,
  FlexOptions,
  ShadowOptions,
  StackOptions,
  ItemAlign,
  FlexAlign,
  FlexDirection,
  Color,
  AppStorage,
  FontWeight,
  Alignment,
  TextAlign
} from '@kit.ArkUI';
import deviceInfo from '@ohos.deviceInfo';
import { InputHandler } from '../InputMethodExtensionAbility/model/KeyboardController';
import { KeyState, keySourceListType } from '../InputMethodExtensionAbility/pages/KeyboardKeyData';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';

// 有大小写的按键组件
@Component
export struct KeyItemNumber {
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();
  @Consume keyState: number;
  keyValue: keySourceListType | undefined = undefined;

  build(): void {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    } as FlexOptions) {
      if (AppStorage.get<boolean>('isLandscape') && deviceInfo.deviceType === 'phone' && this.keyValue) {
        Stack({ alignContent: Alignment.TopEnd } as StackOptions) {
          Text(this.keyState === KeyState.LOWER_CASE ? this.keyValue?.content : this.keyValue?.upperContent)
            .fontSize(this.inputStyle.en_fontSize)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
          Text(this.keyValue?.title)
            .fontSize(this.inputStyle?.litterNumberFontSize)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .width('12vp')
            .height('12vp')
            .textAlign(TextAlign.Center)
            .margin({ top: 1, right: 1 })
        }
        .width('100%')
        .height('100%')
      } else if (this.keyValue) {
        Text(this.keyValue?.title)
          .fontSize(this.inputStyle.litterNumberFontSize)
          .fontColor($r('app.color.key_item_normal_text'))
          .fontWeight(FontWeight.Regular)
          .margin({ top: 4 })
        Text(this.keyState === KeyState.LOWER_CASE ? this.keyValue?.content : this.keyValue?.upperContent)
          .fontSize(this.inputStyle?.en_fontSize)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Regular)
      }
    }
    .backgroundColor($r('app.color.key_item_normal'))
    .borderRadius(4)
    .onClick((e: ClickEvent) => {
      if (this.keyState === KeyState.LOWER_CASE && this.keyValue) {
        InputHandler.getInstance().insertText(this.keyValue?.content as string);
      } else if (this.keyValue) {
        if (this.keyState === KeyState.ONCE_UPPER_CASE) {
          this.keyState = KeyState.LOWER_CASE;
        }
        InputHandler.getInstance().insertText(this.keyValue?.upperContent as string);
      }
    })
    .width(this.inputStyle.basicButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 } as ShadowOptions)
    .stateStyles({
      normal: () => {
        this.backgroundColor($r('app.color.key_item_normal'))
      },
      pressed: () => {
        this.backgroundColor($r('app.color.key_item_normal_pressed'))
      }
    } as StateStyles)
  }
}
