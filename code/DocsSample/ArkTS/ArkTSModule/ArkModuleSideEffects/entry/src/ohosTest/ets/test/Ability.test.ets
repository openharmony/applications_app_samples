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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';
import inputMethod from '@ohos.inputMethod';

const TAG = '[Sample_Arkmodulesideeffects]';
const DOMAIN = 0xF811;
const BUNDLE = 'Arkmodulesideeffects_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

// 通用的测试函数。
async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime); // 等待操作完成。
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done(); // 测试完成。
}

export default function EffectTest() {
  describe('EffectTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.example.arkmodulesideeffects',
        abilityName: 'EntryAbility'
      });
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
    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0001
     * @tc.name Arkmodulesideeffects_EnterPage_0001
     * @tc.desc Enter Page One
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0001', // 测试用例名称。
        '页面1', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page One', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0001
     * @tc.name Arkmodulesideeffects_TestPage_0001
     * @tc.desc Test Page One
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0001', // 测试用例名称。
        '测试页面1', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page One', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0001
     * @tc.name Push_Back_0001
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0001', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0002
     * @tc.name Arkmodulesideeffects_EnterPage_0002
     * @tc.desc Enter Page Two
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0002', // 测试用例名称。
        '页面2', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Two', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0002
     * @tc.name Arkmodulesideeffects_TestPage_0002
     * @tc.desc Test Page Two
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0002', // 测试用例名称。
        '测试页面2', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Two', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0002
     * @tc.name Push_Back_0002
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0002', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0003
     * @tc.name Arkmodulesideeffects_EnterPage_0003
     * @tc.desc Enter Page Three
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0003', // 测试用例名称。
        '页面3', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Three', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0003
     * @tc.name Arkmodulesideeffects_TestPage_0003
     * @tc.desc Test Page Three
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0003', // 测试用例名称。
        '测试页面3', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Three', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0003
     * @tc.name Push_Back_0003
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0003', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0004
     * @tc.name Arkmodulesideeffects_EnterPage_0004
     * @tc.desc Enter Page Four
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0004', // 测试用例名称。
        '页面4', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Four', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0004
     * @tc.name Arkmodulesideeffects_TestPage_0004
     * @tc.desc Test Page Four
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0004', // 测试用例名称。
        '测试页面4', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Four', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0004
     * @tc.name Push_Back_0004
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0004', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0005
     * @tc.name Arkmodulesideeffects_EnterPage_0005
     * @tc.desc Enter Page Five
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0005', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0005', // 测试用例名称。
        '页面5', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Five', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0005
     * @tc.name Arkmodulesideeffects_TestPage_0005
     * @tc.desc Test Page Five
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0005', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0005', // 测试用例名称。
        '测试页面5', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Five', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0005
     * @tc.name Push_Back_0005
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0005', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0006
     * @tc.name Arkmodulesideeffects_EnterPage_0006
     * @tc.desc Enter Page Six
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0006', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0006', // 测试用例名称。
        '页面6', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Six', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0006
     * @tc.name Push_Back_0006
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0006', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0007
     * @tc.name Arkmodulesideeffects_EnterPage_0007
     * @tc.desc Enter Page Seven
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0007', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0007', // 测试用例名称。
        '页面7', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Seven', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0007
     * @tc.name Push_Back_0007
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0007', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0008
     * @tc.name Arkmodulesideeffects_EnterPage_0008
     * @tc.desc Enter Page Eight
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0008', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0008', // 测试用例名称。
        '页面8', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Eight', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0008
     * @tc.name Arkmodulesideeffects_TestPage_0008
     * @tc.desc Test Page Eight
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0008', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0008', // 测试用例名称。
        '测试页面8', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Eight', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0008
     * @tc.name Push_Back_0008
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0008', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0011
     * @tc.name Arkmodulesideeffects_EnterPage_0011
     * @tc.desc Enter Page Eleven
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0011', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0011', // 测试用例名称。
        '页面11', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Eleven', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0011
     * @tc.name Arkmodulesideeffects_TestPage_0011
     * @tc.desc Test Page Eleven
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0011', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0011', // 测试用例名称。
        '测试页面11', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Eleven', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0011
     * @tc.name Push_Back_0011
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0011', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Scroll_Down_0011
     * @tc.name Scroll_Down_0011
     * @tc.desc Test scroll down
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Scroll_Down_0011', Level.LEVEL1, async (done: Function) => {
      // 向下滑动屏幕
      await driver.swipe(500, 1000, 500, 200, 1000);
      await driver.delayMs(1500);  // 等待滑动完成和页面稳定
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0012
     * @tc.name Arkmodulesideeffects_EnterPage_0012
     * @tc.desc Enter Page Twelve
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0012', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0012', // 测试用例名称。
        '页面12', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Twelve', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0012
     * @tc.name Arkmodulesideeffects_TestPage_0012
     * @tc.desc Test Page Twelve
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0012', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0012', // 测试用例名称。
        '测试页面12', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Twelve', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0012
     * @tc.name Push_Back_0012
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0012', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0013
     * @tc.name Arkmodulesideeffects_EnterPage_0013
     * @tc.desc Enter Page Thirteen
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0013', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0013', // 测试用例名称。
        '页面13', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Thirteen', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0013
     * @tc.name Arkmodulesideeffects_TestPage_0013
     * @tc.desc Test Page Thirteen
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0013', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0013', // 测试用例名称。
        '测试页面13', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Thirteen', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0013
     * @tc.name Push_Back_0013
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0013', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number Arkmodulesideeffects_EnterPage_0014
     * @tc.name Arkmodulesideeffects_EnterPage_0014
     * @tc.desc Enter Page Fourteen
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_EnterPage_0014', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_EnterPage_0014', // 测试用例名称。
        '页面14', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Enter Page Fourteen', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Arkmodulesideeffects_TestPage_0014
     * @tc.name Arkmodulesideeffects_TestPage_0014
     * @tc.desc Test Page Fourteen
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Arkmodulesideeffects_TestPage_0014', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Arkmodulesideeffects_TestPage_0014', // 测试用例名称。
        '测试页面14', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Test Page Fourteen', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Push_Back_0014
     * @tc.name Push_Back_0014
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Push_Back_0014', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });

  })
}