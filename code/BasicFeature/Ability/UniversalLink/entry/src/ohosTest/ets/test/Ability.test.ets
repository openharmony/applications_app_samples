/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, it, expect } from '@ohos/hypium';

const TAG = '[Sample_UniversalLink]';
const DOMAIN = 0xF811;
const BUNDLE = 'UniversalLink_';
const TIME = 1500;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.universallink',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility end');
    })

    /**
     * @tc.number     : UniversalLink_001
     * @tc.name       : UniversalLink_001
     * @tc.desc       : Test the interface in AbilityStartCallback
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('UniversalLink_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UniversalLink_001 begin');

      let driver = await Driver.create();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('openLinkPromise'));
      let openLinkPromise = await driver.findComponent(ON.id('openLinkPromise'));
      await openLinkPromise.click();
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('openLinkCallback'));
      let openLinkCallback = await driver.findComponent(ON.id('openLinkCallback'));
      await openLinkCallback.click();
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'UniversalLink_001 end');
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      done()
    })
  })
}