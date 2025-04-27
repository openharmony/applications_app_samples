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

// [Start check_whether_cookies_exist_in_mode]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Button('existCookie')
        .onClick(() => {
          // existCookie参数表示隐私模式（true）或非隐私模式（false）下，查询是否存在cookies。
          let result = webview.WebCookieManager.existCookie(true);
          console.log('result: ' + result);
        })
      Web({ src: 'www.example.com', controller: this.controller, incognitoMode: true });
    }
  }
}
// [End check_whether_cookies_exist_in_mode]