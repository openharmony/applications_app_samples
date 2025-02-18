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

export default function convertSymmetricKeyBinaryFormatArkTSTest() {
  describe('convertSymmetricKeyBinaryFormatArkTSTest', () => {
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
     * 点击按钮，指定二进制数据转换对称密钥(3DES callback方式)
     */
    it('testConvertSymmetricKeyBinaryFormatArkTS001', 0, async () => {
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('3DES Callback'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call 3DES Callback'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('3DES Callback Success'));
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换对称密钥(3DES 同步方式)
     */
    it('testConvertSymmetricKeyBinaryFormatArkTS002', 0, async () => {
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('3DES Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call 3DES Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('3DES Sync Success'));
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换对称密钥(HMAC await方式)
     */
    it('testConvertSymmetricKeyBinaryFormatArkTS003', 0, async () => {
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('HMAC Await'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call HMAC Await'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('HMAC Await Success'));
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换对称密钥(HMAC 同步方式)
     */
    it('testConvertSymmetricKeyBinaryFormatArkTS004', 0, async () => {
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('HMAC Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call HMAC Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('HMAC Sync Success'));
      console.info('uitest: testConvertSymmetricKeyBinaryFormatArkTS004 end');
      await driver.pressBack();
    })
  })
}