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

export default function eccCompressPublicKeyFormatConversionTest() {
  describe('eccCompressPublicKeyFormatConversionTest', () => {
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
     * 点击按钮，使用ECC压缩/非压缩公钥格式转换(C/C++)
     */
    it('testEccCompressPublicKeyFormatConversion001', 0, async () => {
      console.info('uitest: testEccCompressPublicKeyFormatConversion001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SpecifyUncompressedPublicKey'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('doTestEccDataCovert Success Result:0'));
      console.info('uitest: testEccCompressPublicKeyFormatConversion001 end');
    })

    /**
     * 点击按钮，使用ECC压缩/非压缩公钥格式转换(ArkTS)
     */
    it('testEccCompressPublicKeyFormatConversion002', 0, async () => {
      console.info('uitest: testEccCompressPublicKeyFormatConversion002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SpecifyUncompressedPublicKeyArkTS'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SpecifyUncompressedPublicKey'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SpecifyUncompressedPublicKey Success'));
      console.info('uitest: testEccCompressPublicKeyFormatConversion002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ECC压缩/非压缩点格式转换(指定非压缩点数据转换为压缩点数据)
     */
    it('testEccCompressPublicKeyFormatConversion003', 0, async () => {
      console.info('uitest: testEccCompressPublicKeyFormatConversion003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('CompressedPointData'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CompressedPointData'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CompressedPointData Success'));
      console.info('uitest: testEccCompressPublicKeyFormatConversion003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ECC压缩/非压缩点格式转换(指定压缩点数据获取密钥对象)
     */
    it('testEccCompressPublicKeyFormatConversion004', 0, async () => {
      console.info('uitest: testEccCompressPublicKeyFormatConversion004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('GetKeyObject'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call GetKeyObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('GetKeyObject Success'));
      console.info('uitest: testEccCompressPublicKeyFormatConversion004 end');
      await driver.pressBack();
    })
  })
}