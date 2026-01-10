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

const TAG = '[MainpageTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'MainpageTest_';
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

export default function MainpageTest() {
  describe('MainpageTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.BytecodeObfuscationIssues',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number Mainpage_EnterPage_0001
     * @tc.name Mainpage_EnterPage_0001
     * @tc.desc Navigate to test page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Mainpage_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Mainpage_EnterPage_0001',
        '主页面',
        5000,
        'Navigate to test page from main page',
        done
      );
    });

    /**
     * @tc.number BytecodeObfuscation_TestObj_0001
     * @tc.name BytecodeObfuscation_TestObj_0001
     * @tc.desc Test object bytecode obfuscation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('BytecodeObfuscation_TestObj_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'BytecodeObfuscation_TestObj_0001',
        '测试对象字节码混淆',
        3000,
        'Test object bytecode obfuscation',
        done
      );
    });

    /**
     * @tc.number BytecodeObfuscation_TestProp_0001
     * @tc.name BytecodeObfuscation_TestProp_0001
     * @tc.desc Test object bytecode obfuscation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('BytecodeObfuscation_TestProp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'BytecodeObfuscation_TestProp_0001',
        '测试属性字节码混淆',
        3000,
        'Test property bytecode obfuscation',
        done
      );
    });

    /**
     * @tc.number BytecodeObfuscation_TestFunc_0001
     * @tc.name BytecodeObfuscation_TestFunc_0001
     * @tc.desc Test function bytecode obfuscation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('BytecodeObfuscation_TestFunc_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'BytecodeObfuscation_TestFunc_0001',
        '测试外源函数',
        3000,
        'Test function bytecode obfuscation',
        done
      );
    });

    /**
     * @tc.number BytecodeObfuscation_TestNs_0001
     * @tc.name BytecodeObfuscation_TestNs_0001
     * @tc.desc Test namespace bytecode obfuscation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('BytecodeObfuscation_TestNs_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'BytecodeObfuscation_TestNs_0001',
        '测试外源命名空间',
        3000,
        'Test namespace bytecode obfuscation',
        done
      );
    });

    /**
     * @tc.number BytecodeObfuscation_Back_0001
     * @tc.name BytecodeObfuscation_Back_0001
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('BytecodeObfuscation_Back_0001', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });
  });
}