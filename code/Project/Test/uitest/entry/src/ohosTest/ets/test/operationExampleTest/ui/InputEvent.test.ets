/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, beforeAll, it, expect, TestType } from '@ohos/hypium'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON} from '@ohos.UiTest'
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const waitUiReadyMs = 1000;
const test ="测试内容";

export default function InputEventTest() {
  describe('InputEventTest', function () {
      beforeAll(async function () {
        let want = {
          bundleName : bundleName,
          abilityName : "InputAbility"
        }
        await delegator.startAbility(want);
    })

    /**
     * @tc.number:InputEventTest_001
     * @tc.name: clickEventTest_Input
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest inputText 功能
     */
    it('clickEventTest_Input',TestType.FUNCTION, async function (done) {
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let input = await driver.findComponent(ON.type('TextInput'))
      await input.inputText('123')
      await driver.delayMs(waitUiReadyMs)
      let input_new = await driver.findComponent(ON.type('TextInput'))
      let text = await input_new.getText()
      expect(text == '123').assertTrue()
      done()
    })

    /**
     * @tc.number:InputEventTest_002
    * @tc.name: clickEventTest_Input_zh
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest inputText 输入中文功能测试
     */
    it('clickEventTest_Input_zh',TestType.FUNCTION, async function (done) {
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let input = await driver.findComponent(ON.type('TextInput'))
      await input.inputText(test)
      await driver.delayMs(waitUiReadyMs)
      let input_new = await driver.findComponent(ON.type('TextInput'))
      let text = await input_new.getText()
      expect(text == test).assertTrue()
      done()
    })
  })
}