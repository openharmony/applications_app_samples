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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

export default function certificateManagementTest() {
  describe('certificateManagementTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击按钮，安装、获取、使用、卸载证书
     */
    it('testCertificateManagement001', 0, async (done: Function) => {
      console.info('uitest: testCertificateManagement001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CertManagerGuidelines'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CertManagerGuidelines'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CertManagerGuidelines Success'));
      console.info('uitest: testCertificateManagement001 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，拉起证书管理界面
     */
    it('testCertificateManagement002', 0, async (done: Function) => {
      console.info('uitest: testCertificateManagement002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CertManagerDialogGuidelines'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CertManagerDialogGuidelines'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.dialog'))));
      console.info('uitest: testCertificateManagement002 end');
      done();
    })
  })
}