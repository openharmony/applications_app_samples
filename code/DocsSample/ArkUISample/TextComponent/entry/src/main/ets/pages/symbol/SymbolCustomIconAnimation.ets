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
  scroller: Scroller = new Scroller();
  // [Start symbol_effect_1]
  @State isActive: boolean = true;
  // [End symbol_effect_1]
  // [Start symbol_effect_2]
  // [Start symbol_effect_3]
  // [Start symbol_effect_4]
  @State triggerValueReplace: number = 0;
  // [End symbol_effect_2]
  @State renderMode: number = 1;
  // [End symbol_effect_3]
  replaceFlag: boolean = true;
  // [End symbol_effect_4]

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_1') }) {
            // [Start symbol_effect_1]
            Column() {
              Text('可变颜色动效')
              SymbolGlyph($r('sys.symbol.ohos_wifi'))
                // [StartExclude symbol_effect_1]
                .id('1')
                // [EndExclude symbol_effect_1]
                .fontSize(96)
                .symbolEffect(new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE), this.isActive)
              Button(this.isActive ? '关闭' : '播放').onClick(() => {
                this.isActive = !this.isActive;
              })
            }
            // [End symbol_effect_1]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_2') }) {
            // [Start symbol_effect_2]
            Column() {
              Text('弹跳动效')
              SymbolGlyph($r('sys.symbol.ellipsis_message_1'))
                // [StartExclude symbol_effect_2]
                .id('2')
                // [EndExclude symbol_effect_2]
                .fontSize(96)
                .fontColor([Color.Gray])
                .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP), this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_effect_2]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_3') }) {
            // [Start symbol_effect_3]
            Column() {
              Text('禁用动效')
              SymbolGlyph(this.replaceFlag ? $r('sys.symbol.eye_slash') : $r('sys.symbol.eye'))
                // [StartExclude symbol_effect_3]
                .id('3')
                // [EndExclude symbol_effect_3]
                .fontSize(96)
                .renderingStrategy(this.renderMode)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.LAYER, ReplaceEffectType.SLASH_OVERLAY),
                  this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.replaceFlag = !this.replaceFlag;
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_effect_3]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_4') }) {
            // [Start symbol_effect_4]
            Column() {
              Text('快速替换动效')
              SymbolGlyph(this.replaceFlag ? $r('sys.symbol.checkmark_circle') : $r('sys.symbol.repeat_1'))
                // [StartExclude symbol_effect_4]
                .id('4')
                // [EndExclude symbol_effect_4]
                .fontSize(96)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE, ReplaceEffectType.CROSS_FADE),
                  this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.replaceFlag = !this.replaceFlag;
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_effect_4]
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SymbolGlyphSpanCustomIconAnimation_title'))
  }
}