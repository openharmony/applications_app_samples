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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
//Delay of 1000 milliseconds
const DELAY_1000: number = 1000;
//Delay of 3000 milliseconds
const DELAY_3000: number = 3000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      done();
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(async (done: Function) => {
      const driver = Driver.create();
      await driver.pressBack();
      await driver.delayMs(DELAY_3000);
      done();
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('testWebTextMenuItem001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('textMenuItem'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index.html');
      done();
    })

    it('testContextMenu001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('contextMenu'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index1.html');
      done();
    })

    it('testBindSelectionMenu001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('bindSelectionMenu'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index2.html');
      done();
    })

    it('testWebPreviewBuilder001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('previewBuilder'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index3.html');
      done();
    })

    it('testWebSaveImage001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('saveImage'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index4.html');
      done();
    })

    it('testWebEditMenuOptions001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('editMenuOptions'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index5.html');
      done();
    })

    it('testWebScanQRCode001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('scanQRCode'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index6.html');
      done();
    })

    it('testWebDisableLongPress001', 0, async (done: Function) => {
      const driver = Driver.create();
      await driver.delayMs(DELAY_1000);

      const button1 = await driver.findComponent(ON.text('disableLongPress'));
      await button1.click();
      await driver.delayMs(DELAY_3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index7.html');
      done();
    })

  })
}