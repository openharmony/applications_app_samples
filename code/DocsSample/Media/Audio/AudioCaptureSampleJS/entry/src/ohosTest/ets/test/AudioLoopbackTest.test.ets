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

const TAG = '[Sample_AudioLoopback]';
const DOMAIN = 0xF812;
const BUNDLE = 'AudioLoopback_';
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

export default function AudioLoopbackTest() {
  describe('AudioLoopbackTest', () => {
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
     * @tc.number AudioCapturer_NavigateToLoopbackPage_0001
     * @tc.name AudioCapturer_NavigateToLoopbackPage_0001
     * @tc.desc Navigate to low-latency audio loopback implementation page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioCapturer_NavigateToLoopbackPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioCapturer_NavigateToLoopbackPage_0001',
        '跳转到实现低时延耳返页面',
        5000,
        'Navigate_To_LowLatency_Loopback_Page',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_CreateInstance_0001
     * @tc.name AudioLoopback_CreateInstance_0001
     * @tc.desc Create audio loopback instance
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_CreateInstance_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_CreateInstance_0001',
        '创建音频低时延耳返实例',
        5000,
        'Create_AudioLoopback_Instance',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_GrantPermission_0001
     * @tc.name AudioLoopback_GrantPermission_0001
     * @tc.desc Request microphone permission
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_GrantPermission_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_GrantPermission_0001',
        '允许',
        3000,
        'Grant_Microphone_Permission',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_SetVolume_0001
     * @tc.name AudioLoopback_SetVolume_0001
     * @tc.desc Set audio loopback volume
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_SetVolume_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_SetVolume_0001',
        '设置音频返听音量',
        2000,
        'Set_AudioLoopback_Volume',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_SetReverb_0001
     * @tc.name AudioLoopback_SetReverb_0001
     * @tc.desc Set audio loopback reverb preset
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_SetReverb_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_SetReverb_0001',
        '设置混响模式',
        2000,
        'Set_AudioLoopback_Reverb',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_SetEqualizer_0001
     * @tc.name AudioLoopback_SetEqualizer_0001
     * @tc.desc Set audio loopback equalizer preset
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_SetEqualizer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_SetEqualizer_0001',
        '设置均衡器类型',
        2000,
        'Set_AudioLoopback_Equalizer',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_GetStatus_0001
     * @tc.name AudioLoopback_GetStatus_0001
     * @tc.desc Get audio loopback status
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_GetStatus_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_GetStatus_0001',
        '查询返听状态',
        2000,
        'Get_AudioLoopback_Status',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_GetReverb_0001
     * @tc.name AudioLoopback_GetReverb_0001
     * @tc.desc Get current reverb preset
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_GetReverb_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_GetReverb_0001',
        '查询混响模式',
        2000,
        'Get_AudioLoopback_Reverb',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_GetEqualizer_0001
     * @tc.name AudioLoopback_GetEqualizer_0001
     * @tc.desc Get current equalizer preset
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_GetEqualizer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_GetEqualizer_0001',
        '查询均衡器类型',
        2000,
        'Get_AudioLoopback_Equalizer',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_Enable_0001
     * @tc.name AudioLoopback_Enable_0001
     * @tc.desc Enable audio loopback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_Enable_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_Enable_0001',
        '启用音频返听',
        3000,
        'Enable_AudioLoopback',
        done
      );
    })

    /**
     * @tc.number AudioLoopback_Disable_0001
     * @tc.name AudioLoopback_Disable_0001
     * @tc.desc Disable audio loopback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioLoopback_Disable_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioLoopback_Disable_0001',
        '禁用音频返听',
        3000,
        'Disable_AudioLoopback',
        done
      );
    })
  })
}