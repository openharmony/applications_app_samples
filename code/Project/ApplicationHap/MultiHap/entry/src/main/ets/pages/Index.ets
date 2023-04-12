/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'

const TAG: string = 'Index'
const AUDIO: string = 'audio'
const VIDEO: string = 'video'
const BUNDLE_NAME: string = 'com.samples.multihap'
const AUDIO_ABILITY_NAME: string = "AudioAbility"
const VIDEO_ABILITY_NAME: string = "VideoAbility"

@Entry
@Component
struct Index {
  private context: common.UIAbilityContext = null

  build() {
    Row() {
      Column() {
        Button(AUDIO)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.context.startAbility({
              bundleName: BUNDLE_NAME,
              abilityName: AUDIO_ABILITY_NAME
            }).then(() => {
              Logger.info(TAG, 'start audio ability success')
            }).catch((error) => {
              Logger.error(TAG, 'start audio ability failed, error: ' + JSON.stringify(error))
            })
          })
          .margin({bottom: 20})
        Button(VIDEO)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.context.startAbility({
              bundleName: BUNDLE_NAME,
              abilityName: VIDEO_ABILITY_NAME
            }).then(() => {
              Logger.info(TAG, 'start video ability success')
            }).catch((error) => {
              Logger.error(TAG, 'start video ability failed, error: ' + JSON.stringify(error))
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext
  }
}