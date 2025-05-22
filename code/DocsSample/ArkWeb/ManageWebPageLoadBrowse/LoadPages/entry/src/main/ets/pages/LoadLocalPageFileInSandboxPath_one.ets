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

// [Start load_local_page_file_in_sandbox_path]
import { webview } from '@kit.ArkWeb';
import { GlobalContext } from './GlobalContext';

let url = 'file://' + GlobalContext.getContext().getObject('filesDir') + '/index.html';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Text('loading success');
      // 加载沙箱路径文件。
      Web({ src: url, controller: this.controller });
    }
  }
}
// [End load_local_page_file_in_sandbox_path]
