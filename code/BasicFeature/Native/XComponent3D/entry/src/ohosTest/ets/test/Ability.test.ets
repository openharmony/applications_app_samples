/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { it, beforeAll, afterAll, expect, describe } from '@ohos/hypium'
import { Driver, ON, } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import delegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import Logger from 'ets/util/Logger';

const TAG = '{Sample_AppXComponent3D]'
const BUNDLE_NAME = 'com.samples.xcomponent3d';
const ABILITY_NAME = 'EntryAbility';
const DOMAIN = '0xE629';
let ability: UIAbility | null = null;

interface wantType {
  bundleName: string;
  abilityName: string
}

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {

    beforeAll(async (startAbility: Function) => {
      let delegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      };
      delegator.startAbility(want, (err) => {
        Logger.info(TAG, `${BUNDLE_NAME} startAbility end err ${JSON.stringify(err)}`)
      });
      await driver.delayMs(5000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        ability = Ability;
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      });
      startAbility();
    })

    afterAll(async (lockAbilityTerminateSelf: Function) => {
      let abilityDelegator = delegatorRegistry.getAbilityDelegator();
      let pkillCmd = 'aa force-stop com.samples.xcomponent3d';
      abilityDelegator.executeShellCommand(pkillCmd, (err, data) => {
        console.log('Acts_CleanTempFiles pkillCmd err: '
          + JSON.stringify(err) + ' data: ' + JSON.stringify(data));
      })
      lockAbilityTerminateSelf()
    })

    /**
     * @tc.name: StartAbility_Click_001
     * @tc.desc: 点击界面上的DrawTransform按钮
     * @tc.type: Function
     * @tc.require: 点击成功， 并切换到矩形旋转界面
     * @tc.level: Level 1
     * @tc.size: MediumTest
     * @tc.number: ActsAbilityTest_StartAbility_Click_001
     */
    it('ActsAbilityTest_StartAbility_Click_001', 0, async (done: Function) => {

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawTransform'));
        let button = await driver.findComponent(ON.id('DrawTransform'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        Logger.error(DOMAIN, TAG, '%{public}s', `click_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
    });

    /**
     * @tc.name: StartAbility_Click_002
     * @tc.desc: 点击界面上的DrawCube按钮
     * @tc.type: Function
     * @tc.require: 点击成功， 并切换到立体矩形界面
     * @tc.level: Level 1
     * @tc.size: MediumTest
     * @tc.number: ActsAbilityTest_StartAbility_Click_002
     */
    it('ActsAbilityTest_StartAbility_Click_002', 0, async (done: Function) => {

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawCube'));
        let button = await driver.findComponent(ON.id('DrawCube'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        Logger.error(DOMAIN, TAG, '%{public}s', `click_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
    });

    /**
     * @tc.name: StartAbility_Click_003
     * @tc.desc: 点击界面上的DrawTransform按钮
     * @tc.type: Function
     * @tc.require: 点击成功， 并切换到矩形旋转界面
     * @tc.level: Level 1
     * @tc.size: MediumTest
     * @tc.number: ActsAbilityTest_StartAbility_Click_003
     */
    it('ActsAbilityTest_StartAbility_Click_003', 0, async (done: Function) => {

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawTransform'));
        let button = await driver.findComponent(ON.id('DrawTransform'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        Logger.error(DOMAIN, TAG, '%{public}s', `click_003 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
    });
  });
}
