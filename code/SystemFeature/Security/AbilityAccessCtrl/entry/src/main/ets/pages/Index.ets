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

import promptAction from '@ohos.promptAction'
import bundleManager from '@ohos.bundle.bundleManager'
import Logger from '../model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import common from '@ohos.app.ability.common'
import { requestModel } from '@ohos/requestModel'

const TAG: string = '[Index]'
const PERMISSION = 'ohos.permission.MICROPHONE'
const BUNDLE_NAME = 'ohos.samples.abilityaccessctrl'

@Entry
@Component
struct Index {
  private request?: requestModel
  private atManager: abilityAccessCtrl.AtManager = undefined
  aboutToAppear() {
    this.request = new requestModel([PERMISSION])
    this.request.requestPermission('ohos.samples.abilityaccessctrl', getContext(this) as common.UIAbilityContext)
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.button'))
          .key('checkPermission')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let bundleFlag = 0 // 返回的应用信息对象中包含信息的标记,默认值：0
            bundleManager.getApplicationInfo(BUNDLE_NAME, bundleFlag).then((data) => {
              let appInfo = data
              let tokenID = appInfo.accessTokenId
              Logger.info(TAG, `test grantUserGrantedPermission = ${JSON.stringify(data)}`)
              this.atManager = abilityAccessCtrl.createAtManager()
              let grantStatus = this.atManager.verifyAccessTokenSync(tokenID, PERMISSION)
              if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
                promptAction.showToast({ message: $r('app.string.authorization') })
              } else {
                promptAction.showToast({ message: $r('app.string.unauthorization') })
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}