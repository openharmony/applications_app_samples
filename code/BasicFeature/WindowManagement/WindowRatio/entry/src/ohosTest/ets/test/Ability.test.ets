/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import Logger from '../utils/Logger';

const TAG = '[Sample_WindowManager_NewApplication]';
const BUNDLE = 'WindowManager_NewApplication_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.windowratio',
          abilityName: 'MainAbility'
        });
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
      await driver.delayMs(1000);
      done();
    })

    /**
     * 设置悬浮窗大小
     */
    it(BUNDLE + 'SetWindowRatio_001', 1, async () => {
      Logger.info(TAG, BUNDLE + 'OpenVideoPage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('selectRatio'));
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('changeRatio'));
      let changeRatio = await driver.findComponent(ON.id('changeRatio'));
      await changeRatio.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'SetWindowRatio_001 end');
    })
  })
}