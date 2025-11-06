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
              // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
              SymbolSpan($r('sys.symbol.ohos_trash'))
                .fontWeight(FontWeight.Normal)
                .fontSize(96)
            }
            // [End creat_symbol_span]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_2') }) {
            // [Start symbol_span_font_size]
            Row() {
              Column() {
                Text('48')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(48)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
              }

              Column() {
                Text('72')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(72)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
              }

              Column() {
                Text('96')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
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
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Lighter)
                    .fontSize(96)
                }
              }

              Column() {
                Text('Normal')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(96)
                }
              }

              Column() {
                Text('Bold')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontWeight(FontWeight.Bold)
                    .fontSize(96)
                }
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
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Black])
                }
              }

              Column() {
                Text('Green')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Green])
                }
              }

              Column() {
                Text('Pink')
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .fontColor([Color.Pink])
                }
              }
            }
            // [End symbol_span_font_color]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_5') }) {
            // [Start symbol_span_rendering_strategy]
            Row() {
              Column() {
                // 'app.string.single_color'资源文件中的value值为"单色"
                Text($r('app.string.single_color'));
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
              }

              Column() {
                // 'app.string.multi_color'资源文件中的value值为"多色"
                Text($r('app.string.multi_color'));
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
              }

              Column() {
                // 'app.string.hierarchical'资源文件中的value值为"分层"
                Text($r('app.string.hierarchical'));
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_folder_badge_plus'))
                    .fontSize(96)
                    .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
                    .fontColor([Color.Black, Color.Green, Color.White])
                }
              }
            }
            // [End symbol_span_rendering_strategy]
          }

          ComponentCard({ title: $r('app.string.SymbolGlyphSpanAddToText_title_6') }) {
            // [Start symbol_span_effect_strategy]
            Row() {
              Column() {
                // 'app.string.no_action'资源文件中的value值为"无动效"
                Text($r('app.string.no_action'));
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.NONE)
                }
              }

              Column() {
                // 'app.string.overall_scaling_animation_effect'资源文件中的value值为"整体缩放动效"
                Text($r('app.string.overall_scaling_animation_effect'));
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.SCALE)
                }
              }

              Column() {
                // 'app.string.hierarchical_animation'资源文件中的value值为"层级动效"
                Text($r('app.string.hierarchical_animation'));
                Text() {
                  // $r('sys.symbol.xxx')需要替换成开发者需要的系统资源
                  SymbolSpan($r('sys.symbol.ohos_wifi'))
                    .fontSize(96)
                    .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
                }
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