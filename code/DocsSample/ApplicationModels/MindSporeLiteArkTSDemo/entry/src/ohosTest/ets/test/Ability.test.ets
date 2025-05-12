/*
* Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, it, expect } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import { getString } from '../utils/ResourceUtil';

const BUNDLE = 'MindSporeLiteArkTSDemo_';
const TAG = 'abilityTest';
const domain: number = 0xF811;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('MindSporeLiteArkTSDemoTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    /*
     * @tc.number: MindSporeLiteArkTSDemoTest_000
     * @tc.name: Start Ability
     * @tc.desc: Start Ability
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('EntryAbility', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'EntryAbility_001 begin');
      // 开启应用
      let want: Want = {
        bundleName: 'com.samples.mindsporelitearktsdemo',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(domain, TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(3000);
      // 用户授权
      await driver.assertComponentExist(ON.text(
        await abilityDelegator.getAppContext().resourceManager.getStringValue($r('app.string.allow'))));
      let permissionAllowBtn = await driver.findComponent(ON.text(
        await abilityDelegator.getAppContext().resourceManager.getStringValue($r('app.string.allow'))));
      await permissionAllowBtn.click();
      await driver.delayMs(1000);
      hilog.info(domain, TAG, BUNDLE + 'EntryAbility_001 end');
      done();
    })
    /**
     * @tc.number     : MindSporeLiteArkTSDemoTest_001
     * @tc.name       : open photo
     * @tc.desc       : open photo
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('IfExists', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'IfExists_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MindSporeLite ArkTS Demo'));
      await driver.assertComponentExist(ON.text('photo'));
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'IfExists_001 end');
      done();
    })

    /**
     * @tc.number     : MindSporeLiteArkTSDemoTest_002
     * @tc.name       : open photo and predict
     * @tc.desc       : open photo and predict
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PhotoPredict', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'PhotoPredict_001 begin');
      await driver.delayMs(1000);
      // 点击photo按钮
      hilog.info(domain, TAG, BUNDLE + 'PhotoPredict_001 click photo button');
      await driver.assertComponentExist(ON.text('photo'));
      let msPhoto = await driver.findComponent(ON.text('photo'));
      await msPhoto.click();
      await driver.delayMs(5000);
      // 点击照片，选中一张照片
      let gridItems = await driver.findComponents(ON.type('GridItem'));
      await gridItems[1].click();
      await driver.delayMs(5000);
      // 点击完成
      let tipCompleted: string = getString($r('app.string.completed'));
      await driver.assertComponentExist(ON.text(tipCompleted));
      let finish = await driver.findComponent(ON.text(tipCompleted));
      await driver.delayMs(5000);
      await finish.click();
      await driver.delayMs(5000);
      // 进行图片推理
      await driver.assertComponentExist(ON.text('MindSporeLite ArkTS Demo'));
      await driver.assertComponentExist(ON.text('%', 1));
      await driver.delayMs(5000);
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'PhotoPredict_001 end');
      done();
    })
  })
}