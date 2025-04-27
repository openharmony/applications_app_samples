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

// [Start web_module_create_load_pdf]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({
        src:
        $r('app.string.web_path'), 				// 方式一 加载网络PDF文档
        // getContext(this).filesDir + '/test.pdf',   // 方式二 加载本地应用沙箱内PDF文档
        // 'resource://rawfile/test.pdf', 						// 方式三 应用内resource资源PDF文档
        // $rawfile('test.pdf'), 								        // 方式四 应用内resource资源PDF文档
        controller: this.controller
      })
        .domStorageAccess(true)
    }
  }
}
// [End web_module_create_load_pdf]
