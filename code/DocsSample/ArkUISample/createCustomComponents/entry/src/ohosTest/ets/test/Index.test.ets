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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
let driver: Driver;
const TAG = '[Sample_createcustomcomponents]';
const DOMAIN = 0xF811;
const BUNDLE = 'createcustomcomponents_';

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(2000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN,TAG,BUNDLE + 'get top ability')
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    /**
     * @tc.number ParentComponentPageTest
     * @tc.name ParentComponentPageTest
     * @tc.desc 测试ParentComponentPage是否显示正常
     */
    it('ParentComponentPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('ParentComponent', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ParameterSpecificationPageTest
     * @tc.name ParameterSpecificationPageTest
     * @tc.desc 测试ParameterSpecificationPage是否显示正常
     */
    it('ParameterSpecificationPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('ParameterSpecification', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ParentFunctionPageTest
     * @tc.name ParentFunctionPageTest
     * @tc.desc 测试ParentFunctionPage是否显示正常
     */
    it('ParentFunctionPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('ParentFunction', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('add', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number MyComponentBuildPageTest
     * @tc.name MyComponentBuildPageTest
     * @tc.desc 测试MyComponentBuildPage是否显示正常
     */
    it('MyComponentBuildPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('MyComponentBuild', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number MyComponentStylePageTest
     * @tc.name MyComponentStylePageTest
     * @tc.desc 测试MyComponentStylePage是否显示正常
     */
    it('MyComponentStylePageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('MyComponentStyle', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number StaticCodeV1PageTest
     * @tc.name StaticCodeV1PageTest
     * @tc.desc 测试StaticCodeV1Page是否显示正常
     */
    it('StaticCodeV1PageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('StaticCodeV1', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number StaticCodeV2PageTest
     * @tc.name StaticCodeV2PageTest
     * @tc.desc 测试StaticCodeV2Page是否显示正常
     */
    it('StaticCodeV2PageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('StaticCodeV2', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number stateManagementOverviewPageTest
     * @tc.name stateManagementOverviewPageTest
     * @tc.desc 测试stateManagementOverviewPage是否显示正常
     */
    it('stateManagementOverviewPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('stateManagementOverview', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ComponentPageTest
     * @tc.name ComponentPageTest
     * @tc.desc 测试Component页面是否显示正常
     */
    it('ComponentPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('Component', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number FreezeWhenInactivePageTest
     * @tc.name FreezeWhenInactivePageTest
     * @tc.desc 测试FreezeWhenInactive页面是否显示正常
     */
    it('FreezeWhenInactivePageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('FreezeWhenInactive', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number BuildFunctionPageTest
     * @tc.name BuildFunctionPageTest
     * @tc.desc 测试BuildFunction页面是否显示正常
     */
    it('BuildFunctionPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('BuildFunction', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number EntryPageTest
     * @tc.name EntryPageTest
     * @tc.desc 测试Entry页面是否显示正常
     */
    it('EntryPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('Entry', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number RouteNamePageTest
     * @tc.name RouteNamePageTest
     * @tc.desc 测试RouteName页面是否显示正常
     */
    it('RouteNamePageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('RouteName', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ReusablePageTest
     * @tc.name ReusablePageTest
     * @tc.desc 测试Reusable页面是否显示正常
     */
    it('ReusablePageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('Reusable', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number BuilderMethodPageTest
     * @tc.name BuilderMethodPageTest
     * @tc.desc 测试BuilderMethod页面是否显示正常
     */
    it('BuilderMethodPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('BuilderMethod', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number IfPageTest
     * @tc.name IfPageTest
     * @tc.desc 测试If页面是否显示正常
     */
    it('IfPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('IfPage', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ModuleComponentPageTest
     * @tc.name ModuleComponentPageTest
     * @tc.desc 测试ModuleComponent页面是否显示正常
     */
    it('ModuleComponentPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('ModuleComponent', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ForEachFilterPageTest
     * @tc.name ForEachFilterPageTest
     * @tc.desc 测试ForEachFilter页面是否显示正常
     */
    it('ForEachFilterPageTest', 0, async (done: Function) => {
      let targetElement = await driver.findComponent(ON.text('ForEachFilter', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });
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
  })
}