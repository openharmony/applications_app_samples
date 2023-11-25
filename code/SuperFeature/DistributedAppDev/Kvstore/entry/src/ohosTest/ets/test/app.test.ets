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
import { describe, it, expect } from '@ohos/hypium';
import { Component, Driver, ON } from '@ohos.UiTest';
import Logger from '../util/Logger';
import resourceManager from '@ohos.resourceManager';

const TAG: string = '[Sample_Kvstore]';
const BUNDLE: string = 'Kvstore_';

export default function appTest() {
  describe('appTest', () => {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async (done: Function) => {
      let driver: Driver = await Driver.create();
      Logger.info(TAG, BUNDLE + 'StartAbilityFunction_001');
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility({
        bundleName: "ohos.samples.kvstore",
        abilityName: "EntryAbility"
      });
      Logger.info(TAG, BUNDLE + 'StartAbilityFunction_001 end');
      await driver.delayMs(1000);
      done();
    })

    /**
     * 点击允许授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 1, async () => {
      Logger.info(TAG, BUNDLE + 'ClickAcceptFunction_001 begin');
      let driver: Driver = await Driver.create();
      let resourceManager: resourceManager.ResourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      await driver.delayMs(1500);
      Logger.info(TAG, BUNDLE + 'ClickAcceptFunction_001 clickAccept');
      // 点击允许
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      let btnAccept: Component = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      await btnAccept.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'ClickAcceptFunction_001 end');
    })

    /**
     * 检查分布式弹窗
     */
    it(BUNDLE + 'ClickRightBtnFunction_001', 2, async () => {
      Logger.info(TAG, BUNDLE + 'ClickRightBtnFunction_001 begin');
      let driver: Driver = await Driver.create();
      let resourceManager: resourceManager.ResourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'ClickRightBtnFunction_001 clickRightBtn');
      // 点击右上角按钮
      await driver.assertComponentExist(ON.id('rightBtn'));
      let rightBtn: Component = await driver.findComponent(ON.id('rightBtn'));
      await rightBtn.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'ClickRightBtnFunction_001 clickCancel');
      // 点击取消
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.check_device'))));
      await driver.assertComponentExist(ON.id('cancel'));
      let cancelBtn: Component = await driver.findComponent(ON.id('cancel'));
      await driver.delayMs(3000);
      await cancelBtn.click();
      Logger.info(TAG, BUNDLE + 'ClickRightBtnFunction_001 end');
    })

    /**
     * 点击添加和删除笔记
     */
    it(BUNDLE + 'HandleCardFunction_001', 3, async () => {
      Logger.info(TAG, BUNDLE + 'HandleCardFunction_001 begin');
      let driver: Driver = await Driver.create();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'HandleCardFunction_001 clickAddBtn');
      // 添加三次笔记
      await driver.assertComponentExist(ON.id('add'));
      for (let i: number = 0;i < 3; i++) {
        await driver.delayMs(500);
        let addBtn: Component = await driver.findComponent(ON.id('add'));
        await addBtn.click();
        await driver.delayMs(500);
      }
      Logger.info(TAG, BUNDLE + 'HandleCardFunction_001 delCard');
      // 删除笔记
      for (let i: number = 0;i < 3; i++) {
        await driver.assertComponentExist(ON.id('del' + i));
        await driver.delayMs(500);
        let delBtn: Component = await driver.findComponent(ON.id('del' + i));
        await delBtn.click();
        await driver.delayMs(500);
        let delBtnLater: Component = await driver.findComponent(ON.id('del' + i));
        await expect(delBtnLater).assertNull();
        await driver.delayMs(500);
      }
      Logger.info(TAG, BUNDLE + 'HandleCardFunction_001 end');
    })
  })
}