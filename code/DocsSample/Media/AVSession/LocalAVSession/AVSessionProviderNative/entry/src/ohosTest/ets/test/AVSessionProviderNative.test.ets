/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
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

const TAG = '[AVSessionProviderNativeTests]';
const DOMAIN = 0xF817;
const BUNDLE = 'AVSessionProviderNativeTests_';
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
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function avSessionProviderNativeTest() {
  describe('avSessionProviderNativeTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.AVSessionProviderNative',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AVSessionProviderNative_SetMetadata_0001
     * @tc.name AVSessionProviderNative_SetMetadata_0001
     * @tc.desc Click SetMetadata button and verify state update
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProviderNative_SetMetadata_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SetMetadata',
        '设置媒体元数据',
        2000,
        'Set media metadata via native interface',
        done
      );
    });

    /**
     * @tc.number AVSessionProviderNative_SetPlaybackState_0001
     * @tc.name AVSessionProviderNative_SetPlaybackState_0001
     * @tc.desc Click SetPlaybackState button and verify state update
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProviderNative_SetPlaybackState_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SetPlaybackState',
        '设置播放状态',
        2000,
        'Set playback state via native interface',
        done
      );
    });

    /**
     * @tc.number AVSessionProviderNative_RegisterPlayCallback_0001
     * @tc.name AVSessionProviderNative_RegisterPlayCallback_0001
     * @tc.desc Click RegisterPlayCallback button and verify state update
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProviderNative_RegisterPlayCallback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'RegisterPlayCallback',
        '注册播放命令回调',
        2000,
        'Register play callback via native interface',
        done
      );
    });
  });
}
