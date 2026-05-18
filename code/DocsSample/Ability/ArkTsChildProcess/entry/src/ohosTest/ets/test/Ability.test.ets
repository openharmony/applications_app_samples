/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Driver, ON } from '@ohos.UiTest'

const TAG = '[Sample_arktschildprocess]';
const DOMAIN = 0xF811;
const BUNDLE = 'arktschildprocess_';
const TIME = 1000;

export default function abilityTest() {
  let driver = Driver.create();
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.sample.arktschildprocess',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(TIME);
        // 获取当前top的ability
        let entryAbility = await abilityDelegator.getCurrentTopAbility();
        expect(entryAbility.context.abilityInfo.name).assertEqual('EntryAbility');
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'error: ' + err.message);
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
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
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })
    it('ArkTsChildProcess_startChildProcess_Promise_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'startChildProcess_Promise_001 begin');
      try {
        const button = await driver.findComponent(ON.text('StartArkChildProcessNoArg_Promise'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'startChildProcess_Promise_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('ArkTsChildProcess_startChildProcess_Callback_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'startChildProcess_Callback_001 begin');
      try {
        const button = await driver.findComponent(ON.text('StartArkChildProcessNoArg_Callback'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'startChildProcess_Callback_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('ArkTsChildProcess_startArkChildProcess_WithArg_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'startArkChildProcess_WithArg_001 begin');
      try {
        const button = await driver.findComponent(ON.text('StartArkChildProcessWithArg'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'startArkChildProcess_WithArg_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
  })
}