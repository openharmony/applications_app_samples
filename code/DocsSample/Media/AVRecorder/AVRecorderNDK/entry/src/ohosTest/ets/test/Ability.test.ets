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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import Base from '@ohos.base';
import { Driver, ON } from '@ohos.UiTest';
import fs from '@ohos.file.fs';
import Want from '@ohos.app.ability.Want';

const TAG = 'abilityTest';
const domain: number = 0x0000;

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
    it('assertContain', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let want: Want = {
        bundleName: 'com.sample.avrecordersample',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(domain, TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      let driver = await Driver.create();
      await driver.delayMs(2000);
      let allowBtn1 = await driver.findComponent(ON.text(getContext().resourceManager.getStringSync($r('app.string.Prepare'))));
      await allowBtn1.click();
      await driver.delayMs(1000);
      let allowBtn2 = await driver.findComponent(ON.text(getContext().resourceManager.getStringSync($r('app.string.Start'))));
      await allowBtn2.click();
      await driver.delayMs(2000);
      let btn3 = await driver.findComponent(ON.text(getContext().resourceManager.getStringSync($r('app.string.Pause'))));
      await btn3.click();
      await driver.delayMs(2000);
      let btn4 = await driver.findComponent(ON.text(getContext().resourceManager.getStringSync($r('app.string.Resume'))));
      await btn4.click();
      await driver.delayMs(2000);
      let allowBtn3 = await driver.findComponent(ON.text(getContext().resourceManager.getStringSync($r('app.string.Stop'))));
      await allowBtn3.click();
      await driver.delayMs(2000);
      let btn5 = await driver.findComponent(ON.text(getContext().resourceManager.getStringSync($r('app.string.Release'))));
      await btn5.click();
      let files: string[] = fs.listFileSync('/data/storage/el2/base/files/');
      expect(files).assertContain('avrecorder01.mp4');
    })
  })
}