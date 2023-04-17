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

import prompt from '@ohos.prompt'
import Logger from '../util/Logger'

const TAG: string = 'FormExtContextController'

let want = {
  moduleName: 'entry',
  bundleName: 'ohos.samples.stagemodel',
  abilityName: 'FormAbility',
}

export default class FormExtContextController {
  private regOnRelease(caller) {
    try {
      caller.onRelease((msg) => {
        Logger.info(TAG, `caller onRelease is called ${msg}`)
      })
      Logger.info(TAG, 'caller register OnRelease succeed')
    } catch (error) {
      Logger.error(TAG, `caller register OnRelease failed with ${error}`)
    }
  }

  // 拉起一个卡片所属应用的Ability。
  startAbility(context) {
    context.startAbility(want).then(() => {
      Logger.info(TAG, `StartAbility Success`)
      prompt.showToast({
        message: 'FormExtensionContext success'
      })
    }).catch((error) => {
      Logger.error(TAG, `StartAbility failed: ${error}`)
      prompt.showToast({
        message: `StartAbility failed: ${error}`
      })
    })
  }
}