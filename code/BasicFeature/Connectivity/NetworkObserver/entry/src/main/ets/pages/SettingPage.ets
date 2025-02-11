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

import { logger } from '../utils/Logger';
import { emitter } from '@kit.BasicServicesKit';

@Component
export struct SettingPage {
  @Consume('navPathStack') navPathStack: NavPathStack;
  // WI-FI自动播放
  @StorageLink('wifi_auto_play') wifiAutoPlay: boolean = false;
  // 3G/4G/5G自动播放
  @StorageLink('cellular_auto_play') cellularAutoPlay: boolean = false;

  aboutToAppear(): void {
    emitter.on({ eventId: 6 }, () => {
      this.navPathStack.pop();
    });
  }

  build() {
    Column() {
      Text($r('app.string.network_status_observer_auto_play_setting'))
        .fontSize($r('app.integer.network_status_observer_setting_title_font_size'))
        .fontColor(Color.Grey)

      Row() {
        Text($r('app.string.network_status_observer_cellular_auto_play'))
          .width($r('app.string.network_status_observer_percent_90'))
        Toggle({ type: ToggleType.Switch, isOn: this.cellularAutoPlay })
          .selectedColor($r('app.color.network_status_observer_setting_toggle_selected'))
          .switchPointColor(Color.White)
          .onChange((isOn: boolean) => {
            logger.info('Component status:' + isOn);
            AppStorage.setOrCreate('cellular_auto_play', isOn);
            PersistentStorage.persistProp('cellular_auto_play', isOn);
          })
          .width($r('app.string.network_status_observer_percent_10'))
          .id('id_network_status_observer_cellular_toggle')
      }.margin({
        top: $r('app.integer.network_status_observer_setting_toggle_margin_top')
      })
      .width($r('app.string.network_status_observer_percent_100'))

      Row() {
        Text($r('app.string.network_status_observer_wifi_auto_play'))
          .width($r('app.string.network_status_observer_percent_90'))
        Toggle({ type: ToggleType.Switch, isOn: this.wifiAutoPlay })
          .selectedColor($r('app.color.network_status_observer_setting_toggle_selected'))
          .switchPointColor(Color.White)
          .onChange((isOn: boolean) => {
            logger.info('Component status:' + isOn);
            AppStorage.setOrCreate('wifi_auto_play', isOn);
            PersistentStorage.persistProp('wifi_auto_play', isOn);
          })
          .width($r('app.string.network_status_observer_percent_10'))
          .id('id_network_status_observer_wifi_toggle')
      }
      .margin({
        top: $r('app.integer.network_status_observer_setting_toggle_margin_top')
      })
      .width($r('app.string.network_status_observer_percent_100'))
    }
    .alignItems(HorizontalAlign.Start)
    .width($r('app.string.network_status_observer_percent_100'))
    .height($r('app.string.network_status_observer_percent_100'))
    .padding({
      left: $r('app.integer.network_status_observer_setting_padding'),
      right: $r('app.integer.network_status_observer_setting_padding'),
      top: $r('app.integer.network_status_observer_setting_padding_top')
    })
  }
}