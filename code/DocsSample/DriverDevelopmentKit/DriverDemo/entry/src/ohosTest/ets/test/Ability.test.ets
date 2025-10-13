import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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
    it('testUiDriver', Level.LEVEL1, async (done: Function)  => {
      console.info("uitest: TestUiExample begin");
      // 初始化Driver对象
      const driver = Driver.create();
      const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      console.info("uitest: bundleName=", bundleName);
      // 指定被测应用包名、ability名，请开发者替换为被测应用包名和ability名
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      // 拉起被测应用
      await delegator.startAbility(want);
      // 等待应用拉起完成
      await driver.waitForIdle(4000,5000);
      // 确认当前应用顶部Ability为指定的ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');

      // 依据指定文本“Hello”查找目标控件
      const helloCom = await driver.findComponent(ON.text('Hello'));
      // 点击目标控件
      await helloCom.click();
      await driver.waitForIdle(4000,5000);
      await sleep(3000);
      // 通过断言文本为“Hello World”的控件存在，确认操作后页面变化符合预期
      await driver.assertComponentExist(ON.text('Hello World'));
      await driver.pressBack();
      done();
    })
  })
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
