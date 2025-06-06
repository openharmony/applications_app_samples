/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import commonEvent from '@ohos.commonEventManager';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
const TAG = '[Sample_UIExtensionAbility]'

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(async () => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(async () => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(async () => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('EmbeddedUIExtension_Start_Test_001',0, async (done : () => void) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let actsEvents = ['page_show'];
      let subscriber : commonEvent.CommonEventSubscriber;
      commonEvent.createSubscriber({ events: actsEvents }).then((data)=>{
        subscriber = data;
        commonEvent.subscribe(data, (err, data)=>{
          console.info(TAG + ' subscribeCallBack. Data: ' + JSON.stringify(data));
          done();
        });

        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        const cmd = 'aa start -a EntryAbility -b com.samples.embeddeduiextensionability';
        abilityDelegator.executeShellCommand(cmd,
          (err, d) => {
            console.info('executeShellCommand : err : ' + JSON.stringify(err));
            console.info('executeShellCommand : data : ' + d.stdResult);
            console.info('executeShellCommand : data : ' + d.exitCode);
          })
        setTimeout(() => {
          expect().assertFail();
          done();
        }, 5000);
      })
    })
  })
}