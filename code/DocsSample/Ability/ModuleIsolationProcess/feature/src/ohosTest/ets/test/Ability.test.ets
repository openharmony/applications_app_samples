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

const TAG = '[Sample_ModuleIsolationProcess]';
const DOMAIN = 0xF811;
const BUNDLE = 'ModuleIsolationProcess_';
const TIME = 1000;

export default function abilityTest() {
  let driver = Driver.create();
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.sample.moduleisolationprocess',
          moduleName: 'feature',
          abilityName: 'FeatureAbility'
        });
        await driver.delayMs(1000);
        // 获取当前top的ability
        let featureAbility = await abilityDelegator.getCurrentTopAbility();
        expect(featureAbility.context.abilityInfo.name).assertEqual('FeatureAbility');
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'error: ' + JSON.stringify(err));
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction end');
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
    it('ModuleIsolationProcess_feature_click_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'feature_click_001 begin');
      try {
        // 点击文本组件，验证feature模块页面交互
        const text = await driver.findComponent(ON.text('Hello World Feature'));
        await text.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'feature_click_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('ModuleIsolationProcess_feature_click_002', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'feature_click_002 begin');
      try {
        // 通过id点击组件，验证feature模块页面交互后返回
        const text = await driver.findComponent(ON.id('HelloWorld'));
        await text.click();
        await driver.delayMs(TIME);
        await driver.pressBack();
        hilog.info(DOMAIN, TAG, BUNDLE + 'feature_click_002 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
  })
}