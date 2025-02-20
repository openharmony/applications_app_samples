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

import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  build() {
    Column({ space: 10 }) {
      Button('UserAgent_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UserAgent_one' });
        })
      Button('UserAgent_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UserAgent_two' });
        })
      Button('UserAgent_three')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UserAgent_three' });
        })
      Button('CookieManagement')
        .onClick(() => {
          router.pushUrl({ url: 'pages/CookieManagement' });
        })
      Button('Cache_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Cache_one' });
        })
      Button('Cache_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Cache_two' });
        })
      Button('DomStorage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DomStorage' });
        })
      Button('UseMotionDirSensor')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UseMotionDirSensor' });
        })
    }.height('100%')
    .width('100%')
  }
}