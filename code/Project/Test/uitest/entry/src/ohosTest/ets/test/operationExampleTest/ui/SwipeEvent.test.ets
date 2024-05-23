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
import { Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;

export default function SwipeEventTest() {
  describe('SwipeEvent', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'SwipeAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:SwipeEventTest_001
     * @tc.name: testSwipe_h
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测 uitest swipe 水平滑到功能 坐标点仅支持RK3568
     */
    it('testSwipe_h', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let swiper = await driver.findComponent(ON.id('swiper'));
      let point = await swiper.getBounds();
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.swipe(point.left, 300, point.right, 300);
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.swipe(point.left, 300, point.right, 300);
      await driver.delayMs(WAIT_UI_READYMS);
      let text = await driver.findComponent(ON.id('swiper_text'));
      expect(await text.getText()).assertEqual('arkUI');
      done();
    })

    /**
     * @tc.number:SwipeEventTest_002
     * @tc.name: testSwipe_h
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测 uitest swipe 竖着滑到功能 坐标点仅支持RK3568
     */
    it('testSwipe_v', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let textZero = await driver.findComponent(ON.id('scroll_item_0'));
      expect(await textZero.getText()).assertEqual("0");
      await driver.swipe(400, 700, 400, 300);
      await driver.delayMs(WAIT_UI_READYMS * 2);
      let textZeroNot = await driver.findComponent(ON.id('scroll_item_0')); // 滑动导致组件不可见,查找失败。
      expect(textZeroNot).assertNull();
      done();
    })
  })
}