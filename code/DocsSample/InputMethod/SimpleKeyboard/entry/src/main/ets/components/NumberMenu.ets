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
  FlexDirection,
  ItemAlign,
  FlexOptions,
  FlexAlign,
  Padding
} from '@kit.ArkUI';
import { DeleteItem } from './DeleteItem';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { KeyItem } from './KeyItem';
import { KeyItemGray } from './KeyItemGray';
import { MenuKey, numberSourceListData, sourceListType } from '../InputMethodExtensionAbility/pages/KeyboardKeyData';
import { SpaceItem } from './SpaceItem';
import { ReturnItem } from './ReturnItem';

// 数字键盘
@Component
export struct NumberMenu {
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();
  @Consume menuType: number;
  private numberList: sourceListType[] = numberSourceListData;
  private spaceWidth: Resource = this.inputStyle.spaceButtonWidth2;

  build(): void {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center } as FlexOptions) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        ForEach(this.numberList.slice(0, 10), (item: sourceListType) => {
          KeyItem({ keyValue: { content: item.content, title: item.content, upperContent: item.content } })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        ForEach(this.numberList.slice(10, 20), (item: sourceListType) => {
          KeyItem({ keyValue: { content: item.content, title: item.content, upperContent: item.content } })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        KeyItemGray({ keyValue: MenuKey.SPECIAL_KEY })
        ForEach(this.numberList.slice(20), (item: sourceListType) => {
          KeyItem({ keyValue: { content: item.content, title: item.content, upperContent: item.content } })
        }, (item: sourceListType) => item.content)
        DeleteItem()
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center } as FlexOptions) {
        KeyItemGray({ keyValue: MenuKey.NORMAL_KEY })
        KeyItem({ keyValue: { content: '_', title: '_', upperContent: '_' } })
        KeyItem({ keyValue: { content: ',', title: ',', upperContent: ',' } })

        SpaceItem({ spaceWith: this.spaceWidth })
        KeyItem({ keyValue: { content: '.', title: '.', upperContent: '.' } })
        ReturnItem({ returnWidth: this.inputStyle.returnButtonWidthType2 })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop } as Padding)
    }
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    } as Padding)
  }
}