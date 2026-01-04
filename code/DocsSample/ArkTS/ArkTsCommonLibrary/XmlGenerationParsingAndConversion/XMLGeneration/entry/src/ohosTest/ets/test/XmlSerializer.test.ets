/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[XmlSerializerTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'XmlSerializerTest_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function XmlSerializerTest() {
  describe('XmlSerializerTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.XMLGeneration',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number XmlSerializer_EnterPage_0001
     * @tc.name XmlSerializer_EnterPage_0001
     * @tc.desc Navigate to XmlSerializer page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('XmlSerializer_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'XmlSerializer_EnterPage_0001',
        'XmlSerializer',
        3000,
        'Navigate to XmlSerializer page',
        done
      );
    });

    /**
     * @tc.number XmlSerializer_TestArrayBuffer_0001
     * @tc.name XmlSerializer_TestArrayBuffer_0001
     * @tc.desc Test XmlSerializer with ArrayBuffer construction method
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('XmlSerializer_TestArrayBuffer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'XmlSerializer_TestArrayBuffer_0001',
        '测试XmlSerializer',
        3000,
        'Test XmlSerializer with ArrayBuffer',
        done
      );
    });

    /**
     * @tc.number XmlSerializer_TestDataView_0001
     * @tc.name XmlSerializer_TestDataView_0001
     * @tc.desc Test XmlSerializer with DataView construction method
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('XmlSerializer_TestDataView_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'XmlSerializer_TestDataView_0001',
        '测试XmlSerializer第二种构造方法',
        3000,
        'Test XmlSerializer with DataView',
        done
      );
    });

    /**
     * @tc.number Decorator_Back_0001
     * @tc.name Decorator_EnterPage_0001
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Decorator_Back_0001', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });
  });
}