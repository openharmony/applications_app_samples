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
import ParticleAbilityTest from '../feature/ParticleAbilityHelper'

@Entry
@Component
struct ParticlePage {
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
        Text($r('app.string.particle_page'))
          .fontColor(Color.Black)
          .fontSize(30)
          .fontWeight(500)
          .layoutWeight(1)
      }
      .width('100%')
      .height('8%')

      Column() {
        this.ButtonStyle($r('app.string.start_ability'), ParticleAbilityTest.startAbility)
        this.ButtonStyle($r('app.string.connect_ability'), ParticleAbilityTest.connectAbility)
        this.ButtonStyle($r('app.string.disconnect_ability'), ParticleAbilityTest.disconnectAbility)
        this.ButtonStyle($r('app.string.acquire_data_ability_helper'), ParticleAbilityTest.acquireDataAbilityHelper)
        this.ButtonStyle($r('app.string.terminate_self'), ParticleAbilityTest.terminateSelf)
      }
      .width('100%')
    }
    .height('100%')
  }

  @Builder ButtonStyle(textStr: Resource, click) {
    Button(textStr)
      .width('60%')
      .margin({ top: 30 })
      .onClick(click)
  }
}
