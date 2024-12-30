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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@kit.TestKit';
import Logger from '../utils/Logger';

const BUNDLE = 'RequestUserAuthorization_';
const DELAY_TIME = 1000;
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let manage = abilityDelegator.getAppContext().resourceManager;

async function getResourceString(resource: Resource): Promise<string> {
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  let driver = Driver.create();
  describe('RequestUserAuthorizationTest', () => {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.requestuserauthorization',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (err) {
        Logger.info(BUNDLE + 'StartAbility_001,err.code:' + err.code);
        expect(0).assertEqual(err.code)
        done();
      }
      Logger.info(BUNDLE + 'StartAbility_001 end');
    })
    /**
     * 检测当前应用权限
     */
    it(BUNDLE + 'CheckPermissionFunction_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'CheckPermissionFunction_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击检测权限
      let str = await getResourceString($r('app.string.check_permission'));
      await driver.assertComponentExist(ON.text(str));
      let checkBtn = await driver.findComponent(ON.text(str));
      await checkBtn.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'CheckPermissionFunction_001 end');
      done();
    })
    /**
     * 在Page中申请权限并取消
     */
    it(BUNDLE + 'CancelPermissionInPageFunction_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'CancelPermissionInPageFunction_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击在Page中申请权限
      let str = await getResourceString($r('app.string.req_permission_page'));
      await driver.assertComponentExist(ON.text(str));
      let reqPermissionInUI = await driver.findComponent(ON.text(str));
      await reqPermissionInUI.click();
      await driver.delayMs(DELAY_TIME);
      // 点击取消授权
      str = await getResourceString($r('app.string.cancel'));
      await driver.assertComponentExist(ON.text(str));
      let cancelBtn = await driver.findComponent(ON.text(str));
      await cancelBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 返回主页
      str = await getResourceString($r('app.string.return_main'));
      await driver.assertComponentExist(ON.text(str));
      let backBtn = await driver.findComponent(ON.text(str));
      await backBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 点击检测权限
      str = await getResourceString($r('app.string.check_permission'));
      await driver.assertComponentExist(ON.text(str));
      let checkPermissionBtn = await driver.findComponent(ON.text(str));
      await checkPermissionBtn.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'CancelPermissionInPageFunction_001 end');
      done();
    })
    /**
     * 在UIAbility中取消申请权限并拉起二次授权
     */
    it(BUNDLE + 'CancelPermissionInUIAbilityFunction_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'CancelPermissionInUIAbilityFunction_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击在UIAbility中申请权限
      let str = await getResourceString($r('app.string.req_permission_ability'));
      await driver.assertComponentExist(ON.text(str));
      let reqPermissionInAbility = await driver.findComponent(ON.text(str));
      await reqPermissionInAbility.click();
      await driver.delayMs(DELAY_TIME);
      // 点击取消
      str = await getResourceString($r('app.string.cancel'));
      await driver.assertComponentExist(ON.text(str));
      let cancelBtn = await driver.findComponent(ON.text(str));
      await cancelBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 点击仅使用期间允许
      str = await getResourceString($r('app.string.allowed_only_during_use'));
      await driver.assertComponentExist(ON.text(str));
      let agreeBtn = await driver.findComponent(ON.text(str));
      await agreeBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 点击导航到EntryAbility
      str = await getResourceString($r('app.string.return_entryability'));
      await driver.assertComponentExist(ON.text(str));
      let backBtn = await driver.findComponent(ON.text(str));
      await backBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 点击检测权限
      str = await getResourceString($r('app.string.check_permission'));
      await driver.assertComponentExist(ON.text(str));
      let checkPermissionBtn = await driver.findComponent(ON.text(str));
      await checkPermissionBtn.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'CancelPermissionInUIAbilityFunction_001 end');
      done();
    })

    /**
     * 在UIAbility中同意授权
     */
    it(BUNDLE + 'AllowPermissionInUIAbilityFunction_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'AllowPermissionInUIAbilityFunction_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击在UIAbility中申请权限
      let str = await getResourceString($r('app.string.req_permission_ability'));
      await driver.assertComponentExist(ON.text(str));
      let reqPermissionInAbility = await driver.findComponent(ON.text(str));
      await reqPermissionInAbility.click();
      await driver.delayMs(DELAY_TIME);
      // 点击仅使用期间允许
      str = await getResourceString($r('app.string.allowed_only_during_use'));
      await driver.assertComponentExist(ON.text(str));
      let agreeBtn = await driver.findComponent(ON.text(str));
      await agreeBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 点击导航到EntryAbility
      str = await getResourceString($r('app.string.return_entryability'));
      await driver.assertComponentExist(ON.text(str));
      let backBtn = await driver.findComponent(ON.text(str));
      await backBtn.click();
      await driver.delayMs(DELAY_TIME);
      // 点击检测权限
      str = await getResourceString($r('app.string.check_permission'));
      await driver.assertComponentExist(ON.text(str));
      let checkPermissionBtn = await driver.findComponent(ON.text(str));
      await checkPermissionBtn.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'AllowPermissionInUIAbilityFunction_001 end');
      done();
    })
  })
}