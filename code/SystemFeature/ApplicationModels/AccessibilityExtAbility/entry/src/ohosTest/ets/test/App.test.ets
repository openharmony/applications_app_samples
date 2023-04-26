/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

const TAG = 'AppTest';
const BUNDLE = 'AccessibilityExtAbility_';
let driver: Driver = Driver.create();
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
let ability: UIAbility;

export default function appTest() {
  describe('appTest', function () {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, `${BUNDLE}StartAbility start`);
      let want = {
        bundleName: 'com.samples.accessibilityextability',
        abilityName: 'MainAbility'
      }
      abilityDelegatorRegistry.startAbility(want, (err) => {
        Logger.info(TAG, `${BUNDLE}StartAbility get err ${JSON.stringify(err)}`);
        done();
      });
      ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      Logger.info(TAG, `${BUNDLE}StartAbility end`);
    });
    // 验证障碍服务的连接状态
    it(`${BUNDLE}CheckStatus_001`, 0, async () => {
      Logger.info(TAG, `${BUNDLE}CheckStatus_001 begin`);
      await driver.delayMs(5000);
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.accessibility_test'))));
      let cmd = 'accessibility enable -a AccessibilityExtAbility -b com.samples.accessibilityextability -c rgkt';
      abilityDelegatorRegistry.executeShellCommand(cmd, (err) => {
        if (err) {
          Logger.info(TAG, 'start Failed');
          expect().assertFail();
        }
      })
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.state_connected'))));
      Logger.info(TAG, `${BUNDLE}CheckStatus_001 end`);
    })
  })
}