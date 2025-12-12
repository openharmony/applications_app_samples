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

const TAG = '[VoIPDemoForAudioRenderer]';
const DOMAIN = 0xF81A;
const BUNDLE = 'VoIPDemoForAudioRenderer_';
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

export default function VoIPDemoForAudioRendererTest() {
  describe('VoIPDemoForAudioRendererTest', () => {
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
     * @tc.number VoIPDemoForAudioRenderer_EnterPage_0001
     * @tc.name VoIPDemoForAudioRenderer_EnterPage_0001
     * @tc.desc Navigate to the VoIP audio renderer demo page from the main entry
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioRenderer_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioRenderer_EnterPage_0001',
        '使用AudioRenderer播放本端的通话声音页面',
        5000,
        'Navigate to VoIP audio renderer demo page',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioRenderer_Initialize_0001
     * @tc.name VoIPDemoForAudioRenderer_Initialize_0001
     * @tc.desc Click the Initialize button to create an AudioRenderer instance and prepare PCM file
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioRenderer_Initialize_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioRenderer_Initialize_0001',
        '初始化',
        6000,
        'Initialize AudioRenderer and prepare PCM file',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioRenderer_StartPlayback_0001
     * @tc.name VoIPDemoForAudioRenderer_StartPlayback_0001
     * @tc.desc Click the Start Playback button to begin audio rendering
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioRenderer_StartPlayback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioRenderer_StartPlayback_0001',
        '开始播放',
        3000,
        'Start audio playback via AudioRenderer',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioRenderer_PausePlayback_0001
     * @tc.name VoIPDemoForAudioRenderer_PausePlayback_0001
     * @tc.desc Click the Pause Playback button to pause ongoing audio rendering
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioRenderer_PausePlayback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioRenderer_PausePlayback_0001',
        '暂停播放',
        3000,
        'Pause ongoing audio playback',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioRenderer_StopPlayback_0001
     * @tc.name VoIPDemoForAudioRenderer_StopPlayback_0001
     * @tc.desc Click the Stop Playback button to stop rendering and close PCM file
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioRenderer_StopPlayback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioRenderer_StopPlayback_0001',
        '停止播放',
        4000,
        'Stop audio playback and close PCM file',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioRenderer_ReleaseResources_0001
     * @tc.name VoIPDemoForAudioRenderer_ReleaseResources_0001
     * @tc.desc Click the Release Resources button to destroy AudioRenderer and free system resources
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioRenderer_ReleaseResources_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioRenderer_ReleaseResources_0001',
        '释放资源',
        3000,
        'Release AudioRenderer and free system resources',
        done
      );
    });
  });
}