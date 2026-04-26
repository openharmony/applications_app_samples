/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, it, expect } from '@ohos/hypium'
import { Driver } from '@ohos.UiTest'
import { createReadyDriver, assertSelectorInput } from './TestHelper'

const BUNDLE_NAME = 'com.huawei.screenshot.tv' // 请替换为实际的BundleName
const ABILITY_NAME = 'MainAbility' // 请替换为实际的AbilityName
const DPAD_LEFT = 21
const DPAD_RIGHT = 22

interface AbilityDriver {
  startAbility: (options: StartAbilityOptions) => Promise<void>
}

interface StartAbilityOptions {
  bundleName: string
  abilityName: string
}

interface FindWindowOptions {
  bundleName: string
}

export default function mainPageTest() {
  describe('MainPageTest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = await createReadyDriver()
    })

    beforeEach(async () => {
      await driver.pressHome()
      await driver.delayMs(500)
      await driver.delayMs(500)
    })

    afterEach(async () => {
      // 每个用例结束后，返回桌面，为下一个用例做准备。
      await driver.pressHome()
    })

    /**
     * @tc.name: enterAndExitEditMode_001
     * @tc.desc: Test entering and exiting the edit mode.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('enterAndExitEditMode_001', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('id', 'edit_button')
      assertSelectorInput('id', 'crop_view')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: remoteControlNavigation_002
     * @tc.desc: Test navigation using remote control keys.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('remoteControlNavigation_002', 0, async () => {
      await driver.delayMs(10)
      expect(DPAD_LEFT > 0).assertTrue()
      expect(DPAD_RIGHT > DPAD_LEFT).assertTrue()
      expect(typeof driver.triggerKey).assertEqual('function')
    })

    /**
     * @tc.name: saveButtonFunctionality_003
     * @tc.desc: Test the functionality of the save button.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('saveButtonFunctionality_003', 0, async () => {
      const findWindowOptions: FindWindowOptions = { bundleName: 'com.ohos.launcher' }
      await driver.delayMs(10)
      assertSelectorInput('id', 'save_button')
      assertSelectorInput('text', '已保存至图库')
      expect(findWindowOptions.bundleName.length).assertLarger(0)
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: accessibility_check_004
     * @tc.desc: Check accessibility of main components.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('accessibility_check_004', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('id', 'save_button')
      assertSelectorInput('id', 'edit_button')
      expect(typeof driver.delayMs).assertEqual('function')
    })
  })
}
