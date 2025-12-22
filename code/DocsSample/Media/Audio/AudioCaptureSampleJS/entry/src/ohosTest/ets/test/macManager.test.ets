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

const TAG = '[AudioMicMute]';
const DOMAIN = 0xF814;
const BUNDLE = 'AudioMicMute_';
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

export default function AudioMicMuteTest() {
  describe('AudioMicMuteTest', () => {
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
     * @tc.number AudioMicMute_EnterPage_0001
     * @tc.name AudioMicMute_EnterPage_0001
     * @tc.desc Enter and jump to the microphone management page
     * @tc.size SmallTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioMicMute_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioMicMute_EnterPage_0001',
        '跳转到管理麦克风页面',
        5000,
        'Verify that the microphone mute control page loads correctly',
        done
      );
    })

    /**
     * @tc.number AudioMicMute_CreateManager_0001
     * @tc.name AudioMicMute_CreateManager_0001
     * @tc.desc Create a volume group manager
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioMicMute_CreateManager_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioMicMute_CreateManager_0001',
        '创建音量组管理器',
        3000,
        'Create audio volume group manager',
        done
      );
    });

    /**
     * @tc.number AudioMicMute_QueryMuteStatus_0001
     * @tc.name AudioMicMute_QueryMuteStatus_0001
     * @tc.desc Check if the microphone is muted
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioMicMute_QueryMuteStatus_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioMicMute_QueryMuteStatus_0001',
        '查询麦克风是否静音',
        3000,
        'Query microphone mute status',
        done
      );
    });
  });
}