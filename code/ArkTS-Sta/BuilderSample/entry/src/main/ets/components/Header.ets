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
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  Margin, Padding, HorizontalAlign, Entry, Text, Column, Component, ClickEvent, State
} from '@kit.ArkUI'
import { SIZES, COLORS } from '../common/Contants'

@Component
export struct Header {
  build() {
    Column() {
      Column() {
        Text('🎈 新年愿望填写')
          .fontSize(SIZES.fontSizeTitle)
          .fontWeight(600)
          .fontColor(COLORS.primary)
        Text('把心愿写下来，新的一年都会实现～')
          .fontSize(SIZES.fontSizeSmall)
          .fontColor(COLORS.textSub)
          .margin({ top: 6 } as Margin)
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ top: 40, bottom: SIZES.spacing })
      .width('100%')
    }
  }
}