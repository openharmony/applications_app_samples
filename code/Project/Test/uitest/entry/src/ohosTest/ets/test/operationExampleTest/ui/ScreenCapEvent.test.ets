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

import { describe, it, expect, TestType, Level, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
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
export default function ScreenCapEventTest() {
  describe('ScreenCapEvent', () => {

    /**
     * @tc.number:ScreenCapEventTest_001
     * @tc.name: testScreenCap
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest screenCap 功能
     */
    it('testScreenCap', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let savePath = '/data/storage/el2/base/cache/1.png';
      let success = await driver.screenCap(savePath);
      expect(success === true).assertTrue();
      done();
    })

    /**
     * @tc.number:ScreenCapEventTest_001
     * @tc.name: testScreenCap
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest screenCapture 指定大小截图功能
     */
    it('testScreenCap_1', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let savePath = '/data/storage/el2/base/cache/2.png';
      let success = await driver.screenCapture(savePath, {left: 0, top: 0, right: 100, bottom: 100});
      expect(success === true).assertTrue();
      done();
    })

    /**
     * @tc.name: testScreenCapWithId
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测多屏下 uitest screenCapture 指定大小截图功能,
     */
    it('testScreenCapWithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let disPlay = display.getDefaultDisplaySync();
      await driver.delayMs(waitUiReadyMs)
      let savePath = '/data/storage/el2/base/cache/1.png'
      let success = await driver.screenCap(savePath, disPlay.id)
      expect(success == true).assertTrue()
    })
  })
}