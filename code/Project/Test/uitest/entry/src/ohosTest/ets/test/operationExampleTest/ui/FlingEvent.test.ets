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

export default function FlingEventTest() {
  describe('FlingEvent', function () {
    beforeAll(async function () {
      let want = {
        bundleName : bundleName,
        abilityName : "FlingAbility"
      }
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:FlingEventTest_001
     * @tc.name: FlingEvent_h
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest fling 功能
     */
    it('FlingEvent_h', TestType.FUNCTION, async function (done) {
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      await driver.fling({x:400, y:300},{x:100, y:300}, 20, 600)
      await driver.delayMs(waitUiReadyMs)
      await driver.fling({x:400, y:300},{x:100, y:300}, 20, 600)
      await driver.delayMs(waitUiReadyMs)
      let text = await driver.findComponent(ON.id('swiper_text'))
      expect(await text.getText()).assertEqual("arkUI")
      done()
    })

    /**
     * @tc.number:FlingEventTest_002
     * @tc.name: FlingEvent_v
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest fling 功能
     */
    it('FlingEvent_v', TestType.FUNCTION, async function (done) {
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      await driver.fling({x:400, y:700},{x:400, y:500}, 20, 600 )
      await driver.delayMs(waitUiReadyMs)
      let text = await driver.findComponent(ON.id('scroll_item'))
      expect(await text.getText()).not().assertEqual("0")
      done()
    })
  })
}