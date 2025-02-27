/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Logger from '../../../main/ets/utils/Logger';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@kit.TestKit';

const TAG: string = '[Sample_WindowStartIcon]';
const BUNDLE = 'WindowStartIcon_';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE}StartAbility_001 begin`);
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.windowstarticon',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (exception) {
        Logger.info(`StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info('StartAbility_001 end');
      done();
    })

    /**
     * 判断广告是否正常显示
     */
    it("AdvertingShowTest", 0, async (done: Function) => {
      Logger.info('AdvertingShowTest begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("跳过"));
      await driver.delayMs(1000);
      Logger.info('AdvertingShowTest end');
      done();
    })
  })
}