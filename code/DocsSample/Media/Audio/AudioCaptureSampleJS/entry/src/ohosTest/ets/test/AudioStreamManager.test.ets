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

const TAG = '[AudioCapturerInfo]';
const DOMAIN = 0xF813;
const BUNDLE = 'AudioCapturerInfo_';
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
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function AudioStreamManagerTest() {
  describe('AudioStreamManagerTest', () => {
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
     * @tc.number AudioCapturerInfo_EnterPage_0001
     * @tc.name AudioCapturerInfo_EnterPage_0001
     * @tc.desc Enter and jump to the audio recording stream management page
     * @tc.size SmallTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturerInfo_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturerInfo_EnterPage_0001',
        '跳转到音频录制流管理页面',
        5000,
        'Verify that the audio capturer info page loads correctly',
        done
      );
    })

    /**
     * @tc.number AudioCapturerInfo_GetCurrentInfo_0001
     * @tc.name AudioCapturerInfo_GetCurrentInfo_0001
     * @tc.desc Retrieve current recording stream information
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturerInfo_GetCurrentInfo_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturerInfo_GetCurrentInfo_0001',
        '获取当前录制流信息',
        6000,
        'Click get current audio capturer info button',
        done
      );
    });
  });
}