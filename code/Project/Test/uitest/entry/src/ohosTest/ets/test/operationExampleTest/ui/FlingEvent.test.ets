/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { describe, it, expect, TestType, beforeAll, Level, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, UiDirection } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import display from '@ohos.display';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const delegator : AbilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName : string = abilityDelegatorRegistry.getArguments().bundleName;
const waitUiReadyMs : number = 1000;
const WAIT_UI_READYMS = 1000;

async function startAbility(bundleName: string, abilityName: string) {
  await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`);
}

export default function FlingEventTest() {
  describe('FlingEvent', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'FlingAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:FlingEventTest_001
     * @tc.name: FlingEvent_h
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest fling水平抛滑功能坐标点仅支持RK3568
     */
    it('FlingEvent_h', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let swiper = await driver.findComponent(ON.id('swiper'));
      let point = await swiper.getBounds();
      await driver.fling({x: point.left, y:300},{x:point.right, y:300}, 20, 600);
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.fling({x: point.left, y:300},{x:point.right, y:300}, 20, 600);
      await driver.delayMs(WAIT_UI_READYMS);
      let text = await driver.findComponent(ON.id('swiper_text'));
      expect(await text.getText()).assertEqual('arkUI');
      done();
    })

    /**
     * @tc.number:FlingEventTest_002
     * @tc.name: FlingEvent_v
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest fling 竖直抛滑功能坐标点仅支持RK3568
     */
    it('FlingEvent_v', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.fling({x:400, y:700},{x:400, y:200}, 20, 600 );
      await driver.delayMs(WAIT_UI_READYMS);
      let text = await driver.findComponent(ON.id('scroll_item'));
      expect(await text.getText()).not().assertEqual('0');
      done();
    })

    /**
     * @tc.number:FlingEventTest_003
     * @tc.name: FlingEvent_d
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest fling 垂直滑动功能 坐标点仅支持RK3568
     */
    it('FlingEvent_d', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.fling(UiDirection.LEFT, 39000);
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.fling(UiDirection.RIGHT, 39000);
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.fling(UiDirection.DOWN, 39000);
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.fling(UiDirection.UP, 39000);
      let text = await driver.findComponent(ON.text('next page'));
      expect(text !== null).assertTrue();
      done();
    })

    /**
     * @tc.name: FlingEvent_WithId
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest fling 垂直滑动功能 坐标点仅支持RK3568
     */
    it('FlingEvent_WithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let disPlay = display.getDefaultDisplaySync();
      if (disPlay.id == 999) {
        return
      }
      let window = await driver.findWindow({bundleName: bundleName})
      try {
        await window.maximize()
        await driver.delayMs(500)
      } catch (error) {
      }
      await driver.fling(UiDirection.DOWN, 39000, disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      let button = await driver.findComponents(ON.belongingDisplay(disPlay.id).text('next page'))
      expect (button).assertNull()
      await driver.fling(UiDirection.LEFT, 39000, disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      let text = await driver.findComponents(ON.belongingDisplay(disPlay.id).text('1'))
      expect (text).assertNull()
      await driver.fling(UiDirection.RIGHT, 39000, disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      let text2 = await driver.findComponents(ON.belongingDisplay(disPlay.id).text('1'))
      expect (text2).assertNull()
      await driver.fling(UiDirection.UP, 39000, disPlay.id)
      await driver.delayMs(2000)
      let button2 = await driver.findComponents(ON.belongingDisplay(disPlay.id).text('bottom'))
      expect (button2 == null).assertTrue()
    })
  })
}