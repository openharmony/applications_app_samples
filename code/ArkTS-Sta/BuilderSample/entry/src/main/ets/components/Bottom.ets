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
  Margin, Padding, FlexAlign, Entry, Text, Column, Component, ClickEvent, State, Link
} from '@kit.ArkUI'
import { SIZES, COLORS } from '../common/Contants'

@Component
export struct Bottom {
  @State placeholderVal: string = '请输入你的新年愿望...';
  @Link textVal: string;

  build() {
    Column() {
      Text('📝 你输入的内容:')
        .fontSize(SIZES.fontSizeSmall)
        .fontColor(COLORS.textSub)
        .margin({ top: 20, bottom: 8 } as Margin)
      // 展示父组件的textVal参数
      Text(this.textVal)
        .fontSize(SIZES.fontSizeNormal)
        .fontColor(COLORS.textSub)
        .padding({
          left: 12,
          right: 12,
          top: 10,
          bottom: 10
        } as Padding)
        .backgroundColor(COLORS.bgCard)
        .borderRadius(SIZES.radius)
        .border({ width: 1, color: COLORS.border })
        .width('100%')
    }
    .justifyContent(FlexAlign.Start)
    .width('90%')
  }
}
