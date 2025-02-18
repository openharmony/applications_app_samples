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

import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 10 }) {
      Button('InitiatePrintW3CAPI')
        .onClick(() => {
          router.pushUrl({ url: 'pages/InitiatePrintW3CAPI' });
        })
      Button('InitiatePrintAppAPI')
        .onClick(() => {
          router.pushUrl({ url: 'pages/InitiatePrintAppAPI' });
        })
      Button('PreviewPDF')
        .onClick(() => {
          router.pushUrl({ url: 'pages/PreviewPDF' });
        })
      Button('CalcAdjustSafeArea')
        .onClick(() => {
          router.pushUrl({ url: 'pages/CalcAdjustSafeArea' });
        })
    }.height('100%')
    .width('100%')
  }
}