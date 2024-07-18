import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import Logger from '../utils/Logger';
import { BusinessError } from '@ohos.base';

const BUNDLE = 'AppStartup_';

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
    it('assertContain', 0, async () => {
      Logger.info(BUNDLE + ' test start')
      // 拉起应用
      let delegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await delegator.executeShellCommand('aa start -b com.samples.appstartu -a EntryAbility').then(result => {
        console.info(BUNDLE + 'Uitest, start ability finished:' + JSON.stringify(result))
      }).catch((err: BusinessError) => {
        console.info(BUNDLE + 'Uitest, start ability ERR:' + JSON.stringify(err))
      })
    })
  })
}