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
import { beforeAll, describe, it } from '@ohos/hypium';
import Logger from '../utils/Logger';
import { Driver, ON } from '@kit.TestKit';

const TAG = '[Sample_KeyManager]';
const DELAY_MS_500: number = 500; // 指定500ms的延迟
const DELAY_MS_2000: number = 2000; // 指定2000ms的延迟

export default function abilityTest() {
  const driver: Driver = Driver.create();
  describe('ActsAbilityTest', () => {
    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.keymanager',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.error(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }
      await driver.delayMs(DELAY_MS_2000);
      Logger.info(TAG, 'beforeAll end');
      done();
    });

    // 查看页面显示是否正常，是否可以正常进行页面切换
    it('通用密钥管理', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('input'));
      await driver.assertComponentExist(ON.id('button'));
      await driver.assertComponentExist(ON.id('list'));

      let textInput = await driver.findComponent(ON.id('input'));
      await driver.delayMs(DELAY_MS_500);
      await textInput.inputText("测试数据");
      await driver.delayMs(DELAY_MS_500);
      let button = await driver.findComponent(ON.id('button'));
      await driver.delayMs(DELAY_MS_500);
      await button.click();
      await driver.delayMs(DELAY_MS_500);
      let list = await driver.findComponent(ON.id('list'));
      await driver.delayMs(DELAY_MS_500);
      await list.scrollToBottom();
      await driver.delayMs(DELAY_MS_500);
      await textInput.inputText("测试数据");
      await driver.delayMs(DELAY_MS_500);
      await button.click();
      await driver.delayMs(DELAY_MS_500);
      await list.scrollToBottom();
      done();
    })
  })
}