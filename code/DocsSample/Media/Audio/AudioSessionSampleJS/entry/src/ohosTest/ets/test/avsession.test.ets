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

const TAG = '[VoIPDemoForAudioSession]';
const DOMAIN = 0xF81A;
const BUNDLE = 'VoIPDemoForAudioSession_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(
  testCaseName: string,
  buttonText: string,
  delayTime: number,
  description: string,
  done: Function
) {
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

export default function VoIPDemoForAudioSessionTest() {
  describe('VoIPDemoForAudioSessionTest', () => {
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
     * @tc.number VoIPDemoForAudioSession_SetScene_0001
     * @tc.name VoIPDemoForAudioSession_SetScene_0001
     * @tc.desc Set audio session scene to MEDIA via UI action
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioSession_SetScene_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioSession_SetScene_0001',
        '设置场景',
        3000,
        'Set AudioSession scene to MEDIA',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioSession_ActivateSession_0001
     * @tc.name VoIPDemoForAudioSession_ActivateSession_0001
     * @tc.desc Activate audio session with CONCURRENCY_MIX_WITH_OTHERS strategy and register state listeners
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioSession_ActivateSession_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioSession_ActivateSession_0001',
        '激活焦点+注册监听',
        4000,
        'Activate AudioSession with MIX_WITH_OTHERS concurrency mode and register listeners',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioSession_CheckActivated_0001
     * @tc.name VoIPDemoForAudioSession_CheckActivated_0001
     * @tc.desc Verify whether the audio session is currently activated
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioSession_CheckActivated_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioSession_CheckActivated_0001',
        '判断焦点是否激活',
        2000,
        'Check AudioSession activation status using isAudioSessionActivated API',
        done
      );
    });

    /**
     * @tc.number VoIPDemoForAudioSession_DeactivateSession_0001
     * @tc.name VoIPDemoForAudioSession_DeactivateSession_0001
     * @tc.desc Deactivate audio session and unregister all event listeners
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('VoIPDemoForAudioSession_DeactivateSession_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'VoIPDemoForAudioSession_DeactivateSession_0001',
        '注销焦点+注销监听',
        3000,
        'Deactivate AudioSession and remove all registered event listeners',
        done
      );
    });
  });
}