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

// [Start a_page_that_contains_a_webview_and_text_in_the_comment_section]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebHeightPage {
  private webviewController: WebviewController = new webview.WebviewController();
  private scroller: Scroller = new Scroller();

  build() {
    Navigation() {
      Column() {
        Scroll(this.scroller) {
          Column() {
            Web({
              src: $rawfile('fit_content.html'),
              controller: this.webviewController,
              renderMode: RenderMode.SYNC_RENDER // 设置为同步渲染模式
            })
              .layoutMode(WebLayoutMode.FIT_CONTENT)// 设置为Web组件大小自适应页面内容
              .overScrollMode(OverScrollMode.NEVER) // 设置过滚动模式为关闭状态
            Text($r('app.string.Comment_area'))
              .fontSize(28)
              .fontColor('#FF0F0F')
              .height(100)
              .width('100%')
              .backgroundColor('#f89f0f')
          }
        }
      }
    }
    .title($r('app.string.Title_bar'))
  }
}
// [End a_page_that_contains_a_webview_and_text_in_the_comment_section]