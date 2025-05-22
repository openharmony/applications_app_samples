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
  @State onClickText: ResourceStr = 'I am Upper-span';

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.TextSpan_title_1') }) {
          // [Start create_span]
          Text($r('app.string.TextSpan_textContent_1')) {
            Span($r('app.string.TextSpan_textContent_2'))
          }
          .padding(10)
          .borderWidth(1)
          // [End create_span]
        }

        ComponentCard({ title: $r('app.string.TextSpan_title_2') }) {
          // [Start create_span_with_lines]
          Text() {
            Span($r('app.string.TextSpan_textContent_3'))
              .fontSize(16)
              .fontColor(Color.Grey)
              .decoration({ type: TextDecorationType.LineThrough, color: Color.Red })
            Span($r('app.string.TextSpan_textContent_4'))
              .fontColor(Color.Blue)
              .fontSize(16)
              .fontStyle(FontStyle.Italic)
              .decoration({ type: TextDecorationType.Underline, color: Color.Black })
            Span($r('app.string.TextSpan_textContent_5'))
              .fontSize(16)
              .fontColor(Color.Grey)
              .decoration({ type: TextDecorationType.Overline, color: Color.Green })
          }
          .borderWidth(1)
          .padding(10)
          // [End create_span_with_lines]
        }

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

        ComponentCard({ title: $r('app.string.TextSpan_title_4') }) {
          // [Start create_span_with_onclick]
          Text() {
            Span(this.onClickText)
              .fontSize(12)
              .textCase(TextCase.UpperCase)
              .onClick(() => {
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
    .title($r('app.string.TextSpan_title'))
  }
}