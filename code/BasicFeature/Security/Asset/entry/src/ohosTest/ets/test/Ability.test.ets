import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { addAssetPromise,
  postQueryAssetPromise,
  preQueryAssetPromise,
  queryAssetPromise,
  removeAssetPromise,
  updateAssetPromise } from '../../../main/ets/model/AssetModel';

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
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })
    it('assertAdd', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let account = 'asset_account';
      let pwd = 'pwd';
      let label ='label1;label2';
      try {
        await addAssetPromise(account, pwd, label);
        let delete_label = 'label1';
        await removeAssetPromise(account, delete_label);
        expect(0).assertEqual(0);
      } catch (error)  {
        expect(0).assertEqual(false);
      }
    })

    it('assertQuery', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let account = 'asset_account';
      let pwd = 'pwd';
      let label ='label1;label2';
      try {
        await addAssetPromise(account, pwd, label);
        let query_label = 'label1';
        await queryAssetPromise(account, query_label);
        let delete_label = 'label1';
        await removeAssetPromise(account, delete_label);
        expect(0).assertEqual(0);
      } catch (error)  {
        expect(0).assertEqual(false);
      }
    })

    it('assertUpdate', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let account = 'asset_account';
      let pwd = 'pwd';
      let label ='label1;label2';
      try {
        await addAssetPromise(account, pwd, label);
        let reserve_label = 'label1';
        let reserve_password = '123';
        await updateAssetPromise(account, reserve_password, reserve_label);
        let delete_label = 'label1';
        await removeAssetPromise(account, delete_label);
        expect(0).assertEqual(0);
      } catch (error)  {
        expect(0).assertEqual(false);
      }
    })

    it('assertDelete', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let account = 'asset_account';
      let pwd = 'pwd';
      let label ='label1;label2';
      try {
        await addAssetPromise(account, pwd, label);
        let delete_label = 'label1';
        await removeAssetPromise(account, delete_label);
        expect(0).assertEqual(0);
      } catch (error)  {
        expect(0).assertEqual(false);
      }
    })

    it('assertPreQuery', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let account = 'asset_account';
      let pwd = 'pwd';
      let label ='label1;label2';
      try {
        await addAssetPromise(account, pwd, label);
        let challenge = await preQueryAssetPromise(account);
        await postQueryAssetPromise(challenge);
        let delete_label = 'label1';
        await removeAssetPromise(account, delete_label);
        expect(0).assertEqual(0);
      } catch (error)  {
        expect(0).assertEqual(false);
      }
    })

  })
}