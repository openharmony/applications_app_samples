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

import { webview } from '@kit.ArkWeb';
import { call } from '@kit.TelephonyKit';
// [Start click_link_call_html_to_reach_phone_dialing_screen]
@Entry
@Component
struct WebComponent {
  webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: $rawfile('call.html'), controller: this.webviewController })
        .onLoadIntercept((event) => {
          if (event) {
            let url: string = event.data.getRequestUrl();
            // 判断链接是否为拨号链接
            if (url.indexOf('tel://') === 0) {
              // 跳转拨号界面
              call.makeCall(url.substring(6), (err) => {
                if (!err) {
                  console.info('make call succeeded.');
                } else {
                  console.info('make call fail, err is:' + JSON.stringify(err));
                }
              });
              return true;
            }
          }
          return false;
        })
    }
  }
}
//[End click_link_call_html_to_reach_phone_dialing_screen]
