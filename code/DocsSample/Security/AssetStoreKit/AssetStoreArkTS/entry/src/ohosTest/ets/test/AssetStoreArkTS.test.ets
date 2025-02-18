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

export default function assetStoreArkTSTest() {
  describe('assetStoreArkTSTest', () => {
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
     * 点击按钮，添加关键资产
     */
    it('testAssetStoreArkTS001', 0, async () => {
      console.info('uitest: testAssetStoreArkTS001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Add Critical Asset'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Add Critical Asset Success'));
      console.info('uitest: testAssetStoreArkTS001 end');
    })

    /**
     * 点击按钮，添加关键资产
     */
    it('testAssetStoreArkTS002', 0, async () => {
      console.info('uitest: testAssetStoreArkTS002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Add Critical Asset Auth'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Add Critical Asset Auth Success'));
      console.info('uitest: testAssetStoreArkTS002 end');
    })

    /**
     * 点击按钮，更新查询关键资产
     */
    it('testAssetStoreArkTS003', 0, async () => {
      console.info('uitest: testAssetStoreArkTS003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Update Critical Asset'));
      const button2 = await driver.findComponent(ON.text('QueryAll Critical Asset'));
      const button3 = await driver.findComponent(ON.text('QueryAttributes Critical Asset'));
      const button4 = await driver.findComponent(ON.text('QueryList Critical Asset'));
      await button1.click();
      await button2.click();
      await button3.click();
      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Update Critical Asset Success'));
      await driver.assertComponentExist(ON.text('QueryAll Critical Asset Success'));
      await driver.assertComponentExist(ON.text('QueryAttributes Critical Asset Success'));
      await driver.assertComponentExist(ON.text('QueryList Critical Asset Success'));
      console.info('uitest: testAssetStoreArkTS003 end');
    })

    /**
     * 点击按钮，删除关键资产
     */
    it('testAssetStoreArkTS004', 0, async () => {
      console.info('uitest: testAssetStoreArkTS004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Remove Critical Asset'));
      const button2 = await driver.findComponent(ON.text('Remove Critical Asset Second'));
      await button1.click();
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Remove Critical Asset Success'));
      await driver.assertComponentExist(ON.text('Remove Critical Asset Second Success'));
      console.info('uitest: testAssetStoreArkTS004 end');
      await driver.pressBack();
    })
  })
}