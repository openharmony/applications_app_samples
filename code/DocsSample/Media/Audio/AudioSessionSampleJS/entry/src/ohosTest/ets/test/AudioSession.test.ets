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

const TAG = '[AudioSessionTest]';
const DOMAIN = 0xF81A;
const BUNDLE = 'AudioSession';
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

export default function AudioSessionTest() {
  describe('AudioSessionTest', () => {
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
     * @tc.number AudioSession_Test_0001
     * @tc.name AudioSession_Test_0001
     * @tc.desc Init audioRenderer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0001',
        '初始化audioRenderer',
        3000,
        'Init audioRenderer success',
        done
      );
    });

    /**
     * @tc.number AudioSession_Test_0002
     * @tc.name AudioSession_Test_0002
     * @tc.desc Register audioInterruptCallback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0002',
        '监听audioRenderer焦点变化',
        3000,
        'Register audioInterruptCallback success',
        done
      );
    });

    /**
     * @tc.number AudioSession_Test_0003
     * @tc.name AudioSession_Test_0003
     * @tc.desc Activate audioSession V1
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0003',
        '使用音频会话修改焦点策略',
        4000,
        'Activate audioSession V1 success',
        done
      );
    });

    /**
     * @tc.number AudioSession_Test_0004
     * @tc.name AudioSession_Test_0004
     * @tc.desc Activate audioSession V2
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0004',
        '使用音频会话申请焦点策略',
        2000,
        'Activate audioSession V2 success',
        done
      );
    });

    /**
     * @tc.number AudioSession_Test_0005
     * @tc.name AudioSession_Test_0005
     * @tc.desc Start audioRenderer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0005', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0005',
        '开始播放',
        3000,
        'Start audioRenderer success',
        done
      );
    });

    /**
     * @tc.number AudioSession_Test_0006
     * @tc.name AudioSession_Test_0006
     * @tc.desc Stop audioRenderer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0006', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0006',
        '停止播放',
        3000,
        'Stop audioRenderer success',
        done
      );
    });

    /**
     * @tc.number AudioSession_Test_0007
     * @tc.name AudioSession_Test_0007
     * @tc.desc Deactivate audioSession
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Test_0007', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Test_0007',
        '停用音频会话',
        3000,
        'Deactivate audioSession success',
        done
      );
    });
  });
}