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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { Driver, ON, Component, abilityDelegatorRegistry } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

let driver = Driver.create();

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      const delegator = abilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: 'com.example.thirdparty.wearable',
        abilityName: 'EntryAbility',
        moduleName: 'entry'
      };
      delegator.startAbility(want);
      await sleep(1000);
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
     * @tc.number SUB_SAMPLE_ThirdPartyWearable_0100
     * @tc.name SUB_SAMPLE_ThirdPartyWearable_0100
     * @tc.desc Allow the hap to access Bluetooth
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_ThirdPartyWearable_0100', Level.LEVEL1,
      async (done: Function) => {
        await sleep(1000);
        let box1: Component =
          await driver.findComponent(ON.text('允许'));
        await box1.click();
        await sleep(1000);
        let event: string = await AppStorage.get('event')!;
        expect(event).assertEqual('requestPermissionsFromUser');
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_ThirdPartyWearable_0200
     * @tc.name SUB_SAMPLE_ThirdPartyWearable_0200
     * @tc.desc Obtains the Bluetooth device that has been paired with the current device and the pair state of the device
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_ThirdPartyWearable_0200', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component =
          await driver.findComponent(ON.text('queryBluetooth'));
        await box1.click();
        await sleep(1000);
        let checkBoxs: Array<Component> = await driver.findComponents(ON.type('Checkbox'));
        await sleep(500);
        await checkBoxs[0].click();
        await sleep(1000);
        let event: string = await AppStorage.get('event')!;
        expect(event).assertEqual('queryBluetooth');
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_ThirdPartyWearable_0300
     * @tc.name SUB_SAMPLE_ThirdPartyWearable_0300
     * @tc.desc Subscribe the notification extension when the bluetooth addr is connected
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_ThirdPartyWearable_0300', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component =
          await driver.findComponent(ON.text('subscribe'));
        await box1.click();
        await sleep(1000);
        let event: string = await AppStorage.get('event')!;
        expect(event).assertEqual('subscribe');
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_ThirdPartyWearable_0400
     * @tc.name SUB_SAMPLE_ThirdPartyWearable_0400
     * @tc.desc Unsubscribe the notification extension.
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_ThirdPartyWearable_0400', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component =
          await driver.findComponent(ON.text('unsubscribe'));
        await box1.click();
        await sleep(1000);
        let event: string = await AppStorage.get('event')!;
        expect(event).assertEqual('unsubscribe');
        done();
      })
  })
}