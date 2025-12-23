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

@Entry
@Component
export struct TextImageComponent {
  build() {
    NavDestination() {
      // [Start textImage_component]
      Text() {
        // 请将$r('app.media.hot_sale')替换为实际资源文件
        ImageSpan($r('app.media.hot_sale'))
          .width(50)
          .height(30)
          .borderRadius(5)
          .verticalAlign(ImageSpanAlignment.FOLLOW_PARAGRAPH)
        // 请将$r('app.string.surprise_price')替换为实际资源文件，在本示例中该资源文件的value值为"惊喜价 ￥1299"
        Span($r('app.string.surprise_price'))
          .fontSize(25)
          .fontColor(Color.Red)
        Span('1599')
          .decoration({
            type: TextDecorationType.LineThrough,
            color: Color.Grey,
            style: TextDecorationStyle.SOLID
          })
          .fontSize(16)
      }.textVerticalAlign(TextVerticalAlign.CENTER)
      // [End textImage_component]
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.TextImage_MixedLayout_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"使用Span和ImageSpan实现图文混排"
    .title($r('app.string.TextImage_MixedLayout_Text_1'))
  }
}
