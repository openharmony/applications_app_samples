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
      Button('DarkMode_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DarkMode_one' });
        })
      Button('DarkMode_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DarkMode_two' });
        })
      Button('AllowGeolocation')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AllowGeolocation' });
        })
      Button('ClearAllCookiesSync')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ClearAllCookiesSync' });
        })
      Button('ConfigCookieSync')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ConfigCookieSync' });
        })
      Button('DeleteAllData')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DeleteAllData' });
        })
      Button('DeleteGeolocation')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DeleteGeolocation' });
        })
      Button('ExistCookie')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ExistCookie' });
        })
      Button('FetchCookieSync')
        .onClick(() => {
          router.pushUrl({ url: 'pages/FetchCookieSync' });
        })
      Button('GetAccessibleGeolocation')
        .onClick(() => {
          router.pushUrl({ url: 'pages/GetAccessibleGeolocation' });
        })
      Button('IncognitoMode_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/IncognitoMode_one' });
        })
      Button('IncognitoMode_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/IncognitoMode_two' });
        })
      Button('OpenPageNewWin')
        .onClick(() => {
          router.pushUrl({ url: 'pages/OpenPageNewWin' });
        })
      Button('ManageLocPerms')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ManageLocPerms' });
        })
    }.height('100%')
    .width('100%')
  }
}