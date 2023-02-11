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
import { SubItemArrow } from '../components/SubItemArrow'
import { Nfc } from './Nfc'
import { ItemGroup } from '../components/ItemGroup'

@Component
export struct MoreConnectionsItem {
  @State itemTitle: string = ''
  @LocalStorageLink('selectedLabel') selectedLabel: string  = ''

  aboutToAppear() {
    this.itemTitle = getContext().resourceManager.getStringSync($r('app.string.moreConnectionsTab').id)
  }

  build() {
    Column() {
      NavRouter() {
        MainItem({
          title: $r("app.string.moreConnectionsTab"),
          icon: $r('app.media.ic_settings_more_connections'),
          label: 'MORE_CONNECTIONS'
        })
        NavDestination() {
          MoreConnections()
        }
        .title(this.itemTitle)
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      }.onStateChange((isActivated: boolean) => {
        if (isActivated) {
          this.selectedLabel = 'MORE_CONNECTIONS'
        }
      })
    }
  }
}

@Component
export struct MoreConnections {
  @State itemTitle: string = ''
  @LocalStorageLink('selectedLabel') selectedLabel: string  = ''

  aboutToAppear() {
    this.itemTitle = getContext().resourceManager.getStringSync($r('app.string.NFC').id)
  }

  build() {
    Column() {
      ItemGroup() {
        NavRouter() {
          SubItemArrow({
            title: $r('app.string.NFC'),
            tag: $r('app.string.disabled')
          })

          NavDestination() {
            Nfc()
          }.title(this.itemTitle)
          .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        }.onStateChange((isActivated: boolean) => {
          if (isActivated) {
            this.selectedLabel = 'MORE_CONNECTIONS'
          }
        })
      }
    }.padding({left: 12, right: 12})
  }
}