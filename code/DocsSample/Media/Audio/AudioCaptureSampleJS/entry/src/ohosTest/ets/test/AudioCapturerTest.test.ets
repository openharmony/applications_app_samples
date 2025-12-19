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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_AudioCapturer]';
const DOMAIN = 0xF811;
const BUNDLE = 'AudioCapturer_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime);
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function AudioCapturerTest() {
  describe('AudioCapturerTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      });
    })
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AudioCapturer_EnterPage_0001
     * @tc.name AudioCapturer_EnterPage_0001
     * @tc.desc Enter audio capture page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_EnterPage_0001',
        '跳转到开发音频录制功能页面',
        8000,
        'Enter_AudioCapture_Page',
        done
      );
    })

    /**
     * @tc.number AudioCapturer_Init_0001
     * @tc.name AudioCapturer_Init_0001
     * @tc.desc Initialize audio capturer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_Init_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_Init_0001',
        '初始化',
        3000,
        'AudioCapturer_Init',
        done
      );
    })

    /**
     * @tc.number AudioCapturer_GetAccess_0001
     * @tc.name AudioCapturer_GetAccess_0001
     * @tc.desc Request microphone permission
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_GetAccess_0001',
        '允许',
        5000,
        'GetAccess_0001',
        done
      );
    })

    /**
     * @tc.number AudioCapturer_Start_0001
     * @tc.name AudioCapturer_Start_0001
     * @tc.desc Start audio recording
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_Start_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_Start_0001',
        '开始录制',
        3000,
        'AudioCapturer_Start',
        done
      );
    })

    /**
     * @tc.number AudioCapturer_ViewState_0001
     * @tc.name AudioCapturer_ViewState_0001
     * @tc.desc View audio capturer state
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_ViewState_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_ViewState_0001',
        '查看状态',
        2000,
        'AudioCapturer_ViewState',
        done
      );
    })

    /**
     * @tc.number AudioCapturer_Stop_0001
     * @tc.name AudioCapturer_Stop_0001
     * @tc.desc Stop audio recording
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_Stop_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_Stop_0001',
        '停止录制',
        2000,
        'AudioCapturer_Stop',
        done
      );
    })

    /**
     * @tc.number AudioCapturer_Release_0001
     * @tc.name AudioCapturer_Release_0001
     * @tc.desc Release audio capturer resources
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_Release_0001',
        '释放资源',
        2000,
        'AudioCapturer_Release',
        done
      );
    })
  })
}