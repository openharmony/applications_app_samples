import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
let driver: Driver;
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
      console.info('get top ability');
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
     * @tc.number OnePageTest
     * @tc.name OnePageTest
     * @tc.desc 测试OnePage是否显示正常
     */
    it('OnePageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('One', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number TwoPageTest
     * @tc.name TwoPageTest
     * @tc.desc 测试TwoPage是否显示正常
     */
    it('TwoPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Two', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number ThreePageTest
     * @tc.name ThreePageTest
     * @tc.desc 测试ThreePage是否显示正常
     */
    it('ThreePageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Three', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number FourPageTest
     * @tc.name FourPageTest
     * @tc.desc 测试FourPage是否显示正常
     */
    it('FourPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Four', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number FivePageTest
     * @tc.name FivePageTest
     * @tc.desc 测试FivePage是否显示正常
     */
    it('FivePageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Five', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number SixPageTest
     * @tc.name SixPageTest
     * @tc.desc 测试SixPage是否显示正常
     */
    it('SixPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Six', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number SevenPageTest
     * @tc.name SevenPageTest
     * @tc.desc 测试SevenPage是否显示正常
     */
    it('SevenPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Seven', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number EightPageTest
     * @tc.name EightPageTest
     * @tc.desc 测试EightPage是否显示正常
     */
    it('EightPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Eight', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number NinePageTest
     * @tc.name NinePageTest
     * @tc.desc 测试NinePage是否显示正常
     */
    it('NinePageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Nine', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number TenPageTest
     * @tc.name TenPageTest
     * @tc.desc 测试TenPage是否显示正常
     */
    it('TenPageTest', 0, async (done: Function) => {
   
      let targetElement = await driver.findComponent(ON.text('Ten', MatchPattern.CONTAINS));
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