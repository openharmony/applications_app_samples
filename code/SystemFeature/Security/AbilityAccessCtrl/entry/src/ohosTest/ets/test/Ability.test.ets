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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import router from '@ohos.router';

const TAG = '[Sample_AbilityAccessCtrl]';
const DOMAIN = 0xF811;
const BUNDLE = 'AbilityAccessCtrl_';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function appTest() {
  describe('appTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let parameter = {
        bundleName: 'ohos.samples.abilityaccessctrl',
        abilityName: 'EntryAbility'
      };
      try {
        await abilityDelegatorRegistry.startAbility(parameter);
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code);
        expect(0).assertEqual(err.code);
        done();
      }
    })

    /**
     * 取消授权
     */
    it(BUNDLE + 'GetPermission_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetPermission_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('取消'));
      let cancelBtn = await driver.findComponent(ON.text('取消'));
      await cancelBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('checkPermission'));
      let checkPermissionBtn = await driver.findComponent(ON.id('checkPermission'));
      await checkPermissionBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('权限未被授予'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetPermission_001 end');
    })

    /**
     * 退出应用
     */
    it(BUNDLE + 'CloseApp_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseApp_001 begin');
      router.back();
      // 获取当前的ability
      let currentAbility = await abilityDelegatorRegistry.getCurrentTopAbility();
      // 获取当前ability的生命周期
      let state = abilityDelegatorRegistry.getAbilityState(currentAbility);
      console.info(`LSQ getAbilityState ${state}`);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseApp_001 end');
    })

    /**
     * 再次打开应用
     */
    it(BUNDLE + 'StartAbility_002', 0, async function (done) {
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text('AbilityAccessCtrl'));
      let camera = await driver.findComponent(ON.text('AbilityAccessCtrl'));
      await camera.click();
      driver.delayMs(1000);
      done();
    })

    /**
     * 授权
     */
    it(BUNDLE + 'GetPermission_002', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetPermission_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('确认'));
      let cancelBtn = await driver.findComponent(ON.text('确认'));
      await cancelBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('checkPermission'));
      let checkPermissionBtn = await driver.findComponent(ON.id('checkPermission'));
      await checkPermissionBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('权限已被授予'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetPermission_001 end');
    })
  })
}