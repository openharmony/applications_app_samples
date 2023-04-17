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

import bundleManager from '@ohos.bundle.bundleManager'
import Logger from '../model/Logger'
import abilityAccessCtrl,{Permissions} from '@ohos.abilityAccessCtrl'
import common from '@ohos.app.ability.common'

const TAG: string = '[requestPermission]'
const BUNDLE_NAME: string = 'ohos.samples.abilityaccessctrl'

export class requestModel {
  private permissions: Array<Permissions> = []

  constructor(permissions: Array<Permissions>) {
    this.permissions = permissions
  }

  async requestPermission(bundleName: string, ctx: common.UIAbilityContext) {
    Logger.info('requestPermission start')
    let bundleFlag = 0
    let appInfo = await bundleManager.getApplicationInfo(bundleName, bundleFlag)
    let tokenID = appInfo.accessTokenId
    let atManager = abilityAccessCtrl.createAtManager()
    Logger.info(TAG, `atManager = ${JSON.stringify(atManager)}`)
    for (let i = 0; i < this.permissions.length; i++) {
      let result = atManager.verifyAccessTokenSync(tokenID, this.permissions[i])
      Logger.info(TAG, `result = ${JSON.stringify(result)}`)
      if (result === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        await ctx.startAbility({
          bundleName: BUNDLE_NAME,
          abilityName: `VerifyAbility`,
          parameters: {
            bundleName: BUNDLE_NAME,
            permissions: this.permissions[i],
            tokenID
          }
        })
      }
    }
  }
}