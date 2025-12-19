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

const TAG = '[Sample_AudioCaptureDemo]';
const DOMAIN = 0xF811;
const BUNDLE = 'AudioCaptureDemo_';
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

export default function AudioCaptureDemoTest() {
  describe('AudioCaptureDemoTest', () => {
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
     * @tc.number AudioCaptureDemo_CreateAudioCapturer_0001
     * @tc.name AudioCaptureDemo_CreateAudioCapturer_0001
     * @tc.desc Create audio capturer with new API
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCaptureDemo_CreateAudioCapturer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCaptureDemo_CreateAudioCapturer_0001',
        '创建录制音频流',
        3000,
        'Create_AudioCapturer_NewAPI',
        done
      );
    })

    /**
     * @tc.number AudioCaptureDemo_CreateLegacy1_0001
     * @tc.name AudioCaptureDemo_CreateLegacy1_0001
     * @tc.desc Create audio capturer with legacy method 1
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCaptureDemo_CreateLegacy1_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCaptureDemo_CreateLegacy1_0001',
        '创建录制流（使用空指针初始化）',
        3000,
        'Create_AudioCapturer_Legacy1',
        done
      );
    })

    /**
     * @tc.number AudioCaptureDemo_CreateLegacy2_0001
     * @tc.name AudioCaptureDemo_CreateLegacy2_0001
     * @tc.desc Create audio capturer with legacy method 2
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCaptureDemo_CreateLegacy2_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCaptureDemo_CreateLegacy2_0001',
        '创建录制流（使用清零结构体初始化）',
        3000,
        'Create_AudioCapturer_Legacy2',
        done
      );
    })

    /**
     * @tc.number AudioCaptureDemo_CreateLoopbackCapturer_0001
     * @tc.name AudioCaptureDemo_CreateLoopbackCapturer_0001
     * @tc.desc Create audio capturer for ear monitor (loopback recording)
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCaptureDemo_CreateLoopbackCapturer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCaptureDemo_CreateLoopbackCapturer_0001',
        '创建耳返录制流',
        3000,
        'Create_Loopback_Capturer',
        done
      );
    })

    /**
     * @tc.number AudioCaptureDemo_CreateLoopbackRenderer_0001
     * @tc.name AudioCaptureDemo_CreateLoopbackRenderer_0001
     * @tc.desc Create audio renderer for ear monitor (loopback playback)
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCaptureDemo_CreateLoopbackRenderer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCaptureDemo_CreateLoopbackRenderer_0001',
        '创建耳返播放流',
        3000,
        'Create_Loopback_Renderer',
        done
      );
    })
  })
}
