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

import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { describe, it, expect } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_ArkTSInputDeviceAPI]';
const DOMAIN = 0xF811;
const BUNDLE = 'ArkTSInputDeviceAPI_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
     /**
     * 打开应用
     */
    it('ArkTSInputDeviceAPI_StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktsinputdevice',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Click to obtain the device list and monitor device hot-plug events'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 获取设备列表并添加监听
     */
    it('ArkTSInputDeviceAPI_InputDevice_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputDevice_001, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktsinputdevice',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `InputDevice_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Click to obtain the device list and monitor device hot-plug events'));
      let button = await driver.findComponent(ON.text('Click to obtain the device list and monitor device hot-plug events'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputDevice_001 end')
    })
  })
}