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
      Button('JavaScriptProxy')
        .onClick(() => {
          router.pushUrl({ url: 'pages/JavaScriptProxy' });
        })
      Button('Promise_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Promise_one' });
        })
      Button('Promise_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Promise_two' });
        })
      Button('RegisterJavaScriptProxy')
        .onClick(() => {
          router.pushUrl({ url: 'pages/RegisterJavaScriptProxy' });
        })
      Button('UsageOfComplexTypes_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsageOfComplexTypes_one' });
        })
      Button('UsageOfComplexTypes_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsageOfComplexTypes_two' });
        })
      Button('UsageOfComplexTypes_three')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsageOfComplexTypes_three' });
        })
      Button('UsageOfComplexTypes_four')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsageOfComplexTypes_four' });
        })
      Button('UsageOfComplexTypes_five')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsageOfComplexTypes_five' });
        })
    }.height('100%')
    .width('100%')
  }
}