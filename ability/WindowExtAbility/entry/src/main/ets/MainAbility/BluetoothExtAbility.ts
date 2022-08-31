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

import WindowExtensionAbility from '@ohos.application.WindowExtensionAbility'
import Logger from '../feature/Logger'
import Rpc from '../feature/Rpc'

const TAG: string = 'BlueToothExtAbility'

export default class BluetoothExtAbility extends WindowExtensionAbility {
  onWindowReady(window) {
    window.loadContent('pages/Bluetooth').then(() => {
      window.getProperties().then((pro) => {
        Logger.info(TAG, `BlueTooth WindowExtension ${JSON.parse(pro)}`)
      })
      window.show()
    })
  }

  onConnect(want) {
    Logger.info(TAG, `BlueTooth WindowExtAbility onConnect ${want.abilityName}`)
    return Rpc
  }

  onDisconnect(want) {
    Logger.info(TAG, `BlueTooth WindowExtAbility onDisconnect ${want.abilityName}`)
  }
}