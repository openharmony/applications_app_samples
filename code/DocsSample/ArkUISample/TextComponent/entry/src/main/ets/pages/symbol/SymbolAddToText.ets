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
export struct SymbolGlyphSpanAddToText {
  scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_1') }) {
            // [Start creat_symbol_span]
            Text() {
              SymbolSpan($r('sys.symbol.ohos_trash'))
                .fontWeight(FontWeight.Normal)
                .fontSize(96)
            }.id('1')

            // [End creat_symbol_span]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_2') }) {
            // [Start symbol_span_font_size]
            Row() {
              Column() {
                Text('48')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(48)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }.id('2')
              }

              Column() {
                Text('72')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(72)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }.id('3')
              }

              Column() {
                Text('96')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }.id('4')
              }
            }

            // [End symbol_span_font_size]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_3') }) {
            // [Start symbol_span_font_weight]
            Row() {
              Column() {
                Text('Light')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Lighter)
                    .fontSize(96)
                }.id('5')
              }

              Column() {
                Text('Normal')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(96)
                }.id('6')
              }

              Column() {
                Text('Bold')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Bold)
                    .fontSize(96)
                }.id('7')
              }
            }

            // [End symbol_span_font_weight]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_4') }) {
            // [Start symbol_span_font_color]
            Row() {
              Column() {
                Text('Black')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Black])
                }.id('8')
              }

              Column() {
                Text('Green')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Green])
                }.id('9')
              }

              Column() {
                Text('Pink')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Pink])
                }.id('10')
              }
            }

            // [End symbol_span_font_color]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_5') }) {
            // [Start symbol_span_rendering_strategy]
            Row() {
              Column() {
                Text($r('app.string.SymbolAddToText_Text_1'))
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }.id('11')
              }

              Column() {
                Text($r('app.string.SymbolAddToText_Text_2'))
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }.id('12')
              }

              Column() {
                Text($r('app.string.SymbolAddToText_Text_3'))
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }.id('13')
              }
            }

            // [End symbol_span_rendering_strategy]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_6') }) {
            // [Start symbol_span_effect_strategy]
            Row() {
              Column() {
                Text($r('app.string.SymbolAddToText_Text_4'))
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.NONE)
                }.id('14')
              }

              Column() {
                Text($r('app.string.SymbolAddToText_Text_5'))
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.SCALE)
                }.id('15')
              }

              Column() {
                Text($r('app.string.SymbolAddToText_Text_6'))
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
                }.id('16')
              }
            }

            // [End symbol_span_effect_strategy]
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SymbolGlyphSpanAddToText_title'))
  }
}