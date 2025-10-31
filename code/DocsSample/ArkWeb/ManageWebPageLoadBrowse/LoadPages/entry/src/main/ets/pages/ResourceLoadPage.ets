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
// [Start resource_loading]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct ResourceWebComponent {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Button('LoadResource')
        .onClick(() => {
          try {
            // 通过resource加载resources/rawfile目录下的index1.html文件。
            this.controller.loadUrl('resource://rawfile/index1.html');
          } catch (error) {
            console.error(`ErrorCode: ${error.code}, Message: ${error.message}`);
          }
        })

      // 组件创建时直接使用resource协议加载资源。
      Web({ src: 'resource://rawfile/index.html', controller: this.controller });
    }
  }
}
// [End resource_loading]