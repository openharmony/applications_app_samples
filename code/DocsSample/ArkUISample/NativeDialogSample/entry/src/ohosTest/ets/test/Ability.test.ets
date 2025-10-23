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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
const TAG: string = '[SAMPLE_TEST]';
const DOMAIN: number = 0xFF00;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
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
    it('testOpenDialogDemoController', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'testOpenDialogDemoController begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('dialog demo', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await sleep(1000);
      let button2 = await driver.findComponent(
        ON.text(resource.resourceToString($r('app.string.dialog_controller_demo')), MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await sleep(1000);
      let button3 = await driver.findComponent(ON.text('点击弹窗', MatchPattern.CONTAINS));
      expect(button3 === null).assertFalse();
      await button3.click();
      await sleep(1000);
      let button4 = await driver.findComponent(ON.text('关闭弹窗', MatchPattern.CONTAINS));
      expect(button4 === null).assertFalse();
      await button4.click();
      await sleep(1000);
      await driver.pressBack();
      done();
    })

    it('testOpenDialogDemoOption', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'testOpenDialogDemoOption begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('dialog demo', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await sleep(1000);
      let button2 = await driver.findComponent(
        ON.text(resource.resourceToString($r('app.string.dialog_option_demo')), MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await sleep(1000);
      let button3 = await driver.findComponent(ON.text('点击弹窗', MatchPattern.CONTAINS));
      expect(button3 === null).assertFalse();
      await button3.click();
      await sleep(1000);
      let button4 = await driver.findComponent(ON.text('关闭弹窗', MatchPattern.CONTAINS));
      expect(button4 === null).assertFalse();
      await button4.click();
      await sleep(1000);
      await driver.pressBack();
      done();
    })

    it('testOpenDialogDemoLifecycle', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'testOpenDialogDemoLifecycle begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('dialog demo', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await sleep(1000);
      let button2 = await driver.findComponent(
        ON.text(resource.resourceToString($r('app.string.dialog_lifecycle_demo')), MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await sleep(1000);
      let button3 = await driver.findComponent(ON.text('点击弹窗', MatchPattern.CONTAINS));
      expect(button3 === null).assertFalse();
      await button3.click();
      await sleep(1000);
      let button4 = await driver.findComponent(ON.text('关闭弹窗', MatchPattern.CONTAINS));
      expect(button4 === null).assertFalse();
      await button4.click();
      await sleep(1000);
      await driver.pressBack();
      done();
    })
  })
}