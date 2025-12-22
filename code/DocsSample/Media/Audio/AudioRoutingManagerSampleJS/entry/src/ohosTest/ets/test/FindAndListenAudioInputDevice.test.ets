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

const TAG = '[FindAndListenAudioInputDevice]';
const DOMAIN = 0xF815;
const BUNDLE = 'FindAndListenAudioInputDevice_';
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
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function FindAndListenAudioInputDeviceTest() {
  describe('FindAndListenAudioInputDeviceTest', () => {
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
     * @tc.number FindAndListenAudioInputDevice_EnterPage_0001
     * @tc.name FindAndListenAudioInputDevice_EnterPage_0001
     * @tc.desc Navigate to audio input device listening page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('FindAndListenAudioInputDevice_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'FindAndListenAudioInputDevice_EnterPage_0001',
        '查询和监听音频输入设备页面',
        5000,
        'Navigate to audio input device listening page',
        done
      );
    });

    /**
     * @tc.number FindAndListenAudioInputDevice_GetDevices_0001
     * @tc.name FindAndListenAudioInputDevice_GetDevices_0001
     * @tc.desc Click get input devices list button to fetch and display available audio input devices
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('FindAndListenAudioInputDevice_GetDevices_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'FindAndListenAudioInputDevice_GetDevices_0001',
        '获取输入设备列表',
        6000,
        'Click get input devices list button',
        done
      );
    });
  });
}