import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { hiRetrieval } from '@kit.PerformanceAnalysisKit';

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
    it('assertContain', 0, () => {
      let cfg: hiRetrieval.HiRetrievalConfig = {
        userType: "testUserType",
        deviceType: "testDeviceType",
        deviceModel: "testDeviceModel"
      };
      try {
        hiRetrieval.participate(cfg);
      } catch (e) {
        expect(number(e.code)).assertEqual(360000001)
      }
      try {
        hiRetrieval.run();
      } catch (e) {
        expect(number(e.code)).assertEqual(360000001)
      }
      try {
        hiRetrieval.quit();
      } catch (e) {
        expect(number(e.code)).assertEqual(360000001)
      }
      hiRetrieval.init();
      try {
        hiRetrieval.participate(cfg);
        hiRetrieval.run();
        hiRetrieval.quit();
      } catch (e) {
      }
    })
  })
}