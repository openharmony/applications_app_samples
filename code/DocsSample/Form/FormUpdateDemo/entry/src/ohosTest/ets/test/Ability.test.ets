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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component, Point } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_FormUpdateDemo]';
const DOMAIN = 0xF811;
const DELAYTIME01 = 500;
const DELAYTIME02 = 2000;

let driver = Driver.create();
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}
export default function abilityTest() {
  describe('FormUpdateDemo', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
    beforeAll(async (done: Function) => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      await abilityDelegatorRegistry.startAbility({
        bundleName: 'com.samples.formupdatedemo',
        abilityName: 'EntryAbility'
      });
      done();
    });
    /**
     * 应用添加卡片后触发场景动效
     */
    it('FormUpdateDemo_Update_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'FormUpdateDemo_Update_001 test start');
      await driver.delayMs(DELAYTIME01);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.default_title'))));
      let button = await driver.findComponent(ON.text(await getResourceString($r('app.string.button_update'))));
      await button.click();
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.update_title'))));
      hilog.info(DOMAIN, TAG, 'FormUpdateDemo_Update_001 test end');
      done();
    });
  })
}
