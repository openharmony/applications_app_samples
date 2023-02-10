/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import FeatureAbilityHelper from '../feature/FeatureAbilityHelper'
import { BUNDLE_NAME, SERVICE_ABILITY_NAME } from '../model/DaHelperConst'

@Entry
@Component
struct ServicePage {
  private isConnectService: boolean = false
  private StartAbilityParameter = {
    want: {
      bundleName: BUNDLE_NAME,
      abilityName: SERVICE_ABILITY_NAME,
      parameters: {
        'service': null
      }
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(32)
          .height(32)
          .margin({ left: 32, right: 32 })
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.service_title'))
          .fontColor(Color.Black)
          .fontSize(30)
          .fontWeight(500)
          .layoutWeight(1)
      }
      .width('100%')
      .height('8%')

      Column() {
        Button($r('app.string.start_service'))
          .width('60%')
          .margin({ top: 30 })
          .onClick(() => {
            this.StartAbilityParameter.want.parameters.service = 'start service success'
            FeatureAbilityHelper.startServiceAbility(this.StartAbilityParameter)
          })
        Button($r('app.string.connect_service'))
          .width('60%')
          .margin({ top: 30 })
          .onClick(() => {
            if (!this.isConnectService) {
              FeatureAbilityHelper.connectService()
              this.isConnectService = true
            }
          })
        Button($r('app.string.disconnect_service'))
          .width('60%')
          .margin({ top: 30 })
          .onClick(() => {
            if (this.isConnectService) {
              FeatureAbilityHelper.disconnectService()
              this.isConnectService = false
            }
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}