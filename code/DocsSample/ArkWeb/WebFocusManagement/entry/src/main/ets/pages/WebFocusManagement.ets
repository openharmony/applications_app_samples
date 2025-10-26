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
// [Start WebFocusManagement]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';
const TAG = '[Sample_WebFocusManagement]';
const DOMAIN = 0xF811;
const BUNDLE = 'WebFocusManagement_';
@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  controller2: webview.WebviewController = new webview.WebviewController();
  @State webBorderColor: Color = Color.Red;
  @State webBorderColor2: Color = Color.Red;

  build() {
    Column() {
      Row() {
        Button('web1 requestFocus')
          .onClick(() => {
            try {
              this.controller.requestFocus();
            } catch (error) {
              hilog.error(DOMAIN, TAG, BUNDLE, `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
            }
          });
        Button('web2 requestFocus')
          .onClick(() => {
            try {
              this.controller2.requestFocus();
            } catch (error) {
              hilog.error(DOMAIN, TAG, BUNDLE, `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
            }
          });
      }
      Web({ src: 'www.example.com', controller: this.controller })
        .onFocus(() => {
          this.webBorderColor = Color.Green;
        })
        .onBlur(() => {
          this.webBorderColor = Color.Red;
        })
        // [StartExclude WebFocusManagement]
        .id('web1')
        // [EndExclude WebFocusManagement]
        .margin(3)
        .borderWidth(10)
        .borderColor(this.webBorderColor)
        .height('45%')

      Web({ src: 'www.example.com', controller: this.controller2 })
        .onFocus(() => {
          this.webBorderColor2 = Color.Green;
        })
        .onBlur(() => {
          this.webBorderColor2 = Color.Red;
        })
        .margin(3)
        .borderWidth(10)
        .borderColor(this.webBorderColor2)
        .height('45%')
    }
  }
}
// [End WebFocusManagement]