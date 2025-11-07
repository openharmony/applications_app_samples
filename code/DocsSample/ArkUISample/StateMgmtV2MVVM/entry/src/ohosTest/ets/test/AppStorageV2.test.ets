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
 *
*/

import hilog from '@ohos.hilog'
import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function AppV2Test () {

  describe('AppV2Test', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /*
     * @tc.number: StateMgmt_AppV2_001
     * @tc.name: StateMgmt_AppV2_001
     * @tc.desc: StateMgmt_AppV2_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('StateMgmt_AppV2_001',0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testTask begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let V2 = await driver.findComponent(ON.text('AppStorageV2'));
      await V2.getText().then(result => {
        expect(result).assertEqual('AppStorageV2');
      });

      done();
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testTask end');
    })

    /*
     * @tc.number: StateMgmt_StoreData_001
     * @tc.name: StateMgmt_StoreData_001
     * @tc.desc: StateMgmt_StoreData_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('StateMgmt_StoreData_001',0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testTask begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let V2 = await driver.findComponent(ON.text('Store data between two pages'));
      await V2.click();
      await driver.delayMs(1000);

      let task = await driver.findComponent(ON.text('Go to pageTwo'));
      await task.click();
      await driver.delayMs(1000);

      done();
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testTask end');
    })
  })
}
