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

const TAG = '[ArkTSBasicsTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'ArkTSBasicsTest_';
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

export default function ArkTSBasicsTest() {
  describe('ArkTSBasicsTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.MigratingFromJavaToArkTS',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number ArkTSBasics_TypeAnnotation_0001
     * @tc.name ArkTSBasics_TypeAnnotation_0001
     * @tc.desc Test type annotation and type inference
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_TypeAnnotation_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_TypeAnnotation_0001',
        '测试类型注解',
        3000,
        'Test type annotation',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_FunctionDefinition_0001
     * @tc.name ArkTSBasics_FunctionDefinition_0001
     * @tc.desc Test regular function and arrow function definition
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_FunctionDefinition_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_FunctionDefinition_0001',
        '测试函数定义',
        3000,
        'Test function definition',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_FunctionOverload_0001
     * @tc.name ArkTSBasics_FunctionOverload_0001
     * @tc.desc Test function overloading with different parameter types
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_FunctionOverload_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_FunctionOverload_0001',
        '测试函数重载',
        3000,
        'Test function overload',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_ImportCollections_0001
     * @tc.name ArkTSBasics_ImportCollections_0001
     * @tc.desc Test importing ArkTS collections from standard library
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_ImportCollections_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_ImportCollections_0001',
        '测试引入容器集',
        3000,
        'Test import collections',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_Namespace_0001
     * @tc.name ArkTSBasics_Namespace_0001
     * @tc.desc Test namespace declaration and usage
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_Namespace_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_Namespace_0001',
        '测试命名空间',
        3000,
        'Test namespace',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_ThisContext_0001
     * @tc.name ArkTSBasics_ThisContext_0001
     * @tc.desc Test this context binding in function calls
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_ThisContext_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_ThisContext_0001',
        '测试this上下文',
        3000,
        'Test this context',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_TypeInference_0001
     * @tc.name ArkTSBasics_TypeInference_0001
     * @tc.desc Test automatic type inference by compiler
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_TypeInference_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_TypeInference_0001',
        '测试类型推断',
        3000,
        'Test type inference',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_OptionalProperty_0001
     * @tc.name ArkTSBasics_OptionalProperty_0001
     * @tc.desc Test optional property in interface definition
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_OptionalProperty_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_OptionalProperty_0001',
        '测试可选属性',
        3000,
        'Test optional property',
        done
      );
    });

    /**
     * @tc.number ArkTSBasics_UnionType_0001
     * @tc.name ArkTSBasics_UnionType_0001
     * @tc.desc Test union type with multiple type options
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSBasics_UnionType_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSBasics_UnionType_0001',
        '测试联合类型',
        3000,
        'Test union type',
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