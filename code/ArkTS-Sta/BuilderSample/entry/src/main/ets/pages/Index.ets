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

import { HorizontalAlign, Margin, HorizontalAlign, $r, Entry, Text, Column, Component, Divider, Image, State } from '@kit.ArkUI'
import { Header } from '../components/Header'
import { MainPage } from '../components/MainPage'
import { Bottom } from '../components/Bottom'
import { SIZES, COLORS } from '../common/Contants'

@Entry
@Component
struct Index {
  @State placeholderVal: string = '请输入你的新年愿望...'
  @State textVal: string = '"✍️ 写下你的愿望:"'

  build() {
    Column() {
      Header()

      Divider()
        .color(COLORS.border)
        .height(1)
        .width('90%')
        .margin({ bottom: SIZES.spacing * 1.5 })

      MainPage({ textVal: this.textVal })

      Bottom({ textVal: this.textVal })

      Text('💫 愿新年，胜旧年 💫')
        .fontSize(SIZES.fontSizeSmall)
        .fontColor(COLORS.textSub)
        .margin({ top: 40, bottom: 30 } as Margin)

      Image($r('app.media.happyNewYear'))
        .width('100%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.bgPage)
    .padding({ left: SIZES.padding, right: SIZES.padding } as Margin)
    .alignItems(HorizontalAlign.Center)
  }
}