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

    it('testAssetStoreNdk001', 0, async () => {
      console.info('uitest: testAssetStoreNdk001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AddAsset'));
      const button2 = await driver.findComponent(ON.text('RemoveAsset'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AddAsset success'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RemoveAsset success'));
      await button1.click();
      console.info('uitest: testAssetStoreNdk001 end');
    })

    it('testAssetStoreNdk002', 0, async () => {
      console.info('uitest: testAssetStoreNdk002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('BatchQuery'));
      const button2 = await driver.findComponent(ON.text('UpdateAsset'));
      const button3 = await driver.findComponent(ON.text('QueryAsset'));
      const button4 = await driver.findComponent(ON.text('QueryAttributes'));
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('BatchQuery success'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('UpdateAsset success'));
      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryAsset success'));
      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QueryAttributes success'));
      console.info('uitest: testAssetStoreNdk002 end');
    })
  })
}