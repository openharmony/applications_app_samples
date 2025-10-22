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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const TAG = '[Sample_WebDragInteraction]';
const DOMAIN = 0xF811;
const BUNDLE = 'ProcessWeb_';
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}
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
    it('processweb_DragArkTSPage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_DragArkTSPage_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('DragArkTSPageButton'));
      await button.click();
      await driver.delayMs(3000);

      const Component1 = await driver.findComponent(ON.text(await getResourceString($r('app.string.string1'))));
      const Component2 = await driver.findComponent(ON.text(await getResourceString($r('app.string.string2'))));
      await Component1.dragTo(Component2);
      await driver.delayMs(3000);

      const Component3 = await driver.findComponent(ON.text(await getResourceString($r('app.string.string3'))))
      const res2 = await Component3.getText();
      const res = await Component2.getText();
      expect(res).assertEqual(res2);
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_DragArkTSPage_001 end');

      done();
    })

    it('processweb_SetUAPage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_SetUAPage_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('SetUAPageButton'));
      await button.click();
      await driver.delayMs(3000);

      const Component1 = await driver.findComponent(ON.type('Web'));
      const res = await Component1.getText();
      await driver.delayMs(1000);

      expect(res).assertContain('example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'uitest: processweb_SetUAPage_001 end');

      done();
    })

  })
}