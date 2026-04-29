/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start web_module_pdf_load_event]
// [Start web_module_pdf_scroll_at_bottom_event]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct PdfEvent {
  controller: webview.WebviewController = new webview.WebviewController();

  // [StartExclude web_module_pdf_scroll_at_bottom_event]
  // [StartExclude web_module_pdf_load_event]
  @State loadEventMessage: string = 'PdfLoadEvent:pending';
  @State scrollEventMessage: string = 'PdfScrollAtBottomEvent:pending';
  // [EndExclude web_module_pdf_load_event]
  // [EndExclude web_module_pdf_scroll_at_bottom_event]

  build() {
    Column() {
      // [StartExclude web_module_pdf_scroll_at_bottom_event]
      // [StartExclude web_module_pdf_load_event]
      Text(`${this.loadEventMessage}\n${this.scrollEventMessage}`)
        .fontSize(16)
        .margin(12)
      // [EndExclude web_module_pdf_load_event]
      // [EndExclude web_module_pdf_scroll_at_bottom_event]
      Web({
        src: 'resource://rawfile/test.pdf',
        controller: this.controller
      })
      // [StartExclude web_module_pdf_scroll_at_bottom_event]
        .onPdfLoadEvent(eventInfo => {
            // [StartExclude web_module_pdf_load_event]
            this.loadEventMessage = `PdfLoadEvent:${eventInfo.result}`;
            // [EndExclude web_module_pdf_load_event]
            console.info(`Load event callback called. url: ${eventInfo.url}, result: ${eventInfo.result}.`)
          }
        )
        // [EndExclude web_module_pdf_scroll_at_bottom_event]
        // [StartExclude web_module_pdf_load_event]
        .onPdfScrollAtBottom(eventInfo => {
            // [StartExclude web_module_pdf_scroll_at_bottom_event]
            this.scrollEventMessage = `PdfScrollAtBottomEvent:${eventInfo.url}`;
            // [EndExclude web_module_pdf_scroll_at_bottom_event]
            console.info(`Scroll at bottom callback called. url: ${eventInfo.url}.`)
          }
        )
        // [EndExclude web_module_pdf_load_event]
        .domStorageAccess(true)
    }
    .width('100%')
    .height('100%')
  }
}
// [End web_module_pdf_load_event]
// [END web_module_pdf_scroll_at_bottom_event]
