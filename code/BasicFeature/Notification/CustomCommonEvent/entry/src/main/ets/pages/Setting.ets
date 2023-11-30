/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import commonEvent from '@ohos.commonEventManager';
import common from '@ohos.app.ability.common';
import settingFeature from '../feature/SettingFeature';
import { Header } from '../component/Header';
import launchFeature from '../feature/LaunchFeature';

class EventData {
  event: string = '';
  title: Resource | null = null;
}

@Entry
@Component
struct Setting {
  private featureLaunch: launchFeature = new launchFeature(getContext() as common.UIAbilityContext);
  private feature: settingFeature = new settingFeature(getContext() as common.UIAbilityContext);
  private dataSource: Array<EventData> = [
    { event: commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE, title: $r('app.string.enable_wifi') },
    { event: commonEvent.Support.COMMON_EVENT_SCREEN_OFF, title: $r('app.string.enable_screen_off') },
    { event: commonEvent.Support.COMMON_EVENT_SCREEN_ON, title: $r('app.string.enable_screen_on') },
    { event: commonEvent.Support.COMMON_EVENT_SCREEN_LOCKED, title: $r('app.string.enable_screen_locked') },
    { event: commonEvent.Support.COMMON_EVENT_SCREEN_UNLOCKED, title: $r('app.string.enable_screen_unlocked') }
  ];

  aboutToAppear() {
    this.feature.init();
  }

  build() {
    Column({ space: 8 }) {
      Header({ src: 'settingTitle.png' })
      Column() {
        ForEach(this.dataSource, (item: EventData) => {
          Column() {
            Text(item.title)
              .width('100%')
              .height('20%')
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .fontColor(0x000000)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Column() {
                Text($r('app.string.always')).fontSize(14)
                Radio({ value: 'always', group: item.event })
                  .id(item.event + '0')
                  .checked(this.feature.checkStateForAlways(item.event))
                  .height(20)
                  .width(20)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.feature.changeStateToAlways(item.event)
                    }
                  })
              }

              Divider().vertical(true).margin(20).height(20)
              Column() {
                Text($r('app.string.once')).fontSize(14)
                Radio({ value: 'once', group: item.event })
                  .id(item.event + '1')
                  .checked(this.feature.checkStateForOnce(item.event))
                  .height(20)
                  .width(20)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.feature.changeStateToOnce(item.event)
                    }
                  })
              }

              Divider().vertical(true).margin(20).height(20)
              Column() {
                Text($r('app.string.never')).fontSize(14)
                Radio({ value: 'never', group: item.event })
                  .id(item.event + '2')
                  .checked(this.feature.checkStateForNever(item.event))
                  .height(20)
                  .width(20)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.feature.changeStateToNever(item.event)
                    }
                  })
              }
            }.padding({ top: 10 })
            .backgroundColor(0xfbfafb)
            .borderRadius(10)
            .opacity(0.8)
          }
          .height('15%')
          .width('100%')
        })
        Button($r('app.string.SubscribeEvent'))
          .backgroundColor($r('app.color.subscribe_events_background'))
          .fontSize($r('app.float.button_fount_size'))
          .fontColor($r('app.color.subscribe_events_fount'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .onClick(this.featureLaunch.jumpToCommonEvent)
          .width('624px')
          .id('jumpToCommonEvent')
          .margin({top:25})
      }.width('90%')
      .height('100%')
      .position({ x: '5%', y: '10%' })
    }.backgroundImage($rawfile('vbg720.png'))
    .backgroundImageSize(ImageSize.Contain)
    .width('100%')
    .height('100%')
  }
}