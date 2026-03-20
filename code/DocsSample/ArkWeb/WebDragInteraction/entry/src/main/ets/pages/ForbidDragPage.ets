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
// [Start ForbidDragPage]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  webViewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Button('w3cDemoPage')
        .onClick(() => {
          this.webViewController.loadUrl($rawfile('w3c-forbid.html'));
        })
      Button('runJsDemoPage')
        .onClick(() => {
          this.webViewController.loadUrl($rawfile('runJs-forbid.html'));
        })
      Button('runJsForbidDrag')
        .onClick(() => {
          try {
            // 使用runJavaScriptExt执行脚本添加dragstart事件监听器去禁用拖拽
            this.webViewController.runJavaScriptExt(
              'window.addEventListener(\'dragstart\', (ev) => {\n' +
                'ev.preventDefault();\n' +
                '});',
              (error, result) => {
                if (error) {
                  console.error(`run JavaScript error, ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`)
                  return;
                }
              });
          } catch (resError) {
            console.error(`ErrorCode: ${(resError as BusinessError).code},  Message: ${(resError as BusinessError).message}`);
          }
        })
      Web({
        src: $rawfile('w3c-forbid.html'),
        controller: this.webViewController
      })
        .domStorageAccess(true)
        .javaScriptAccess(true)
        .fileAccess(true)
    }
    .height('100%')
    .width('100%')
  }
}
// [End ForbidDragPage]