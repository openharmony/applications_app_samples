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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import deviceInfo from '@ohos.deviceInfo';
import Logger from '../util/Logger';

const BUNDLE = 'Brower_';
const TAG = 'BrowerAppTestPage';
const TIME_OUT = 1000;
let driver: Driver = Driver.create();

async function targetSpecialPage() {
  // 输入百度网址
  await driver.assertComponentExist(ON.id('inputUrl'));
  let inputUrl: Component = await driver.findComponent(ON.id('inputUrl'));
  await inputUrl.inputText('www.baidu.com');
  await driver.delayMs(1000);
  // 点击submit进入百度网页
  await driver.assertComponentExist(ON.id('actionButton0'));
  let targetBtn: Component = await driver.findComponent(ON.id('actionButton0'));
  await targetBtn.click();
  await driver.delayMs(3000);
  // 验证是否跳转成功
  let currentUrl = await inputUrl.getText();
  if (!currentUrl) {
    Logger.info(TAG, 'Target failed');
    expect().assertFail();
    return;
  }
}

export default function appTest() {
  describe('appTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start');
      let want = {
        bundleName: 'ohos.samples.browser1',
        abilityName: 'MainAbility'
      };
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        done();
        Logger.info(TAG, '_startAbility end');
      });
      Logger.info(TAG, 'StartAbility end');
    });
    /**
     * 验证输入网址跳转
     */
    it(`${BUNDLE}TargetSepcialUrl_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'TargetSepcialUrl_001 begin');
      await driver.delayMs(1000);
      await targetSpecialPage();
      Logger.info(TAG, BUNDLE + 'TargetSepcialUrl_001 end');
    });
    /**
     * 验证向左向右跳转
     */
    it(`${BUNDLE}TargetLeftAndRight_001`, 0, async () => {
      Logger.info(TAG, `${BUNDLE}TargetLeftAndRight_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inputUrl'));
      let inputUrl: Component = await driver.findComponent(ON.id('inputUrl'));
      await driver.delayMs(1000);
      let currentUrl = await inputUrl.getText();
      // 验证向左跳转
      await driver.assertComponentExist(ON.id('navigationButton0'));
      let backBtn: Component = await driver.findComponent(ON.id('navigationButton0'));
      await backBtn.click();
      await driver.delayMs(3000);
      currentUrl = await inputUrl.getText();
      if (currentUrl) {
        Logger.info(TAG, 'Target left failed');
        expect().assertFail();
        return;
      }
      // 验证向右
      await driver.assertComponentExist(ON.id('navigationButton1'));
      let forward: Component = await driver.findComponent(ON.id('navigationButton1'));
      await forward.click();
      await driver.delayMs(3000);
      currentUrl = await inputUrl.getText();
      if (!currentUrl) {
        Logger.info(TAG, 'Target right failed');
        expect().assertFail();
        return;
      }
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}TargetLeftAndRight_001 end`);
    });
    /**
     * 验证新增网页
     */
    it(`${BUNDLE}AddWebPage_001`, 0, async () => {
      Logger.info(TAG, `${BUNDLE}AddWebPage_001 begin`);
      try {
        let deviceType = deviceInfo.deviceType;
        Logger.info(TAG, `deviceType: ${deviceType}`)
        if (deviceType === 'default') {
          Logger.info(TAG, 'This device does not support adding webpage');
          return;
        }
      } catch (error) {
        Logger.error(TAG, `Get device type failed error: ${JSON.stringify(error)}`);
      }
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inputUrl'));
      let inputUrl: Component = await driver.findComponent(ON.id('inputUrl'));
      await driver.delayMs(1000);
      let currentUrl = await inputUrl.getText();
      // 返回首页
      await driver.assertComponentExist(ON.id('navigationButton3'));
      let backHome: Component = await driver.findComponent(ON.id('navigationButton3'));
      await backHome.click();
      await driver.delayMs(3000);
      currentUrl = await inputUrl.getText();
      if (currentUrl) {
        Logger.info(TAG, 'Back home failed');
        expect().assertFail();
        return;
      }
      // 新增网页
      await driver.assertComponentExist(ON.id('actionButton1'));
      let addWebPage: Component = await driver.findComponent(ON.id('actionButton1'));
      await addWebPage.click();
      await driver.delayMs(3000);
      // 通过取消按钮的数量来验证是否新增成功
      await driver.assertComponentExist(ON.id('cancelBtn'));
      let cancelBtns: Array<Component> = await driver.findComponents(ON.id('cancelBtn'));
      if (cancelBtns.length <= 1) {
        Logger.info(TAG, 'Adding webpage failed');
        expect().assertFail();
        return;
      }
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}AddWebPage_001 end`);
    });
  });
}