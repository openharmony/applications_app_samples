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
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import Logger from '../util/Logger';
import Want from '@ohos.app.ability.Want';

const BUNDLE = 'DistributedDataGobang';
const TAG = '[Sample_DistributedDataGobang]';

export default function appTest() {
  describe('appTest', () => {
    /**
     * 拉起Ability
     */
    it(BUNDLE + '_startAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start');
      let want: Want = {
        bundleName: 'ohos.samples.distributeddatagobang',
        abilityName: 'MainAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      Logger.info(TAG, BUNDLE + '_startAbility end');
      done();
    });

    /**
     * 获取权限
     */
    it(BUNDLE + '_IndexPage_btnAgree', 1, async () => {
      Logger.info(TAG, BUNDLE + "_IndexPage_btnAgree start");
      let driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      await driver.delayMs(3000);
      // 相机权限点击允许
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      let btnCameraAgree = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      await btnCameraAgree.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + "_IndexPage_btnAgree end");
    });

    /**
     * 检查Title是否正常显示
     */
    it(BUNDLE + '_TitleBar', 2, async () => {
      Logger.info(TAG, BUNDLE + "_TitleBar start");
      let driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      // 检查返回键是否显示
      await driver.assertComponentExist(ON.id('ic_back'));
      // 检查hop键是否显示
      await driver.assertComponentExist(ON.id('ic_hop'));
      let hopBtn = await driver.findComponent(ON.id('ic_hop'));
      await hopBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.select_device'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.cancel'))));
      let cancelBtn = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.cancel'))));
      await cancelBtn.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + "_TitleBar end");
    });

    /**
     * 检查下方按键是否显示正常
     */
    it(BUNDLE + '_CheckBtn', 3, async () => {
      Logger.info(TAG, BUNDLE + "_CheckBtn start");
      let driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      // 检查重开键是否显示
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.restart'))));
      await driver.delayMs(1000);
      // 检查悔棋键是否显示
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.repentance_chess'))));
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + "_CheckBtn end");
    })
  })
}
