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

import AbilityAccessCtrlController from '../feature/AbilityAccessCtrlController'
import { PublicTitleBar } from './component/PublicTitleBar'

@Entry
@Component
struct AbilityAccessCtrlPage {
  private abilityAccessCtrl: AbilityAccessCtrlController = new AbilityAccessCtrlController()

  build() {
    Column() {
      PublicTitleBar({ textName: $r('app.string.ability_access_ctrl_page') })
      Column() {
        Button($r('app.string.verify_access_token'))
          .fancy(() => {
            this.abilityAccessCtrl.verifyAccessToken()
          })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })
  }
}

@Extend(Button) function fancy (click) {
  .width('60%')
  .height(40)
  .align(Alignment.Center)
  .margin({ top: 30 })
  .onClick(click)
}