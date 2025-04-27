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

// [Start interact_with_the_webview_via_the_native_api]
// [Start use_the_native_interface_to_bind_arkweb]
import testNapi from 'libentry.so';
import { webview } from '@kit.ArkWeb';

class testObj {
  constructor() {
  }

  test(): string {
    console.log('ArkUI Web Component');
    return 'ArkUI Web Component';
  }

  toString(): void {
    console.log('Web Component toString');
  }
}

@Entry
@Component
struct Index {
  // [Start customize_a_webtag_and_send_it_to_the_native_side_of_the_application]
  webTag: string = 'ArkWeb1';
  controller: webview.WebviewController = new webview.WebviewController(this.webTag);
  @State testObjtest: testObj = new testObj();

  aboutToAppear() {
    console.info('aboutToAppear');
    //初始化web Native Development Kit
    testNapi.nativeWebInit(this.webTag);
    // [End customize_a_webtag_and_send_it_to_the_native_side_of_the_application]
  }
  // [End use_the_native_interface_to_bind_arkweb]

  build() {
    Column() {
      Row() {
        Button('runJS hello')
          .fontSize(12)
          .onClick(() => {
            testNapi.runJavaScript(this.webTag, 'runJSRetStr(\"" + "hello" + "\")');
          })
      }.height('20%')

      Row() {
        Web({ src: $rawfile('runJS.html'), controller: this.controller })
          .javaScriptAccess(true)
          .fileAccess(true)
          .onControllerAttached(() => {
            console.error('Native Development Kit onControllerAttached webId: ' + this.controller.getWebId());
          })
      }.height('80%')
    }
  }
}
// [End interact_with_the_webview_via_the_native_api]