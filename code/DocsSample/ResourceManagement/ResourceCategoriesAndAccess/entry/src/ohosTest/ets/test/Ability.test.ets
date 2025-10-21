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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { UIAbility, Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';

const TAG = '[Sample_resource_categories_and_access]';
const DOMAIN = 0x0000;
const BUNDLE_NAME = 'com.samples.resourcecategoriesandaccess';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('ResourceCategoriesAndAccessTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ResourceCategoriesAndAccessTest begin');
      hilog.info(DOMAIN, TAG, 'start EntryAbility');
      const want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: 'EntryAbility',
      };
      await delegator.startAbility(want);
      await sleep(3000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      hilog.info(DOMAIN, TAG, 'start EntryAbility success');

      let driver = Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'get app resource test begin');
      let appResourceText = await driver.findComponent(ON.id('app_resource'));
      expect(await appResourceText.getText() === 'Hello').assertTrue();
      hilog.info(DOMAIN, TAG, 'get app resource test end');

      hilog.info(DOMAIN, TAG, 'get app string resource test begin');
      let appStringResourceText = await driver.findComponent(ON.id('app_string_resource'));
      expect(await appStringResourceText.getText() === 'Hello, LiHua!,You have 2 new messages.').assertTrue();
      hilog.info(DOMAIN, TAG, 'get app string resource test end');

      hilog.info(DOMAIN, TAG, 'get app plural resource test begin');
      let appPluralResourceText = await driver.findComponent(ON.id('app_plural_resource'));
      expect(await appPluralResourceText.getText() === '2 apples').assertTrue();
      hilog.info(DOMAIN, TAG, 'get app plural resource test end');

      hilog.info(DOMAIN, TAG, 'get hsp resource test begin');
      let hspResourceTextOne = await driver.findComponent(ON.id('hsp_resource_one'));
      expect(await hspResourceTextOne.getText() === 'library string test').assertTrue();
      let hspResourceTextTwo = await driver.findComponent(ON.id('hsp_resource_two'));
      expect(await hspResourceTextTwo.getText() === 'library string test').assertTrue();
      hilog.info(DOMAIN, TAG, 'get hsp resource test end');

      await driver.swipe(300, 700, 300, 200);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'get configure resource test begin');
      let configResourceTextOne = await driver.findComponent(ON.id('config_resource_one'));
      expect(await configResourceTextOne.getText()).not().assertNull();
      let configResourceTextTwo = await driver.findComponent(ON.id('config_resource_two'));
      expect(await configResourceTextTwo.getText() === 'Hello, world').assertTrue();
      let configResourceTextThree = await driver.findComponent(ON.id('config_resource_three'));
      expect(await configResourceTextThree.getText() === 'こんにちは、世界').assertTrue();
      hilog.info(DOMAIN, TAG, 'get configure resource test end');
      done();
    })
  })
}