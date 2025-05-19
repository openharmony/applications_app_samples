import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

export default function abilityTest() {
  const TAG = '[Sample_AVPlayerArkTS]';
  const DOMAIN = 0xF811;
  const driver = Driver.create();
  const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

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


    /**
     * 打开应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      console.info(TAG, 'StartAbility_001 begin');

      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.media.AVPlayerArkTSURL',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.error(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(3000);
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * 播放、暂停、拖进度条
     */
    it('Slider_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Slider_001 begin');

      // 点播放
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.type('Image'));
      let stack = await driver.findComponent(ON.type('Image'));

      // 暂停
      await stack.click();
      await driver.delayMs(3000);

      // 滑动滑块
      await driver.assertComponentExist(ON.id('Slider'));
      let Slider = await driver.findComponent(ON.id('Slider'));
      let point = await Slider.getBoundsCenter();
      await driver.drag(point.x - 50, point.y, point.x + 50, point.y, 800);
      await driver.delayMs(1000);

      // 播放
      await stack.click();
      await driver.delayMs(1000);

      done();
      hilog.info(DOMAIN, TAG, 'Slider_001 end');
    })

    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })

    /**
     * 暂停并退出
     */
    it('Exit_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Exit_001 begin');

      // 暂停
      await driver.delayMs(8000);
      await driver.assertComponentExist(ON.type('Image'));
      let stack = await driver.findComponent(ON.type('Image'));
      await stack.click();
      await driver.delayMs(2000);

      done();
      hilog.info(DOMAIN, TAG, 'Exit_001 end');
    })
  })
}