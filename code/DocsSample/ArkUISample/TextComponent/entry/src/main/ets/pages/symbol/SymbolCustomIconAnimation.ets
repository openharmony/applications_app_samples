/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct SymbolGlyphSpanCustomIconAnimation {
  @State isActive: boolean = true;
  @State triggerValueReplace: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_1') }) {
          // [Start symbol_effect_1]
          Column() {
            Text($r('app.string.SymbolCustomIconAnimation_Text_1'))
            SymbolGlyph($r('sys.symbol.ohos_wifi'))
              .id('1')
              .fontSize(96)
              .symbolEffect(new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE), this.isActive)
            Button(this.isActive ? $r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_1') : $r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_2')).onClick(() => {
              this.isActive = !this.isActive;
            })
          }
          // [End symbol_effect_1]
        }
        ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_2') }) {
          // [Start symbol_effect_2]
          Column() {
            Text($r('app.string.SymbolCustomIconAnimation_Text_2'))
            SymbolGlyph($r('sys.symbol.ellipsis_message_1'))
              .id('2')
              .fontSize(96)
              .fontColor([Color.Gray])
              .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP), this.triggerValueReplace)
            Button($r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_3')).onClick(() => {
              this.triggerValueReplace = this.triggerValueReplace + 1;
            })
          }
          // [End symbol_effect_2]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SymbolGlyphSpanCustomIconAnimation_title'))
  }
}