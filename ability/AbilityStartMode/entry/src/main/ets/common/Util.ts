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

import Logger from './Logger'

const TAG = '[Sample_StartMode]'
let contextCaller, want

interface EventHub {
  emit(event: string, ...args: Object[]): void
}

interface AbilityContext {
  eventHub: EventHub
}

export function getContextData(): any {
  Logger.info(TAG, 'UtilPage getContextData start')
  let context = getContext(this) as AbilityContext
  let data = {
    context: null,
    launchWant: null
  }
  context.eventHub.emit("getAbilityData", data)
  contextCaller = data.context // 拿到全局的context，即类似globalThis.mainAbilityContext
  want = data.launchWant
  Logger.info(TAG, 'UtilPage contextCaller ' + JSON.stringify(contextCaller))
  return { 'want': want }
}

export function startMode(wantParameters: any, abilityName: string) {
  Logger.info(TAG, `${abilityName} start`)
  getContextData()
  let want = {
    bundleName: 'ohos.samples.startmode',
    abilityName: abilityName,
    parameters: wantParameters
  }

  Logger.info(TAG, `${abilityName} contextCaller ${JSON.stringify(contextCaller)}`)
  contextCaller.startAbility(want).catch(err => {
    Logger.info(TAG, 'err is' + JSON.stringify(err))
  })
  Logger.info(TAG, `${abilityName} end`)
}

export function totast() {
  AlertDialog.show(
    {
      message: $r('app.string.totast'),
      secondaryButton: {
        value: 'ok',
        action: () => {
          Logger.info(TAG, 'Callback when the second button is clicked')
        }
      }
    }
  )
}