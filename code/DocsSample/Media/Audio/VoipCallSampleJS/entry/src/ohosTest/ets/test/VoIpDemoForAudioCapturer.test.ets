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

const TAG = '[VoIPDemoForAudioCapturer]';
const DOMAIN = 0xF81A;
const BUNDLE = 'VoIPDemoForAudioCapturer_';
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

export default function VoIPDemoForAudioCapturerTest() {
  describe('VoIPDemoForAudioCapturerTest', () => {
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
     * @tc.number VoIPDemoForAudioCapturer_EnterPage_0001
     * @tc.name VoIPDemoForAudioCapturer_EnterPage_0001
     * @tc.desc Navigate to VoIP audio capturer demo page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioCapturer_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioCapturer_EnterPage_0001',
        '使用AudioCapturer录制对端的通话声音页面',
        5000,
        'Navigate to VoIP audio capturer demo page',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioCapturer_Initialize_0001
     * @tc.name VoIPDemoForAudioCapturer_Initialize_0001
     * @tc.desc Click Initialize button to create AudioCapturer instance
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioCapturer_Initialize_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioCapturer_Initialize_0001',
        '初始化',
        6000,
        'Initialize AudioCapturer and request microphone permission',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioCapturer_RequestPermission_0001
     * @tc.name VoIPDemoForAudioCapturer_RequestPermission_0001
     * @tc.desc Click Request Permission button to trigger microphone permission dialog
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioCapturer_RequestPermission_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioCapturer_RequestPermission_0001',
        '允许',
        3000,
        'Click to request microphone permission before initialization',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioCapturer_StartRecording_0001
     * @tc.name VoIPDemoForAudioCapturer_StartRecording_0001
     * @tc.desc Click Start Recording button to begin audio capture
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioCapturer_StartRecording_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioCapturer_StartRecording_0001',
        '开始录制',
        3000,
        'Start audio recording via AudioCapturer',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioCapturer_StopRecording_0001
     * @tc.name VoIPDemoForAudioCapturer_StopRecording_0001
     * @tc.desc Click Stop Recording button to halt capture and close file
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioCapturer_StopRecording_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioCapturer_StopRecording_0001',
        '停止录制',
        4000,
        'Stop audio recording and finalize file write',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioCapturer_ReleaseResources_0001
     * @tc.name VoIPDemoForAudioCapturer_ReleaseResources_0001
     * @tc.desc Click Release Resources button to destroy AudioCapturer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioCapturer_ReleaseResources_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioCapturer_ReleaseResources_0001',
        '释放资源',
        3000,
        'Release AudioCapturer and free system resources',
        done
      );
    });
  });
}