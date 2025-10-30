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
// [Start web_DataDetector_Hightlighting]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  webController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Row() {
        Button('Refresh')
          .onClick(() => {
            this.webController.refresh();
          })
      }

      Web({
        src: $rawfile('index.html'),
        controller: this.webController
      })
        .enableDataDetector(true)
        .dataDetectorConfig({
          types: []  // 实体识别类型，为空则识别所有类型
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End web_DataDetector_Hightlighting]
