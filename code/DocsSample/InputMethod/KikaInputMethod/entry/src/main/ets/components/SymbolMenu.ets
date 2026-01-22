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
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { KeyItem } from './KeyItem';
import { KeyItemGray } from './KeyItemGray';
import { ReturnItem } from './ReturnItem';
import { MenuKey, symbolSourceListData, sourceListType } from '../model/KeyboardKeyData';
import { SpaceItem } from './SpaceItem';

// 符号键盘
@Component
export struct SymbolMenu {
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();
  @Consume menuType: number;
  private symbolList: sourceListType[] = symbolSourceListData;
  private spaceWidth: Resource = this.inputStyle.spaceButtonWidth_2;
  private returnWidth: Resource = this.inputStyle.returnButtonWidthType_2;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(0, 10), (item: sourceListType) => {
          KeyItem({ keyValue: { content: item.content, title: item.content, upperContent: item.content } })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(10, 20), (item: sourceListType) => {
          KeyItem({ keyValue: { content: item.content, title: item.content, upperContent: item.content } })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        KeyItemGray({ keyValue: MenuKey.NUMBER_KEY })
        ForEach(this.symbolList.slice(20), (item: sourceListType) => {
          KeyItem({ keyValue: { content: item.content, title: item.content, upperContent: item.content } })
        }, (item: sourceListType) => item.content)
        DeleteItem()
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        KeyItemGray({ keyValue: MenuKey.NORMAL_KEY })
        KeyItem({ keyValue: { content: '<', title: '<', upperContent: '<' } })
        KeyItem({ keyValue: { content: '>', title: '>', upperContent: '>' } })
        SpaceItem({ spaceWith: this.spaceWidth })
        KeyItem({ keyValue: { content: '.', title: '.', upperContent: '.' } })
        ReturnItem({ returnWidth: this.returnWidth })
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