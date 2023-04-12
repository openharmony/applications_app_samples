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

import Logger from '../model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

const TAG: string = '[Permission]'

export async function grantPermission() {
  Logger.info(`${TAG}, grantPermission`)
  let atManager = abilityAccessCtrl.createAtManager()
  try {
    atManager.requestPermissionsFromUser(getContext(this), ['ohos.permission.SEND_MESSAGES']).then((data) => {
      Logger.info(TAG, `data: ${JSON.stringify(data)}`)
    }).catch((err) => {
      Logger.info(TAG, `err: ${JSON.stringify(err)}`)
    })
  } catch (err) {
    Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
  }
}