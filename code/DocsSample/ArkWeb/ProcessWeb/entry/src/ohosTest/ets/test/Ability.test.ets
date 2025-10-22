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
const TAG = '[Sample_ProcessWeb]';
const DOMAIN = 0xF811;
const BUNDLE = 'ProcessWeb_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'ActsAbilityTest begin');
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
    it('processweb_setRenderProcessMode_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_setRenderProcessMode_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('setRenderProcessModeButton'));
      await button.click();
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('getRenderProcessMode'));
      await button1.click();
      await driver.delayMs(100);

      const button2 = await driver.findComponent(ON.text('setRenderProcessMode'));
      await button2.click();
      await driver.delayMs(100);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_setRenderProcessMode_001 end');
      done();
    })

    it('processweb_terminateRenderProcess_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_terminateRenderProcess_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('terminateRenderProcessButton'));
      await button.click();
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('terminateRenderProcess'));
      await button1.click();
      await driver.delayMs(100);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_terminateRenderProcess_001 end');
      done();
    })

    it('processweb_onRenderExited_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_onRenderExited_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('onRenderExitedButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('chrome://crash/');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_onRenderExited_001 end');
      done();
    })

    it('processweb_onRenderProcessNotResponding_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_onRenderProcessNotResponding_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('onRenderProcessNotRespondingButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_onRenderProcessNotResponding_001 end');
      done();
    })

    it('processweb_onRenderProcessResponding_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_onRenderProcessResponding_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('onRenderProcessRespondingButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_onRenderProcessResponding_001 end');

      done();
    })

    it('processweb_WebComponentCreat_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_WebComponentCreat_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebComponentCreatButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('www.example.com');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_WebComponentCreat_001 end');

      done();
    })

    it('processweb_FixingPageFlickering_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_FixingPageFlickering_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('FixingPageFlickeringButton'));
      await button.click();
      await driver.delayMs(3000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      hilog.info(DOMAIN, TAG, BUNDLE, 'src: ' + src);
      expect(src).assertContain('xxx.html');
      hilog.info(DOMAIN, TAG, BUNDLE, 'processweb_FixingPageFlickering_001 end');

      done();
    })
  })
}