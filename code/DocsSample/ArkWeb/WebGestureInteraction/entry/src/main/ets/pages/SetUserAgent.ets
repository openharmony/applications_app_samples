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
// [Start SetUserAgent]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  private webController: webview.WebviewController = new webview.WebviewController();
  build(){
    Column() {
      Web({
        src: 'https://www.example.com',
        controller: this.webController,
      }).onControllerAttached(() => {
        // 自定义User-Agent
        let customUA = 'Mozilla/5.0 (Phone; Android; HarmonyOS 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36';
        this.webController.setCustomUserAgent(customUA);
      })
    }
  }
}
// [End SetUserAgent]