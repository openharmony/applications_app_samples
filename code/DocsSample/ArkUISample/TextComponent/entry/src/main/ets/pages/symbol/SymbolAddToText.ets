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
            }
            // [StartExclude creat_symbol_span]
            .id('1')
            // [EndExclude creat_symbol_span]
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
                }
                // [StartExclude symbol_span_font_size]
                .id('2')
                // [EndExclude symbol_span_font_size]
              }

              Column() {
                Text('72')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(72)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
                // [StartExclude symbol_span_font_size]
                .id('3')
                // [EndExclude symbol_span_font_size]
              }

              Column() {
                Text('96')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
                // [StartExclude symbol_span_font_size]
                .id('4')
                // [EndExclude symbol_span_font_size]
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
                }
                // [StartExclude symbol_span_font_weight]
                .id('5')
                // [EndExclude symbol_span_font_weight]
              }

              Column() {
                Text('Normal')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(96)
                }
                // [StartExclude symbol_span_font_weight]
                .id('6')
                // [EndExclude symbol_span_font_weight]
              }

              Column() {
                Text('Bold')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Bold)
                    .fontSize(96)
                }
                // [StartExclude symbol_span_font_weight]
                .id('7')
                // [EndExclude symbol_span_font_weight]
              }
            }

            // [End symbol_span_font_weight]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_4') }) {
            // [Start symbol_span_font_color]
            Row() {
              Column() {
                Text("Black")
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Black])
                }
                // [StartExclude symbol_span_font_color]
                .id('8')
                // [EndExclude symbol_span_font_color]
              }

              Column() {
                Text('Green')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Green])
                }
                // [StartExclude symbol_span_font_color]
                .id('9')
                // [EndExclude symbol_span_font_color]
              }

              Column() {
                Text('Pink')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Pink])
                }
                // [StartExclude symbol_span_font_color]
                .id('10')
                // [EndExclude symbol_span_font_color]
              }
            }

            // [End symbol_span_font_color]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_5') }) {
            // [Start symbol_span_rendering_strategy]
            Row() {
              Column() {
                Text('单色')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
                // [StartExclude symbol_span_rendering_strategy]
                .id('11')
                // [EndExclude symbol_span_rendering_strategy]
              }

              Column() {
                Text('多色')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
                // [StartExclude symbol_span_rendering_strategy]
                .id('12')
                // [EndExclude symbol_span_rendering_strategy]
              }

              Column() {
                Text('分层')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
                // [StartExclude symbol_span_rendering_strategy]
                .id('13')
                // [EndExclude symbol_span_rendering_strategy]
              }
            }

            // [End symbol_span_rendering_strategy]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_6') }) {
            // [Start symbol_span_effect_strategy]
            Row() {
              Column() {
                Text('无动效')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.NONE)
                }
                // [StartExclude symbol_span_effect_strategy]
                .id('14')
                // [EndExclude symbol_span_effect_strategy]
              }

              Column() {
                Text('整体缩放动效')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.SCALE)
                }
                // [StartExclude symbol_span_effect_strategy]
                .id('15')
                // [EndExclude symbol_span_effect_strategy]
              }

              Column() {
                Text('层级动效')
                Text() {
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
                }
                // [StartExclude symbol_span_effect_strategy]
                .id('16')
                // [EndExclude symbol_span_effect_strategy]
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