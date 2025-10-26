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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[EventAbility]';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      // 启动应用
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number: CalculationDirectStateTest_001
     * @tc.name: testCalculationDirectState
     * @tc.desc: Directly manipulate state variables
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testCalculationDirectState', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'CalculationDirectStateTest: testCalculationDirectState begin');

      // Click the "CalculationDirectState" item
      const shadowItem = await driver.findComponent(ON.text('CalculationDirectState'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'CalculationDirectStateTest: testCalculationDirectState end');
      done();
    });

    /**
     * @tc.number: CalculationTempVariableTest_001
     * @tc.name: testCalculationTempVariable
     * @tc.desc: Replace state variables with temporary variables
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testCalculationTempVariable', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'CalculationTempVariableTest: testCalculationTempVariable begin');

      // Click the "CalculationTempVariable" item
      const shadowItem = await driver.findComponent(ON.text('CalculationTempVariable'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'CalculationTempVariableTest: testCalculationTempVariable end');
      done();
    });

    /**
     * @tc.number: DeepCopyCorrectTest_001
     * @tc.name: testDeepCopyCorrect
     * @tc.desc: Using @ObjectLink instead of @Prop to reduce unnecessary deep copies - positive example
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testDeepCopyCorrect', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'DeepCopyCorrectTest: testDeepCopyCorrect begin');

      // Click the "DeepCopyCorrect" item
      const shadowItem = await driver.findComponent(ON.text('DeepCopyCorrect'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'DeepCopyCorrectTest: testDeepCopyCorrect end');
      done();
    });

    /**
     * @tc.number: DeepCopyReverseTest_001
     * @tc.name: testDeepCopyReverse
     * @tc.desc: Use @ObjectLink instead of @Prop to reduce unnecessary deep copy counterexamples
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testDeepCopyReverse', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'DeepCopyReverseTest: testDeepCopyReverse begin');

      // Click the "DeepCopyReverse" item
      const shadowItem = await driver.findComponent(ON.text('DeepCopyReverse'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'DeepCopyReverseTest: testDeepCopyReverse end');
      done();
    });

    /**
     * @tc.number: ForceUpdateCounterexampleTest_001
     * @tc.name: testForceUpdateCounterexample
     * @tc.desc: Incorrect: Forcing Re-renders of Non-state Variables
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testForceUpdateCounterexample', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'ForceUpdateCounterexampleTest: testForceUpdateCounterexample begin');

      // Click the "ForceUpdateCounterexample" item
      const shadowItem = await driver.findComponent(ON.text('ForceUpdateCounterexample'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'ForceUpdateCounterexampleTest: testForceUpdateCounterexample end');
      done();
    });

    /**
     * @tc.number: ForceUpdatePositiveCaseTest_001
     * @tc.name: testForceUpdatePositiveCase
     * @tc.desc: Correct: Forcing Re-renders of Non-state Variables
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testForceUpdatePositiveCase', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'ForceUpdatePositiveCaseTest: testForceUpdatePositiveCase begin');

      // Set page scrolling
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      // Click the "ForceUpdatePositiveCase" item
      const shadowItem = await driver.findComponent(ON.text('ForceUpdatePositiveCase'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'ForceUpdatePositiveCaseTest: testForceUpdatePositiveCase end');
      done();
    });

    /**
     * @tc.number: LoopStateInefficientTest_001
     * @tc.name: testLoopStateInefficient
     * @tc.desc: Incorrect: Precise State Variable Scope
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testLoopStateInefficient', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'LoopStateInefficientTest: testLoopStateInefficient begin');

      // Set page scrolling
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      // Click the "LoopStateInefficient" item
      const shadowItem = await driver.findComponent(ON.text('LoopStateInefficient'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'LoopStateInefficientTest: testLoopStateInefficient end');
      done();
    });

    /**
     * @tc.number: LoopStateOptimizedTest_001
     * @tc.name: testLoopStateOptimized
     * @tc.desc: Correct: Precise State Variable Scope
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testLoopStateOptimized', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'LoopStateOptimizedTest: testLoopStateOptimized begin');

      // Set page scrolling
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      // Click the "LoopStateOptimized" item
      const shadowItem = await driver.findComponent(ON.text('LoopStateOptimized'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'LoopStateOptimizedTest: testLoopStateOptimized end');
      done();
    });

    /**
     * @tc.number: PreciseControlCounterexamplesTest_001
     * @tc.name: testPreciseControlCounterexamples
     * @tc.desc: Incorrect: Managing Object State Scope
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testPreciseControlCounterexamples', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'PreciseControlCounterexamplesTest: testPreciseControlCounterexamples begin');

      // Set page scrolling
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      // Click the "PreciseControlCounterexamples" item
      const shadowItem = await driver.findComponent(ON.text('PreciseControlCounterexamples'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'PreciseControlCounterexamplesTest: testPreciseControlCounterexamples end');
      done();
    });

    /**
     * @tc.number: PreciseControlPositiveCasesTest_001
     * @tc.name: testPreciseControlPositiveCases
     * @tc.desc: Correct: Managing Object State Scope
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testPreciseControlPositiveCases', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'PreciseControlPositiveCasesTest: testPreciseControlPositiveCases begin');

      // Set page scrolling
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      // Click the "PreciseControlPositiveCases" item
      const shadowItem = await driver.findComponent(ON.text('PreciseControlPositiveCases'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN_NUMBER, TAG, 'PreciseControlPositiveCasesTest: testPreciseControlPositiveCases end');
      done();
    });
  });
}