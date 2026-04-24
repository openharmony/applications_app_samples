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

import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_AppAccountManager]'
const DOMAIN = 0xF811
const BUNDLE = 'AppAccountManager_'
const APP_BUNDLE_NAME = 'com.example.myapplication.myapplication'
const APP_ABILITY_NAME = 'EntryAbility'

let driver: Driver = Driver.create()
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

async function startEntryAbility() {
  await abilityDelegator.startAbility({
    bundleName: APP_BUNDLE_NAME,
    abilityName: APP_ABILITY_NAME
  })
  await driver.delayMs(1200)
}

async function hasComponentById(id: string): Promise<boolean> {
  try {
    await driver.assertComponentExist(ON.id(id))
    return true
  } catch (err) {
    return false
  }
}

async function clickComponentByIdIfExists(id: string): Promise<boolean> {
  if (!(await hasComponentById(id))) {
    return false
  }
  let component = await driver.findComponent(ON.id(id))
  await component.click()
  await driver.delayMs(800)
  return true
}

async function enterBundleAndCheckLogin(bundleId: string) {
  await startEntryAbility()
  await clickComponentByIdIfExists(bundleId)
  if (!(await hasComponentById('nameInput'))) {
    await clickComponentByIdIfExists(bundleId)
  }
  expect(await hasComponentById('nameInput')).assertTrue()
  expect(await hasComponentById('passwordInput')).assertTrue()
  expect(await hasComponentById('register')).assertTrue()
  expect(await hasComponentById('login')).assertTrue()
}

export default function appTest() {
  describe('appTest', () => {
    it(BUNDLE + 'StartAbility_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      await startEntryAbility()
      expect(await hasComponentById('MusicApp')).assertTrue()
      expect(await hasComponentById('VideoApp')).assertTrue()
      expect(await hasComponentById('MapApp')).assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    it(BUNDLE + 'ClickMusicFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMusicFunction_001 begin')
      await enterBundleAndCheckLogin('MusicApp')
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMusicFunction_001 end')
    })

    it(BUNDLE + 'ClickVideoFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickVideoFunction_001 begin')
      await enterBundleAndCheckLogin('VideoApp')
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickVideoFunction_001 end')
    })

    it(BUNDLE + 'ClickMapFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMapFunction_001 begin')
      await enterBundleAndCheckLogin('MapApp')
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMapFunction_001 end')
    })

    it(BUNDLE + 'ModifyInfoFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ModifyInfoFunction_001 begin')
      await startEntryAbility()
      await clickComponentByIdIfExists('MusicApp')
      if (!(await hasComponentById('register'))) {
        await clickComponentByIdIfExists('MusicApp')
      }
      expect(await hasComponentById('register')).assertTrue()
      expect(await hasComponentById('login')).assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ModifyInfoFunction_001 end')
    })
  })
}
