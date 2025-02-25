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
      Button('LocCrossOriginResAccSol_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/LocCrossOriginResAccSol_one' });
        })
      Button('LocCrossOriginResAccSol_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/LocCrossOriginResAccSol_two' });
        })
      Button('AddIntTrackPreventByPassList')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AddIntTrackPreventByPassList' });
        })
      Button('ClearIntTrackPreventByPassList')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ClearIntTrackPreventByPassList' });
        })
      Button('EnableIntTrackPrevent')
        .onClick(() => {
          router.pushUrl({ url: 'pages/EnableIntTrackPrevent' });
        })
      Button('IsIntTrackPreventEnabled')
        .onClick(() => {
          router.pushUrl({ url: 'pages/IsIntTrackPreventEnabled' });
        })
      Button('OnIntTrackPreventResult')
        .onClick(() => {
          router.pushUrl({ url: 'pages/OnIntTrackPreventResult' });
        })
      Button('RemoveIntTrackPreventByPassList')
        .onClick(() => {
          router.pushUrl({ url: 'pages/RemoveIntTrackPreventByPassList' });
        })
      Button('EnablingAdsBlocking')
        .onClick(() => {
          router.pushUrl({ url: 'pages/EnablingAdsBlocking' });
        })
      Button('DisAdsBlockSpecDomPages_one')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DisAdsBlockSpecDomPages_one' });
        })
      Button('DisAdsBlockSpecDomPages_two')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DisAdsBlockSpecDomPages_two' });
        })
      Button('CollectingAdsBlockingInformation')
        .onClick(() => {
          router.pushUrl({ url: 'pages/CollectingAdsBlockingInformation' });
        })
    }.height('100%')
    .width('100%')
  }
}