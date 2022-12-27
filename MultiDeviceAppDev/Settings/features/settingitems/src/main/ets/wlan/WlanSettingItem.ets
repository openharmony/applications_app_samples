/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { MainItem } from '../components/MainItem'
import { WlanMoreSettingItem } from './WlanMoreSetting'
import { SubItemToggle } from '../components/SubItemToggle'
import { SubItemWifi } from '../components/SubItemWifi'
import { ItemGroup } from '../components/ItemGroup'
import { ItemDescription } from '../components/ItemDescription'

@Component
export struct WlanSettingItem {
  @State itemTitle: string = ''
  @LocalStorageLink('selectedLabel') selectedLabel: string  = ''

  aboutToAppear() {
    this.itemTitle = getContext().resourceManager.getStringSync($r('app.string.wifiTab').id)
  }

  build() {
    Column() {
      NavRouter() {
        MainItem({
          title: $r('app.string.wifiTab'),
          tag: 'UX',
          icon: $r('app.media.wlan'),
          label: 'WLAN'
        })

        NavDestination() {
          WlanSetting()
        }
        .title(this.itemTitle)
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      }.onStateChange((isActivated: boolean) => {
        if (isActivated) {
          this.selectedLabel = 'WLAN'
        }
      })
    }
  }
}

@Component
struct WlanSetting {
  @Builder CustomDivider() {
    Divider()
      .strokeWidth('1px')
      .color($r('sys.color.ohos_id_color_list_separator'))
      .margin({left: 12, right: 8})
  }

  build() {
    Column() {
      Column() {
        ItemGroup() {
          SubItemToggle({title: $r('app.string.wifiTab'), isOn: true})
        }

        Row().height(16)

        ItemGroup() {
          WlanMoreSettingItem()
        }
      }
      .margin({bottom: 19.5})
      .flexShrink(0)

      Scroll() {
        Column() {
          ItemDescription({description: $r('app.string.wifiTipConnectedWLAN')})
            .padding({
              left: 12,
              right: 12,
              bottom: 9.5
            })

          ItemGroup() {
            SubItemWifi({
              title: 'UX',
              subTitle: $r('app.string.wifiSummaryConnected'),
              isConnected: true,
              icon: $r('app.media.ic_wifi_signal_4_dark')
            })
          }

          Column() {
            ItemDescription({description: $r('app.string.wifiTipValidWLAN')})
              .margin({
                left: 12,
                right: 12,
                top: 19.5,
                bottom: 9.5
              })

            ItemGroup() {
              SubItemWifi({
                title: 'Huwe-yee',
                subTitle: $r('app.string.wifiSummaryEncrypted'),
                isConnected: false,
                icon: $r('app.media.ic_wifi_lock_signal_4_dark')
              })

              this.CustomDivider()

              SubItemWifi({
                title: 'UX-5G',
                subTitle: $r('app.string.wifiSummaryOpen'),
                isConnected: false,
                icon: $r('app.media.ic_wifi_signal_4_dark')
              })

              this.CustomDivider()

              SubItemWifi({
                title: 'E1-AP',
                subTitle: $r('app.string.wifiSummarySaveOpen'),
                isConnected: false,
                icon: $r('app.media.ic_wifi_signal_4_dark')
              })
            }
          }
        }
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
      .flexShrink(1)
    }
    .width('100%')
    .height('100%')
    .padding({left: 12, right: 12})
  }
}
