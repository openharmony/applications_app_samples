/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[AudioInputDeviceSelection]';
const DOMAIN = 0xF817;
const BUNDLE = 'AudioInputDeviceSelection_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found.`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function AudioInputDeviceSelectionTest() {
  describe('AudioInputDeviceSelectionTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AudioInputDeviceSelection_EnterPage_0001
     * @tc.name AudioInputDeviceSelection_EnterPage_0001
     * @tc.desc Navigate to audio input device selection page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioInputDeviceSelection_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioInputDeviceSelection_EnterPage_0001',
        '实现音频输入设备路由切换页面',
        5000,
        'Navigate to audio input device selection page',
        done
      );
    });

    /**
     * @tc.number AudioInputDeviceSelection_SetPreferredCategory_0001
     * @tc.name AudioInputDeviceSelection_SetPreferredCategory_0001
     * @tc.desc Set Bluetooth or Nearlink preferred record category to low latency
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioInputDeviceSelection_SetPreferredCategory_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioInputDeviceSelection_SetPreferredCategory_0001',
        '设置蓝牙/近场优选低延迟',
        4000,
        'Set Bluetooth or Nearlink preferred record category to low latency',
        done
      );
    });

    /**
     * @tc.number AudioInputDeviceSelection_SelectInputDevice_0001
     * @tc.name AudioInputDeviceSelection_SelectInputDevice_0001
     * @tc.desc Get available input devices and select one
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioInputDeviceSelection_SelectInputDevice_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioInputDeviceSelection_SelectInputDevice_0001',
        '获取并选择输入设备',
        6000,
        'Get available input devices and select one',
        done
      );
    });

    /**
     * @tc.number AudioInputDeviceSelection_GetSelectedDevice_0001
     * @tc.name AudioInputDeviceSelection_GetSelectedDevice_0001
     * @tc.desc Query currently selected input device
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioInputDeviceSelection_GetSelectedDevice_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioInputDeviceSelection_GetSelectedDevice_0001',
        '查询已选输入设备',
        3000,
        'Query currently selected input device',
        done
      );
    });

    /**
     * @tc.number AudioInputDeviceSelection_ClearSelectedDevice_0001
     * @tc.name AudioInputDeviceSelection_ClearSelectedDevice_0001
     * @tc.desc Clear selected input device
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioInputDeviceSelection_ClearSelectedDevice_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioInputDeviceSelection_ClearSelectedDevice_0001',
        '清空已选输入设备',
        3000,
        'Clear selected input device',
        done
      );
    });
  });
}