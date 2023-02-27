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

import UIAbility from '@ohos.app.ability.UIAbility'
import { Logger, QRCodeScanConst } from '@ohos/feature-qr-code-scan'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

const TAG = 'MainAbility'

export default class MainAbility extends UIAbility {
  async onCreate(want, launchParam) {
    Logger.info(TAG, 'MainAbility onCreate')
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      await atManager.requestPermissionsFromUser(this.context, ['ohos.permission.CAMERA', 'ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.MEDIA_LOCATION']).then((data) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`)
        // 如果权限列表中有-1，说明用户拒绝了授权
        if (data.authResults[0] === 0) {
          // 控制相机是否打开
          AppStorage.SetOrCreate(QRCodeScanConst.HAS_CAMERA_PERMISSION, true)
          Logger.info(TAG, 'MainAbility permissionRequestResult success')
        } else {
          Logger.info(TAG, 'MainAbility permissionRequestResult failed')
        }
        AppStorage.SetOrCreate('context', this.context)
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`)
    }
  }

  onDestroy() {
    Logger.info('MainAbility onDestroy')
  }

  onWindowStageCreate(windowStage) {
    Logger.info('MainAbility onWindowStageCreate')
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause:' + JSON.stringify(err))
        return
      }
    })
  }

  onWindowStageDestroy() {
    Logger.info('MainAbility onWindowStageDestroy')
  }

  onForeground() {
    AppStorage.SetOrCreate('cameraStatus', !AppStorage.Get('cameraStatus'))
    Logger.info('MainAbility onForeground')
  }

  onBackground() {
    Logger.info('MainAbility onBackground')
  }
}
