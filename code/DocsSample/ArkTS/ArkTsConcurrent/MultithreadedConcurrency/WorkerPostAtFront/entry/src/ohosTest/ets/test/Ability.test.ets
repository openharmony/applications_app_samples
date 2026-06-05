/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

let want: Want;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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
    it('testSendMessage', 0, async (done: Function) => {
      console.log('uitest: TestSendMessage begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('触发消息发送'));
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Hello World'));
      done();
    })
    it('testCloseWorker', 0, async (done: Function) => {
      console.log('uitest: TestCloseWorker begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('释放worker'));
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Hello World'));
      done();
    })
  })
}