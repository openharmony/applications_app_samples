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

import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('getStringSync(id)')
        .fontSize(32)
        .fontColor(Color.Blue)
        .margin({bottom: 30})
        .onClick(() => {
          router.pushUrl({ url: 'pages/GetStringSyncAfter' })
        })
      Text('getStringSync(Resource)')
        .fontSize(32)
        .fontColor(Color.Blue)
        .margin({bottom: 30})
        .onClick(() => {
          router.pushUrl({ url: 'pages/GetStringSync' })
        })
      Text('Using Word Break')
        .fontSize(32)
        .fontColor(Color.Blue)
        .margin({bottom: 30})
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsingWordBreak' })
        })
      Text('Using Zero Width Space')
        .fontSize(32)
        .fontColor(Color.Blue)
        .onClick(() => {
          router.pushUrl({ url: 'pages/UsingZeroWidthSpace' })
        })
      Text('GetAnonymousIdSync')
        .fontSize(32)
        .fontColor(Color.Blue)
        .onClick(() => {
          router.pushUrl({ url: 'pages/GetAnonymousIdSync' })
        })
      Text('GetAnonymousId')
        .fontSize(32)
        .fontColor(Color.Blue)
        .onClick(() => {
          router.pushUrl({ url: 'pages/GetAnonymousId' })
        })
      Text('RuntimeInterface')
        .fontSize(32)
        .fontColor(Color.Blue)
        .onClick(() => {
          router.pushUrl({ url: 'pages/RuntimeInterface' })
        })
      Text('LocalizationKitInterface')
        .fontSize(32)
        .fontColor(Color.Blue)
        .onClick(() => {
          router.pushUrl({ url: 'pages/LocalizationKitInterface' })
        })
    }
    .height('100%')
    .width('100%')
  }
}