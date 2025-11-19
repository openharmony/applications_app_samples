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

// Second.ets
import { webview } from '@kit.ArkWeb';
import { getNWeb } from './common';

@Builder
export function PageTwoBuilder() {
  Second();
}

@Component
export struct Second {
  webviewController: webview.WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    // 输出Web页面加载开始时间
    console.info('load page start time: ', Date.now());
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          // url请替换为真实地址
          NodeContainer(getNWeb('https://www.example.com'))
            .height('100')
            .width('100')
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}