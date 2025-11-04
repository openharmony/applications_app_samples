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
export struct CustomTextStyle {
  scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.CustomTextStyle_title_1') }) {
            Column() {
              // [Start custom_text_align]
              // 'app.string.TextAlign_Start'资源文件中的value值为'左对齐'
              Text($r('app.string.TextAlign_Start'))
                .width(300)
                .textAlign(TextAlign.Start)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.TextAlign_Center'资源文件中的value值为'中间对齐'
              Text($r('app.string.TextAlign_Center'))
                .width(300)
                .textAlign(TextAlign.Center)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.TextAlign_End'资源文件中的value值为'右对齐'
              Text($r('app.string.TextAlign_End'))
                .width(300)
                .textAlign(TextAlign.End)
                .border({ width: 1 })
                .padding(10)
              // [End custom_text_align]
            }
          }

          ComponentCard({
            title: $r('app.string.CustomTextStyle_title_2'),
            description: $r('app.string.CustomTextStyle_description_1')
          }) {
            Column({ space: 8 }) {
              // [Start custom_text_overflow]
              Text('This is the setting of textOverflow to Clip text content This is the setting of textOverflow ' +
                'to None text content. This is the setting of textOverflow to Clip text content This is the setting ' +
                'of textOverflow to None text content.')
                .width(250)
                .textOverflow({ overflow: TextOverflow.None })
                .maxLines(1)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.CustomTextStyle_textContent_1'资源文件中的value值为
              // '我是超长文本，超出的部分显示省略号 I am an extra long text, with ellipses displayed for any excess。'
              Text($r('app.string.CustomTextStyle_textContent_1'))
                .width(250)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.CustomTextStyle_textContent_2'资源文件中的value值为
              // '当文本溢出其尺寸时，文本将滚动显示
              // When the text overflows its dimensions,the text will scroll for displaying.'
              Text($r('app.string.CustomTextStyle_textContent_2'))
                .width(250)
                .textOverflow({ overflow: TextOverflow.MARQUEE })
                .maxLines(1)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.CustomTextStyle_textContent_8'资源文件中的value值为
              // '当文本溢出其尺寸时，文本将滚动显示，支持设置跑马灯配置项
              // When the text overflows its dimensions, the text will scroll for displaying.'
              Text($r('app.string.CustomTextStyle_textContent_8'))
                .width(250)
                .textOverflow({ overflow: TextOverflow.MARQUEE })
                .maxLines(1)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .marqueeOptions({
                  start: true,
                  fromStart: true,
                  step: 6,
                  loop: -1,
                  delay: 0,
                  fadeout: false,
                  marqueeStartPolicy: MarqueeStartPolicy.DEFAULT
                })
              // [End custom_text_overflow]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_3') }) {
            Column({ space: 8 }) {
              // [Start custom_line_height]
              Text('This is the text with the line height set. This is the text with the line height set.')
                .width(300).fontSize(12).border({ width: 1 }).padding(10)
              Text('This is the text with the line height set. This is the text with the line height set.')
                .width(300)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .lineHeight(20)
              // [End custom_line_height]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_4') }) {
            Column({ space: 8 }) {
              // [Start custom_text_line_and_color]
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.LineThrough,
                  color: Color.Red
                })
                .borderWidth(1).padding(15).margin(5)
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.Overline,
                  color: Color.Red
                })
                .borderWidth(1).padding(15).margin(5)
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.Underline,
                  color: Color.Red
                })
                .borderWidth(1).padding(15).margin(5)
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.Underline,
                  color: Color.Blue,
                  style: TextDecorationStyle.DASHED
                })
                .borderWidth(1).padding(15).margin(5)
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.Underline,
                  color: Color.Blue,
                  style: TextDecorationStyle.DOTTED
                })
                .borderWidth(1).padding(15).margin(5)
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.Underline,
                  color: Color.Blue,
                  style: TextDecorationStyle.DOUBLE
                })
                .borderWidth(1).padding(15).margin(5)
              Text('This is the text')
                .decoration({
                  type: TextDecorationType.Underline,
                  color: Color.Blue,
                  style: TextDecorationStyle.WAVY,
                  thicknessScale: 4
                })
                .borderWidth(1).padding(15).margin(5)
              // [End custom_text_line_and_color]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_5') }) {
            Column({ space: 8 }) {
              // [Start custom_text_baseline_offset]
              Text('This is the text content with baselineOffset 0.')
                .baselineOffset(0)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
              Text('This is the text content with baselineOffset 30.')
                .baselineOffset(30)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
              Text('This is the text content with baselineOffset -20.')
                .baselineOffset(-20)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
              // [End custom_text_baseline_offset]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_6') }) {
            Column({ space: 8 }) {
              // [Start custom_text_letter_space]
              Text('This is the text content with letterSpacing 0.')
                .letterSpacing(0)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
              Text('This is the text content with letterSpacing 3.')
                .letterSpacing(3)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
              Text('This is the text content with letterSpacing -1.')
                .letterSpacing(-1)
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
              // [End custom_text_letter_space]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_7') }) {
            Column({ space: 8 }) {
              // [Start custom_the_size_of_text]
              // 'app.string.CustomTextStyle_textContent_3'资源文件中的value值为'我的最大字号为30，最小字号为5，宽度为250，maxLines为1'
              Text($r('app.string.CustomTextStyle_textContent_3'))
                .width(250)
                .maxLines(1)
                .maxFontSize(30)
                .minFontSize(5)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.CustomTextStyle_textContent_4'资源文件中的value值为'我的最大字号为30，最小字号为5，宽度为250，maxLines为2'
              Text($r('app.string.CustomTextStyle_textContent_4'))
                .width(250)
                .maxLines(2)
                .maxFontSize(30)
                .minFontSize(5)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.CustomTextStyle_textContent_5'资源文件中的value值为'我的最大字号为30，最小字号为15，宽度为250,高度为50'
              Text($r('app.string.CustomTextStyle_textContent_5'))
                .width(250)
                .height(50)
                .maxFontSize(30)
                .minFontSize(15)
                .border({ width: 1 })
                .padding(10)
              // 'app.string.CustomTextStyle_textContent_6'我的最大字号为30，最小字号为15，宽度为250,高度为100'
              Text($r('app.string.CustomTextStyle_textContent_6'))
                .width(250)
                .height(100)
                .maxFontSize(30)
                .minFontSize(15)
                .border({ width: 1 })
                .padding(10)
              // [End custom_the_size_of_text]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_8') }) {
            Column({ space: 8 }) {
              // [Start custom_the_text_by_text_case]
              Text('This is the text content with textCase set to Normal.')
                .textCase(TextCase.Normal)
                .padding(10)
                .border({ width: 1 })
                .padding(10)

              // 文本全小写展示
              Text('This is the text content with textCase set to LowerCase.')
                .textCase(TextCase.LowerCase)
                .border({ width: 1 })
                .padding(10)

              // 文本全大写展示
              Text('This is the text content with textCase set to UpperCase.')
                .textCase(TextCase.UpperCase)
                .border({ width: 1 })
                .padding(10)
              // [End custom_the_text_by_text_case]
              // [Start custom_the_text_fontFamily]
              Text('This is the text content with fontFamily')
                .fontSize(30)
                .fontFamily('HarmonyOS Sans')
              // [End custom_the_text_fontFamily]
            }
          }

          ComponentCard({ title: $r('app.string.CustomTextStyle_title_9') }) {
            // [Start custom_the_text_by_copy_option]
            // 'app.string.CustomTextStyle_textContent_7'资源文件中的value值为'我的最大字号为30，最小字号为15，宽度为250,高度为50'
            Text($r('app.string.CustomTextStyle_textContent_7'))
              .fontSize(30)
              .copyOption(CopyOptions.InApp)
            // [End custom_the_text_by_copy_option]
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomTextStyle_title'))
  }
}