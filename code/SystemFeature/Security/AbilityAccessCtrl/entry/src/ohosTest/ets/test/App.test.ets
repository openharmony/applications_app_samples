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

const TAG = '[Sample_AbilityAccessCtrl]';
const DOMAIN = 0xF811;
const BUNDLE = 'AbilityAccessCtrl_';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text
}

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.abilityaccessctrl',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code);
        expect(0).assertEqual(err.code)
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      }
    })

    /**
     * 取消授权
     */
    it(BUNDLE + 'CancelPermissionFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermissionFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击取消
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.cancel'))));
      let cancelBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.cancel'))));
      await cancelBtn.click();
      await driver.delayMs(1000);
      // 点击检测权限
      await driver.assertComponentExist(ON.id('checkPermission'));
      let checkPermissionBtn = await driver.findComponent(ON.id('checkPermission'));
      await checkPermissionBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermissionFunction_001 end');
    })

    /**
     * 退出应用,再进入应用授权
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 退出应用到桌面
      await driver.pressBack();
      // 进入应用
      await driver.assertComponentExist(ON.text('AbilityAccessCtrl'));
      let app = await driver.findComponent(ON.text('AbilityAccessCtrl'));
      await app.click();
      await driver.delayMs(1000);
      // 点击确认
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm'))));
      let confirmBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm'))));
      await confirmBtn.click();
      await driver.delayMs(2000);
      // 点击检测权限
      await driver.assertComponentExist(ON.id('checkPermission'));
      let checkPermissionBtn = await driver.findComponent(ON.id('checkPermission'));
      await checkPermissionBtn.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })
  })
}