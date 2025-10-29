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
  // [Start symbol_variable_color_new]
  @State isActive: boolean = true;
  // [End symbol_variable_color_new]
  // [Start symbol_bouncing_effect_new]
  // [Start symbol_disable_effect_new]
  // [Start symbol_quick_replacement_new]
  @State triggerValueReplace: number = 0;
  // [End symbol_bouncing_effect_new]
  @State renderMode: number = 1;
  // [End symbol_disable_effect_new]
  replaceFlag: boolean = true;
  // [End symbol_quick_replacement_new]

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_1') }) {
            // [Start symbol_variable_color]
            Column() {
              Text($r('app.string.SymbolCustomIconAnimation_Text_1'));
              SymbolGlyph($r('sys.symbol.ohos_wifi'))
                // [StartExclude symbol_variable_color]
                .id('1')
                // [EndExclude symbol_variable_color]
                .fontSize(96)
                .symbolEffect(new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE), this.isActive)
              Button(this.isActive ? $r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_1') : $r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_2')).onClick(() => {
                this.isActive = !this.isActive;
              })
            }
            // [End symbol_variable_color]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_2') }) {
            // [Start symbol_bouncing_effect]
            Column() {
              Text($r('app.string.SymbolCustomIconAnimation_Text_2'));
              SymbolGlyph($r('sys.symbol.ellipsis_message_1'))
                // [StartExclude symbol_bouncing_effect]
                .id('2')
                // [EndExclude symbol_bouncing_effect]
                .fontSize(96)
                .fontColor([Color.Gray])
                .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP), this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_bouncing_effect]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_3') }) {
            // [Start symbol_disable_effect]
            Column() {
              Text($r('app.string.SymbolCustomIconAnimation_Text_3'));
              SymbolGlyph(this.replaceFlag ? $r('sys.symbol.eye_slash') : $r('sys.symbol.eye'))
                // [StartExclude symbol_disable_effect]
                .id('3')
                // [EndExclude symbol_disable_effect]
                .fontSize(96)
                .renderingStrategy(this.renderMode)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.LAYER, ReplaceEffectType.SLASH_OVERLAY),
                  this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.replaceFlag = !this.replaceFlag;
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_disable_effect]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_4') }) {
            // [Start symbol_quick_replacement]
            Column() {
              Text($r('app.string.SymbolCustomIconAnimation_Text_4'));
              SymbolGlyph(this.replaceFlag ? $r('sys.symbol.checkmark_circle') : $r('sys.symbol.repeat_1'))
                // [StartExclude symbol_quick_replacement]
                .id('4')
                // [EndExclude symbol_quick_replacement]
                .fontSize(96)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE, ReplaceEffectType.CROSS_FADE),
                  this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.replaceFlag = !this.replaceFlag;
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_quick_replacement]
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