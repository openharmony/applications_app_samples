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
export struct TextSpan {
  @State onClickText: ResourceStr = 'I am Upper-span2';

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.TextSpan_title_1')替换为实际资源文件，在本示例中该资源文件的value值为"创建Span"
        ComponentCard({ title: $r('app.string.TextSpan_title_1') }) {
          // [Start create_span]
          // 请将$r('app.string.TextSpan_textContent_text')替换为实际资源文件，在本示例中该资源文件的value值为"我是Text"
          Text($r('app.string.TextSpan_textContent_text')) {
            // 请将$r('app.string.TextSpan_textContent_span')替换为实际资源文件，在本示例中该资源文件的value值为"我是Span"
            Span($r('app.string.TextSpan_textContent_span'))
          }
          .padding(10)
          .borderWidth(1)
          // [End create_span]
        }

        // 请将$r('app.string.TextSpan_title_2')替换为实际资源文件，在本示例中该资源文件的value值为"设置文本装饰线及颜色"
        ComponentCard({ title: $r('app.string.TextSpan_title_2') }) {
          // [Start create_span_with_lines]
          Text() {
            // 请将$r('app.string.TextSpan_textContent_span_one')替换为实际资源文件，在本示例中该资源文件的value值为"我是Span1，"
            Span($r('app.string.TextSpan_textContent_span_one'))
              .fontSize(16)
              .fontColor(Color.Grey)
              .decoration({ type: TextDecorationType.LineThrough, color: Color.Red })
            // 请将$r('app.string.TextSpan_textContent_span_two')替换为实际资源文件，在本示例中该资源文件的value值为"我是Span2"
            Span($r('app.string.TextSpan_textContent_span_two'))
              .fontColor(Color.Blue)
              .fontSize(16)
              .fontStyle(FontStyle.Italic)
              .decoration({ type: TextDecorationType.Underline, color: Color.Black })
            // 请将$r('app.string.TextSpan_textContent_span_three')替换为实际资源文件，在本示例中该资源文件的value值为"我是Span3"
            Span($r('app.string.TextSpan_textContent_span_three'))
              .fontSize(16)
              .fontColor(Color.Grey)
              .decoration({ type: TextDecorationType.Overline, color: Color.Green })
          }
          .borderWidth(1)
          .padding(10)
          // [End create_span_with_lines]
        }

        // 请将$r('app.string.TextSpan_title_3')替换为实际资源文件，在本示例中该资源文件的value值为"通过textCase设置文字一直保持大写或者小写状态"
        ComponentCard({ title: $r('app.string.TextSpan_title_3') }) {
          // [Start create_span_with_upper_case]
          Text() {
            Span('I am Upper-span').fontSize(12)
              .textCase(TextCase.UpperCase)
          }
          .borderWidth(1)
          .padding(10)
          // [End create_span_with_upper_case]
        }

        // 请将$r('app.string.TextSpan_title_4')替换为实际资源文件，在本示例中该资源文件的value值为"添加事件"
        ComponentCard({ title: $r('app.string.TextSpan_title_4') }) {
          // [Start create_span_with_onclick]
          Text() {
            Span(this.onClickText)
              .fontSize(12)
              .textCase(TextCase.UpperCase)
              .onClick(() => {
                // 请将$r('app.string.TextSpan_textContent_6')替换为实际资源文件，在本示例中该资源文件的value值为"我是Span——onClick"
                this.onClickText = $r('app.string.TextSpan_textContent_6');
              })
          }
          // [End create_span_with_onclick]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.TextSpan_title')替换为实际资源文件，在本示例中该资源文件的value值为"添加子组件"
    .title($r('app.string.TextSpan_title'))
  }
}