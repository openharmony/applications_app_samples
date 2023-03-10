/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common'
import prompt from '@ohos.promptAction'
import Logger from '../model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import type { Permissions } from '@ohos.abilityAccessCtrl'

const TAG: string = 'AbilityContextController'
const PERMISSIONS: Array<Permissions> = ['ohos.permission.GET_BUNDLE_INFO_PRIVILEGED']


export default class AbilityContextController {
  private context: common.UIAbilityContext

  constructor(context) {
    this.context = context
  }

  requestPermissionsFromUser() {
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(this.context, PERMISSIONS).then((data) => {
        Logger.info(TAG, `requestPermissionsFromUser: ${JSON.stringify(data)}`)
        prompt.showToast({
          message: 'requestPermissionsFromUser success'
        })
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`)
    }
  }
}
