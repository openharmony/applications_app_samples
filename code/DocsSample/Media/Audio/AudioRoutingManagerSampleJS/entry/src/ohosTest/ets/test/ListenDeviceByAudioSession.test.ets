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

const TAG = '[SetDefaultOutputDevice]';
const DOMAIN = 0xF818;
const BUNDLE = 'SetDefaultOutputDevice_';
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

export default function SetDefaultOutputDeviceTest() {
  describe('SetDefaultOutputDeviceTest', () => {
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
     * @tc.number SetDefaultOutputDevice_EnterPage_0001
     * @tc.name SetDefaultOutputDevice_EnterPage_0001
     * @tc.desc Navigate to set default output device page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SetDefaultOutputDevice_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SetDefaultOutputDevice_EnterPage_0001',
        '通过音频会话查询和监听音频输出设备页面',
        5000,
        'Navigate to set default output device page',
        done
      );
    });

    /**
     * @tc.number SetDefaultOutputDevice_SetToSpeaker_0001
     * @tc.name SetDefaultOutputDevice_SetToSpeaker_0001
     * @tc.desc Set default output device to speaker
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SetDefaultOutputDevice_SetToSpeaker_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SetDefaultOutputDevice_SetToSpeaker_0001',
        '设置为扬声器',
        3000,
        'Set default output device to SPEAKER',
        done
      );
    });

    /**
     * @tc.number SetDefaultOutputDevice_SetToDefault_0001
     * @tc.name SetDefaultOutputDevice_SetToDefault_0001
     * @tc.desc Reset default output device to system default
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SetDefaultOutputDevice_SetToDefault_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SetDefaultOutputDevice_SetToDefault_0001',
        '设置为默认输出',
        3000,
        'Reset default output device to system default',
        done
      );
    });

    /**
     * @tc.number SetDefaultOutputDevice_GetCurrent_0001
     * @tc.name SetDefaultOutputDevice_GetCurrent_0001
     * @tc.desc Get current default output device type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SetDefaultOutputDevice_GetCurrent_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SetDefaultOutputDevice_GetCurrent_0001',
        '获取当前默认输出',
        4000,
        'Get current default output device type',
        done
      );
    });
  });
}