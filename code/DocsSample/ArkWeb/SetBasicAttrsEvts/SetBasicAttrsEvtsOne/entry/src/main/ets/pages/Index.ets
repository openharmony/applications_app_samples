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
          this.getUIContext().getRouter().pushUrl({ url: 'pages/DarkMode_one' });
        })
      Button('DarkMode_two')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/DarkMode_two' });
        })
      Button('DarkMode_three')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/DarkMode_three' });
        })
      Button('AllowGeolocation')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/AllowGeolocation' });
        })
      Button('ClearAllCookiesSync')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/ClearAllCookiesSync' });
        })
      Button('ConfigCookieSync')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/ConfigCookieSync' });
        })
      Button('DeleteAllData')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/DeleteAllData' });
        })
      Button('DeleteGeolocation')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/DeleteGeolocation' });
        })
      Button('ExistCookie')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/ExistCookie' });
        })
      Button('FetchCookieSync')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/FetchCookieSync' });
        })
      Button('GetAccessibleGeolocation')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/GetAccessibleGeolocation' });
        })
      Button('IncognitoMode_one')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/IncognitoMode_one' });
        })
      Button('IncognitoMode_two')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/IncognitoMode_two' });
        })
      Button('OpenPageNewWin')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/OpenPageNewWin' });
        })
      Button('ManageLocPerms')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/ManageLocPerms' });
        })
    }.height('100%')
    .width('100%')
  }
}