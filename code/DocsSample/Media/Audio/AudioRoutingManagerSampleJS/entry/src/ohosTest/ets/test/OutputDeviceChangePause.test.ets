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

const TAG = '[AudioRendererSetDefaultOutputDevice]';
const DOMAIN = 0xF819;
const BUNDLE = 'AudioRendererSetDefaultOutputDevice_';
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

export default function AudioRendererSetDefaultOutputDeviceTest() {
  describe('AudioRendererSetDefaultOutputDeviceTest', () => {
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
     * @tc.number AudioRendererSetDefaultOutputDevice_EnterPage_0001
     * @tc.name AudioRendererSetDefaultOutputDevice_EnterPage_0001
     * @tc.desc Navigate to audio renderer output device routing page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererSetDefaultOutputDevice_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererSetDefaultOutputDevice_EnterPage_0001',
        '响应输出设备变更时合理暂停和实现音频输出设备路由切换页面',
        5000,
        'Navigate to audio renderer output device routing page',
        done
      );
    });

    /**
     * @tc.number AudioRendererSetDefaultOutputDevice_CreateRenderer_0001
     * @tc.name AudioRendererSetDefaultOutputDevice_CreateRenderer_0001
     * @tc.desc Create an AudioRenderer instance
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererSetDefaultOutputDevice_CreateRenderer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererSetDefaultOutputDevice_CreateRenderer_0001',
        '创建音频播放实例',
        4000,
        'Create an AudioRenderer instance',
        done
      );
    });

    /**
     * @tc.number AudioRendererSetDefaultOutputDevice_SetToSpeaker_0001
     * @tc.name AudioRendererSetDefaultOutputDevice_SetToSpeaker_0001
     * @tc.desc Set AudioRenderer output device to built-in speaker
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererSetDefaultOutputDevice_SetToSpeaker_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererSetDefaultOutputDevice_SetToSpeaker_0001',
        '设置为本机扬声器',
        3000,
        'Set AudioRenderer output device to built-in speaker',
        done
      );
    });

    /**
     * @tc.number AudioRendererSetDefaultOutputDevice_SetToDefault_0001
     * @tc.name AudioRendererSetDefaultOutputDevice_SetToDefault_0001
     * @tc.desc Reset AudioRenderer output device to system default
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererSetDefaultOutputDevice_SetToDefault_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererSetDefaultOutputDevice_SetToDefault_0001',
        '设置为系统默认设备',
        3000,
        'Reset AudioRenderer output device to system default',
        done
      );
    });
  });
}