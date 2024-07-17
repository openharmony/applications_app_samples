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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { hilog } from '@kit.PerformanceAnalysisKit';

const LOG_TAG: string  = '[Sample_Graphics2D]'
const DOMAIN = 0xF811
const BUNDLE = 'Graphics2d'
const driver = Driver.create();
const abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function TextCollapseEtsDemoTest() {
  describe('TextCollapseEtsDemoTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    /**
     * start application
     */
    it('StartAbility_001', 0, async (done : () => void) => {
      hilog.info(DOMAIN, LOG_TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'com.samples.rendernodegraph',
          abilityName: 'EntryAbility'
        })
      } catch (err) {
        expect(0).assertEqual(err.code);
      }
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, LOG_TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     *  This test case tests the paintVerbatim effects of 2D text
     */
    it('Graphics2d_paint_verbatim_function_001',0, async (done : () => void) => {
      hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics2d_paint_verbatim_function_001' + ' begin');
      // test click a text
      await driver.assertComponentExist(ON.id('paint-verbatim'));
      hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics2d_paint_verbatim_function_001' + ' end');
      done()
    });
  })
}