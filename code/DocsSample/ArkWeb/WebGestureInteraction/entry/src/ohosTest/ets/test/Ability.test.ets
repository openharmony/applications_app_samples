/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, PointerMatrix } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
const TAG = '[Sample_WebGestureInteraction]';
const DOMAIN = 0xF811;
const BUNDLE = 'WebGestureInteraction_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: ActsAbilityTest begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE, 'get top ability');
      await driver.delayMs(1000);

      done();
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(async (done: Function) => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const driver = Driver.create();
      await driver.pressBack();
      await driver.delayMs(3000);
      done();
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('processweb_DistinguishTwoGesture_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_DistinguishTwoGesture_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('DistinguishTwoGestureButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      const src = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src:' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_DistinguishTwoGesture_001 end');

      done();
    })

    it('processweb_ReturnLastWebPage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_ReturnLastWebPage_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('ReturnLastWebPageButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      const src = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src:' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_ReturnLastWebPage_001 end');

      done();
    })

    it('processweb_SetUserAgent_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_SetUserAgent_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('SetUserAgentButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      const src = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src:' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_SetUserAgent_001 end');

      done();
    })

  })
}