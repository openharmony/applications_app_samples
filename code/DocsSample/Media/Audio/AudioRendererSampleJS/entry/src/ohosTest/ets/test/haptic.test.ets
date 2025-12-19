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

const TAG = '[AudioHapticDemoTest]';
const DOMAIN = 0xF81B;
const BUNDLE = 'AudioHapticDemo_';
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

export default function AudioHapticDemoTest() {
  describe('AudioHapticDemoTest', () => {
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
     * @tc.number AudioHapticDemo_NavigateToHapticPage_0001
     * @tc.name AudioHapticDemo_NavigateToHapticPage_0001
     * @tc.desc Navigate to the Haptic page via button click
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioHapticDemo_NavigateToHapticPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioHapticDemo_NavigateToHapticPage_0001',
        '音振协同播放页面',
        2000,
        'Navigate to Haptic page (pages/Haptic) by clicking the corresponding button',
        done
      );
    });

    /**
     * @tc.number AudioHapticDemo_RegisterSource_0001
     * @tc.name AudioHapticDemo_RegisterSource_0001
     * @tc.desc Register audio and haptic resources using URI-based registration method
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioHapticDemo_RegisterSource_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioHapticDemo_RegisterSource_0001',
        '使用注册源注册',
        3000,
        'Register audio-haptic source via registerSource API',
        done
      );
    });

    /**
     * @tc.number AudioHapticDemo_RegisterFromFd_0001
     * @tc.name AudioHapticDemo_RegisterFromFd_0001
     * @tc.desc Register audio and haptic resources using file descriptor from rawfile
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioHapticDemo_RegisterFromFd_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioHapticDemo_RegisterFromFd_0001',
        '使用描述符注册',
        4000,
        'Register audio-haptic source via registerSourceFromFd using rawfile descriptors',
        done
      );
    });

    /**
     * @tc.number AudioHapticDemo_StartPlayback_0001
     * @tc.name AudioHapticDemo_StartPlayback_0001
     * @tc.desc Start synchronized audio and haptic playback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioHapticDemo_StartPlayback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioHapticDemo_StartPlayback_0001',
        '音振协同播放开始',
        2000,
        'Start synchronized audio and haptic playback',
        done
      );
    });

    /**
     * @tc.number AudioHapticDemo_StopPlayback_0001
     * @tc.name AudioHapticDemo_StopPlayback_0001
     * @tc.desc Stop ongoing audio and haptic playback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioHapticDemo_StopPlayback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioHapticDemo_StopPlayback_0001',
        '音振协同播放停止',
        2000,
        'Stop ongoing synchronized audio and haptic playback',
        done
      );
    });

    /**
     * @tc.number AudioHapticDemo_ReleaseResources_0001
     * @tc.name AudioHapticDemo_ReleaseResources_0001
     * @tc.desc Release audio haptic player and unregister source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioHapticDemo_ReleaseResources_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioHapticDemo_ReleaseResources_0001',
        '音振协同播放释放',
        3000,
        'Release audio haptic player and unregister the registered source',
        done
      );
    });
  });
}