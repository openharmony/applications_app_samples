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

const TAG = '[ArkTSCodingStyleGuide]';
const DOMAIN = 0xF815;
const BUNDLE = 'ArkTSCodingStyleGuide_';
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

export default function ArkTSCodingStyleGuide() {
  describe('ArkTSCodingStyleGuide', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.CodingStyleGuide',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number ArkTSCodingStyleGuide_UpperCamelCase_0001
     * @tc.name ArkTSCodingStyleGuide_UpperCamelCase_0001
     * @tc.desc Test Upper Camel Case
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_UpperCamelCase_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_UpperCamelCase_0001',
        'ArkTs编译规范-首字母大写的驼峰命名法',
        3000,
        'Test Upper Camel Case',
        done
      );
    });

    /**
     * @tc.number ArkTSCodingStyleGuide_lowerCamelCase_0001
     * @tc.name ArkTSCodingStyleGuide_lowerCamelCase_0001
     * @tc.desc Test lower Camel Case
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_lowerCamelCase_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_lowerCamelCase_0001',
        'ArkTs编译规范-首字母小写的驼峰命名法',
        3000,
        'Test lower Camel Case',
        done
      );
    });

    /**
     * @tc.number ArkTSCodingStyleGuide_AllUpper_0001
     * @tc.name ArkTSCodingStyleGuide_AllUpper_0001
     * @tc.desc Test use uppercase letters for constant names and enum value names and separate words by underscores
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_AllUpper_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_AllUpper_0001',
        'ArkTs编译规范-常量命名全大写',
        3000,
        'Test all upper',
        done
      );
    });

    /**
     * @tc.number ArkTSCodingStyleGuide_booleanVariable_0001
     * @tc.name ArkTSCodingStyleGuide_booleanVariable_0001
     * @tc.desc Test boolean variable names
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_booleanVariable_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_booleanVariable_0001',
        'ArkTs编译规范-布尔变量命名',
        3000,
        'Test boolean variable names',
        done
      );
    });

    /**
     * @tc.number ArkTSCodingStyleGuide_SpaceIndentation_0001
     * @tc.name ArkTSCodingStyleGuide_SpaceIndentation_0001
     * @tc.desc Test use spaces for indentation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_SpaceIndentation_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_SpaceIndentation_0001',
        'ArkTs编译规范-使用空格缩进',
        3000,
        'Test use spaces for indentation',
        done
      );
    });

    /**
     * @tc.number ArkTSCodingStyleGuide_BracesGuide_0001
     * @tc.name ArkTSCodingStyleGuide_BracesGuide_0001
     * @tc.desc Test use braces in conditional statements and loop statements
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_BracesGuide_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_BracesGuide_0001',
        'ArkTs编译规范-使用大括号',
        3000,
        'Test use braces in conditional statements and loop statements',
        done
      );
    });

    /**
     * @tc.number ArkTSCodingStyleGuide_Overall_0001
     * @tc.name ArkTSCodingStyleGuide_Overall_0001
     * @tc.desc Test multiple guide
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSCodingStyleGuide_Overall_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSCodingStyleGuide_Overall_0001',
        'ArkTs编译规范-综合',
        3000,
        'Test multiple guide',
        done
      );
    });
  });
}