/**
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import { SubItemArrow } from '../components/SubItemArrow'
import { SubItemToggle } from '../components/SubItemToggle'
import { ItemGroup } from '../components/ItemGroup'
import { ItemDescription } from '../components/ItemDescription'

@Component
export struct WlanMoreSettingItem {
  @State itemTitle: string = ''
  @LocalStorageLink('selectedLabel') selectedLabel: string = ''

  aboutToAppear() {
    this.itemTitle = getContext().resourceManager.getStringSync($r('app.string.moreWlanSettings').id)
  }

  build() {
    NavRouter() {
      SubItemArrow({ title: $r('app.string.moreWlanSettings') })

      NavDestination() {
        WlanMoreSetting()
      }
      .title(this.itemTitle)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    }
    .onStateChange((isActivated: boolean) => {
      if (isActivated) {
        this.selectedLabel = 'WLAN'
      }
    })
  }
}

@Component
export struct WlanMoreSetting {
  build() {
    Scroll() {
      Column() {
        ItemGroup() {
          SubItemArrow({
            title: $r('app.string.wlanPlus'),
            tag: $r('app.string.enabled')
          })
        }

        ItemDescription({description: $r('app.string.wlanPlusTip')})
          .margin({
            top: 8,
            bottom: 24,
            left: 12,
            right: 12
          })

        ItemGroup() {
          SubItemArrow({ title: $r('app.string.wlanDirect') })
        }

        Blank().height(12)

        ItemGroup() {
          SubItemToggle({title: $r('app.string.wlanSecurityCheck')})
        }

        ItemDescription({description: $r('app.string.wlanSecurityCheckTip')})
          .margin({
            top: 8,
            bottom: 24,
            left: 12,
            right: 12
          })

        ItemGroup() {
          SubItemArrow({title: $r('app.string.savedWlan')})
          Divider()
            .strokeWidth('1px')
            .color($r('sys.color.ohos_id_color_list_separator'))
            .margin({left: 12, right: 8})
          SubItemArrow({title: $r('app.string.installCertificates')})
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({left: 12, right: 12})
    }
    .scrollBar(BarState.Off)
    .width('100%')
  }
}
