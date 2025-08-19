import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
const ERROR_CODE = 16501000;
const ERROR_CODE2 = 16500100;
const ERROR_CODE3 = 801;

export default function OpenFormManager() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('openFormManagerTest', 0, async (done:Function) => {
      let TAG = 'openFormManagerTest';
      let want: Want = {
        bundleName: '',
        abilityName: '',
        parameters: {
          'ohos.extra.param.key.form_dimension': 100,
          'ohos.extra.param.key.form_name': 'widget',
          'ohos.extra.param.key.module_name': 'entry'
        }
      }

      try {
        formProvider.openFormManager(want);
        done();
      } catch (error) {
        if (error.code === ERROR_CODE) {
        } else if (error.code === ERROR_CODE2) {
          expect(error.code).assertEqual(ERROR_CODE2);
        } else if (error.code === ERROR_CODE3) {
          expect(error.code).assertEqual(ERROR_CODE3);
        } else {
          expect().assertFail();
        }
      }
    });
  });
}
