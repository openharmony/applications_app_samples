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
import resource from '../../common/resource';

@Entry
@Component
export struct SymbolGlyphSpanSceneExample {
  @State triggerValueReplace: number = 0;
  @State symbolSources: Resource[] =
    [$r('sys.symbol.repeat'), $r('sys.symbol.repeat_1'), $r('sys.symbol.arrow_left_arrow_right')];
  @State symbolSourcesIndex: number = 0;
  @State symbolText: string[] = [resource.resourceToString($r('app.string.SymbolSceneExample_Text_1')),
    resource.resourceToString($r('app.string.SymbolSceneExample_Text_2')),
    resource.resourceToString($r('app.string.SymbolSceneExample_Text_3'))];
  @State symbolTextIndex: number = 0;
  @State fontColorValue: ResourceColor = Color.Grey;
  @State fontColorValue1: ResourceColor = '#E8E8E8';

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SymbolGlyphSpanSceneExample_title') }) {
          // [Start symbol_glyph_span_scene_example]
          Column({ space: 10 }) {
            Row() {
              Text() {
                Span(resource.resourceToString($r('app.string.SymbolSceneExample_Text_4')))
                  .fontSize(20)
                  .fontWeight(FontWeight.Bolder)
                Span('(101)')
              }.id('text1')
            }

            Row() {
              Row({ space: 5 }) {
                SymbolGlyph(this.symbolSources[this.symbolSourcesIndex])
                  .id('symbolGlyph1')
                  .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.triggerValueReplace)
                  .fontSize(20)
                  .fontColor([this.fontColorValue])
                Text(this.symbolText[this.symbolTextIndex])
                  .fontColor(this.fontColorValue)
              }
              .onClick(() => {
                this.symbolTextIndex++;
                this.symbolSourcesIndex++;
                this.triggerValueReplace++;
                if (this.symbolSourcesIndex > (this.symbolSources.length - 1)) {
                  this.symbolSourcesIndex = 0;
                  this.triggerValueReplace = 0;
                }
                if (this.symbolTextIndex > (this.symbolText.length - 1)) {
                  this.symbolTextIndex = 0;
                }
              })
              .width('75%')

              Row({ space: 5 }) {
                Text() {
                  SymbolSpan($r('sys.symbol.arrow_down_circle_badge_vip_circle_filled'))
                    .fontColor([this.fontColorValue])
                    .fontSize(20)
                }.id('text2')

                Text() {
                  SymbolSpan($r('sys.symbol.heart_badge_plus'))
                    .fontColor([this.fontColorValue])
                    .fontSize(20)
                }.id('text3')

                Text() {
                  SymbolSpan($r('sys.symbol.ohos_trash'))
                    .fontColor([this.fontColorValue])
                    .fontSize(20)
                }.id('text4')
              }
              .width('25%')
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_5'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph2')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph3')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_6'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph4')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph5')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_7'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph6')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph7')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_8'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph8')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph9')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_9'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph10')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph11')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_10'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph12')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph13')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Row() {
              Row() {
                Text($r('app.string.SymbolSceneExample_Text_11'))
              }.width('82%')

              Row({ space: 5 }) {
                SymbolGlyph($r('sys.symbol.play_arrow_triangle_2_circlepath'))
                  .id('symbolGlyph14')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
                SymbolGlyph($r('sys.symbol.trash'))
                  .id('symbolGlyph15')
                  .fontColor([this.fontColorValue])
                  .fontSize(20)
              }
            }

            Divider().width(5).color(this.fontColorValue1).width('98%')
            Column() {
              Text($r('app.string.SymbolSceneExample_Text_12'))
            }
            .alignItems(HorizontalAlign.Center)
            .width('98%')
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .height(400)
          .padding({
            left: 10,
            top: 10
          })
          // [End symbol_glyph_span_scene_example]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SymbolGlyphSpanSceneExample_title'))
  }
}