
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

const TAG = '[Sample_AudioSession]';
const DOMAIN = 0xF811;
const BUNDLE = 'AudioSession_';
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

export default function AudioSessionTest() {
  describe('AudioSessionTest', () => {
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
     * @tc.number AudioSession_Active_0001
     * @tc.name AudioSession_Active_0001
     * @tc.desc Activate audio session with scene setting, focus activation and listener registration
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Active_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Active_0001',
        '设置场景+激活焦点+注册监听',
        3000,
        'AudioSession_Active',
        done
      );
    })

    /**
     * @tc.number AudioSession_Deactive_0001
     * @tc.name AudioSession_Deactive_0001
     * @tc.desc Deactivate audio session with focus deactivation and listener unregistration
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioSession_Deactive_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioSession_Deactive_0001',
        '注销焦点+注销监听',
        3000,
        'AudioSession_Deactive',
        done
      );
    })
  })
}
