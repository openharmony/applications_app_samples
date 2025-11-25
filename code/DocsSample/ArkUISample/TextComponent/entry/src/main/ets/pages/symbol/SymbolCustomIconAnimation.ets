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
  replaceFlag: boolean = true;
  // [End symbol_quick_replacement_new]
  @State renderMode: number = 1;
  // [End symbol_disable_effect_new]

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_1') }) {
            // [Start symbol_variable_color]
            Column() {
              // 'app.string.variable_color_animation'资源文件中的value值为"可变颜色动效"
              Text($r('app.string.variable_color_animation'));
              SymbolGlyph($r('sys.symbol.ohos_wifi'))
                .fontSize(96)
                .symbolEffect(new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE), this.isActive)
              // 'app.string.off'资源文件中的value值为"关闭"
              // 'app.string.on'资源文件中的value值为"播放"
              Button(this.isActive ? $r('app.string.off') : $r('app.string.on')).onClick(() => {
                this.isActive = !this.isActive;
              })
            }
            // [End symbol_variable_color]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_2') }) {
            // [Start symbol_bouncing_effect]
            Column() {
              // 'app.string.bounce_animation'资源文件中的value值为"弹跳动效"
              Text($r('app.string.bounce_animation'));
              SymbolGlyph($r('sys.symbol.ellipsis_message_1'))
                .fontSize(96)
                .fontColor([Color.Gray])
                .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP),
                              this.triggerValueReplace)
              Button('trigger').onClick(() => {
                this.triggerValueReplace = this.triggerValueReplace + 1;
              })
            }
            // [End symbol_bouncing_effect]
          }
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanCustomIconAnimation_title_3') }) {
            // [Start symbol_disable_effect]
            Column() {
              // 'app.string.disable_animation'资源文件中的value值为"禁用动效"
              Text($r('app.string.disable_animation'));
              SymbolGlyph(this.replaceFlag ? $r('sys.symbol.eye_slash') : $r('sys.symbol.eye'))
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
              // 'app.string.quick_replacement_animation'资源文件中的value值为"快速替换动效"
              Text($r('app.string.quick_replacement_animation'));
              SymbolGlyph(this.replaceFlag ? $r('sys.symbol.checkmark_circle') : $r('sys.symbol.repeat_1'))
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