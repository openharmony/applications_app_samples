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

export default function assetStoreNdkTest() {
  describe('assetStoreNdkTest', () => {
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
     * 点击按钮，新增、查询、更新、删除关键资产
     */
    it('testAssetStoreNdk001', 0, async () => {
      console.info('uitest: testAssetStoreNdk001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AddAsset'));
      const button2 = await driver.findComponent(ON.text('QueryAssetPlaintext'));
      const button3 = await driver.findComponent(ON.text('QueryAssetAttribute'));
      const button4 = await driver.findComponent(ON.text('QueryBatchAssetAttributes'));
      const button5 = await driver.findComponent(ON.text('UpdateAsset'));
      const button6 = await driver.findComponent(ON.text('RemoveAsset'));
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AddAsset success'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryAssetPlaintext success'));
      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryAssetAttribute success'));
      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryBatchAssetAttributes success'));
      await button5.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('UpdateAsset success'));
      await button6.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RemoveAsset success'));
      console.info('uitest: testAssetStoreNdk001 end');
    })

    /**
     * 点击按钮，管理群组关键资产
     */
    it('testAssetStoreNdk002', 0, async () => {
      console.info('uitest: testAssetStoreNdk002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AddGroupAsset'));
      const button2 = await driver.findComponent(ON.text('QueryGroupAssetPlaintext'));
      const button3 = await driver.findComponent(ON.text('QueryGroupAssetAttribute'));
      const button4 = await driver.findComponent(ON.text('UpdateGroupAsset'));
      const button5 = await driver.findComponent(ON.text('RemoveGroupAsset'));
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AddGroupAsset success'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryGroupAssetPlaintext success'));
      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryGroupAssetAttribute success'));
      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('UpdateGroupAsset success'));
      await button5.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RemoveGroupAsset success'));
      console.info('uitest: testAssetStoreNdk002 end');
    })

    /**
     * 点击按钮，管理同步关键资产
     */
    it('testAssetStoreNdk003', 0, async () => {
      console.info('uitest: testAssetStoreNdk003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AddSyncAsset'));
      const button2 = await driver.findComponent(ON.text('QuerySyncResult'));
      const button3 = await driver.findComponent(ON.text('RemoveAsset'));
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AddSyncAsset success'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QuerySyncResult success'));
      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RemoveAsset success'));
      console.info('uitest: testAssetStoreNdk003 end');
    })
  })
}