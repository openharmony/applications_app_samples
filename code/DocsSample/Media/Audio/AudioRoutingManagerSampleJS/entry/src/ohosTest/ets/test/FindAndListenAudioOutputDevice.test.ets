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

const TAG = '[FindAndListenAudioOutputDevice]';
const DOMAIN = 0xF816;
const BUNDLE = 'FindAndListenAudioOutputDevice_';
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

export default function FindAndListenAudioOutputDeviceTest() {
  describe('FindAndListenAudioOutputDeviceTest', () => {
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
     * @tc.number FindAndListenAudioOutputDevice_EnterPage_0001
     * @tc.name FindAndListenAudioOutputDevice_EnterPage_0001
     * @tc.desc Navigate to audio output device listening page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('FindAndListenAudioOutputDevice_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'FindAndListenAudioOutputDevice_EnterPage_0001',
        '查询和监听音频输出设备页面',
        5000,
        'Navigate to audio output device listening page',
        done
      );
    });

    /**
     * @tc.number FindAndListenAudioOutputDevice_GetOutputDevices_0001
     * @tc.name FindAndListenAudioOutputDevice_GetOutputDevices_0001
     * @tc.desc Click get output devices list button to fetch available audio output devices
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('FindAndListenAudioOutputDevice_GetOutputDevices_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'FindAndListenAudioOutputDevice_GetOutputDevices_0001',
        '获取输出设备列表',
        6000,
        'Click get output devices list button',
        done
      );
    });

    /**
     * @tc.number FindAndListenAudioOutputDevice_GetPreferDevice_0001
     * @tc.name FindAndListenAudioOutputDevice_GetPreferDevice_0001
     * @tc.desc Click get preferred output device button to query system preferred audio output device
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('FindAndListenAudioOutputDevice_GetPreferDevice_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'FindAndListenAudioOutputDevice_GetPreferDevice_0001',
        '获取优先输出设备',
        6000,
        'Click get preferred output device button',
        done
      );
    });
  });
}