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

import { PublicTitleBar } from './component/PublicTitleBar'
import ServiceExContextController from '../feature/ServiceExtContextController'

@Entry
@Component
struct ServiceExContextPage {
  private serviceExContext: ServiceExContextController = undefined

  build() {
    Column() {
      PublicTitleBar({ textName: $r("app.string.service_extension_contextPage") })
      Scroll() {
        Column() {
          Button($r("app.string.start_ability"))
            .fancy(() => {
              this.serviceExContext.startAbility()
            })
          Button($r("app.string.start_service_extension_ability"))
            .fancy(() => {
              this.serviceExContext.startServiceExtensionAbility()
            })
          Button($r("app.string.start_service_extension_ability_with_account"))
            .fancy(() => {
              this.serviceExContext.startServiceExtensionAbilityWithAccount()
            })
          Button($r("app.string.stop_service_extension_ability"))
            .fancy(() => {
              this.serviceExContext.stopServiceExtensionAbility()
            })
          Button($r("app.string.stop_service_extension_ability_with_account"))
            .fancy(() => {
              this.serviceExContext.stopServiceExtensionAbilityWithAccount()
            })
          Button($r("app.string.terminate_self"))
            .fancy(() => {
              this.serviceExContext.terminateSelf()
            })
          Button($r("app.string.connect_ability"))
            .fancy(() => {
              this.serviceExContext.connectAbility()
            })
          Button($r("app.string.connect_ability_with_account"))
            .fancy(() => {
              this.serviceExContext.connectAbilityWithAccount()
            })
          Button($r("app.string.disconnect_ability"))
            .fancy(() => {
              this.serviceExContext.disconnectAbility()
            })
          Button($r("app.string.start_ability_with_account"))
            .fancy(() => {
              this.serviceExContext.startAbilityWithAccount()
            })
          Button($r("app.string.start_ability_by_call"))
            .fancy(() => {
              this.serviceExContext.startAbilityByCall()
            })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })
  }

  aboutToAppear() {
    let context = getContext(this)
    this.serviceExContext = new ServiceExContextController(context)
  }
}

@Extend(Button) function fancy (click) {
  .width('60%')
  .height(40)
  .align(Alignment.Center)
  .margin({ top: 30 })
  .onClick(click)
}