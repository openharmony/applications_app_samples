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
import {Driver, ON, } from '@ohos.UiTest'

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const waitUiReadyMs = 1000;

export default function SwipeEventTest() {
  describe('SwipeEvent', function () {
    beforeAll(async function () {
      let want = {
        bundleName : bundleName,
        abilityName : "SwipeAbility"
      }
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:SwipeEventTest_001
     * @tc.name: testSwipe_h
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测 uitest swipe 水平滑到功能
     */
    it('testSwipe_h', TestType.FUNCTION, async function () {
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      await driver.swipe(400, 300, 100, 300)
      await driver.delayMs(waitUiReadyMs)
      await driver.swipe(400, 300, 100, 300)
      await driver.delayMs(waitUiReadyMs)
      let text = await driver.findComponent(ON.id('swiper_text'))
      expect(await text.getText()).assertEqual("arkUI")
    })

    /**
     * @tc.number:SwipeEventTest_002
     * @tc.name: testSwipe_h
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测 uitest swipe 竖着滑到功能
     */
    it('testSwipe_v', TestType.FUNCTION, async function () {
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      await driver.swipe(400, 700, 400, 500)
      await driver.delayMs(waitUiReadyMs)
      let text = await driver.findComponent(ON.id('scroll_item'))
      expect(await text.getText()).not().assertEqual("0")
    })
  })
}