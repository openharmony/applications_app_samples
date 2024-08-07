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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[MdmSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'EnterpriseAdminAbility_';
const BUNDLE_NAME = 'com.example.mdmsample';
const ABILITY_NAME = 'EntryAbility';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: BUNDLE_NAME,
          abilityName: ABILITY_NAME
        });
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    });
    it(BUNDLE + 'onEnableAdmin', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onEnableAdmin begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onEnableAdmin clickEnableAdmin');
      await driver.assertComponentExist(ON.id('enable_admin_id'));
      let enableAdminBtn = await driver.findComponent(ON.id('enable_admin_id'));
      await driver.delayMs(1000);
      await enableAdminBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_active'))));

    });
    it(BUNDLE + 'onDisableAdmin', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onDisableAdmin begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onDisableAdmin clickDisableAdmin');
      await driver.assertComponentExist(ON.id('disable_admin_id'));
      let disableAdminBtn = await driver.findComponent(ON.id('disable_admin_id'));
      await driver.delayMs(1000);
      await disableAdminBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_active'))));
    });
    it(BUNDLE + 'onEnableWifi', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onEnableWifi begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onEnableWifi clickEnableWifi');
      await driver.assertComponentExist(ON.id('enable_wifi_id'));
      let enableWifiBtn = await driver.findComponent(ON.id('enable_wifi_id'));
      await driver.delayMs(1000);
      await enableWifiBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.enabled'))));
    });
    it(BUNDLE + 'onDisableWifi', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onDisableWifi begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onDisableWifi clickDisableWifi');
      await driver.assertComponentExist(ON.id('disable_wifi_id'));
      let disableWifiBtn = await driver.findComponent(ON.id('disable_wifi_id'));
      await driver.delayMs(1000);
      await disableWifiBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.enabled'))));
    });
    it(BUNDLE + 'onRebootDevice', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onRebootDevice begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onRebootDevice clickRebootDevice');
      await driver.assertComponentExist(ON.id('reboot_device_id'));
      let rebootBtn = await driver.findComponent(ON.id('reboot_device_id'));
      await driver.delayMs(1000);
      await rebootBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.enabled'))));
    });
  })
}
