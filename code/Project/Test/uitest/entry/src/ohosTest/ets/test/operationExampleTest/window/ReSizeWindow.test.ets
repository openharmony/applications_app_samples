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
import { Driver, ResizeDirection} from '@ohos.UiTest'
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;

export default function ReSizeWindow() {
  describe('ReSizeWindow', function () {
    beforeAll(async function () {
      let want = {
        bundleName : bundleName,
        abilityName : "EntryAbility"
      }
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:ReSizeWindow_001
     * @tc.name: testWindowResizeA
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 设置window指定的大小与方向测试
     */
    it('testWindowResizeA', TestType.FUNCTION, async function (done) {
      let driver = Driver.create()
      await driver.delayMs(WAIT_UI_READYMS)
      let window = await driver.findWindow({bundleName:bundleName})
      try{
        await window.resume()
        await driver.delayMs(WAIT_UI_READYMS)

        let window1 = await driver.findWindow({bundleName:bundleName})
        let bounds1 = await window1.getBounds()
        await window1.resize(600,600,ResizeDirection.RIGHT_DOWN)
        await driver.delayMs(WAIT_UI_READYMS)
        let window2 = await driver.findWindow({bundleName:bundleName})
        let bounds2 = await window2.getBounds()
        expect(bounds2 != bounds1).assertTrue()

        await window2.resize(400,400,ResizeDirection.RIGHT_UP)
        let window3 = await driver.findWindow({bundleName:bundleName})
        let bounds3= await window3.getBounds()
        expect(bounds3 != bounds2).assertTrue()
        await window3.resize(300,300,ResizeDirection.LEFT_DOWN)
        let window4 = await driver.findWindow({bundleName:bundleName})
        let bounds4= await window4.getBounds()
        expect(bounds4 != bounds3).assertTrue()

        await window4.resize(500,500,ResizeDirection.LEFT_UP)
        let window5 = await driver.findWindow({bundleName:bundleName})
        let bounds5= await window5.getBounds()
        expect(bounds5 != bounds4).assertTrue()
      }
      catch (err) {
        if (err.message == 'this device can not support this action') {
          expect(window != null).assertTrue()
        } else {
          expect(false).assertTrue()
        }
      } finally {
        done()
      }
    })
  })
}