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

import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, MatchPattern, ON } from '@kit.TestKit';
import Logger from '../../../main/ets/common/Logger';
import { UIAbility } from '@kit.AbilityKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

const BUNDLE = 'Socket_';
const BUNDLE_NAME = 'com.samples.Socket';
const ABILITY_NAME: string = 'EntryAbility';
let driver: Driver = Driver.create();
const DELAY_MS = 3000; // 超时设置3s

async function goBack(driver: Driver) {
  try {
    await driver.assertComponentExist(ON.id('btnBack'));
    let backButton = await driver.findComponent(ON.id('btnBack'));
    await backButton.click();
    await driver.delayMs(DELAY_MS);
  } catch (e) {
    Logger.error(`Failed to go back: ${e.message}`);
  }
}

async function checkAndClickByText(text: string) {
  try {
    await driver.assertComponentExist(ON.text(text, MatchPattern.CONTAINS));
    let component = await driver.findComponent(ON.text(text));
    await component.click();
    await driver.delayMs(DELAY_MS);
  } catch (e) {
    Logger.error(`Failed to click on text: ${text}, Error: ${e.message}`);
  }
}

function ResourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE} StartAbility_001 begin`);
      const want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      };
      try {
        await delegator.startAbility(want);
        await driver.delayMs(DELAY_MS);
        const ability: UIAbility = await delegator.getCurrentTopAbility();
        expect(ability.context.abilityInfo.name).assertEqual(ABILITY_NAME);
      } catch (error) {
        Logger.error(`${BUNDLE} StartAbility_001 failed: ${error.message}`);
      }
      done();
      Logger.info(`${BUNDLE} StartAbility_001 end`);
    });

    /**
     * @tc.number Multicast_001
     * @tc.name Multicast_001
     * @tc.desc 测试多播通信
     */
    it(BUNDLE + 'Multicast_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE} Multicast_001 begin`);
      await checkAndClickByText(ResourceToString($r('app.string.Multicast')));
      await checkAndClickByText(ResourceToString($r('app.string.StartMulticast')));
      try {
        let resultText = await driver.findComponent(ON.id('multicast_communication'));
        let result = await resultText.getText();
        expect(result).assertContain('Joined');
      } catch (error) {
        Logger.error(`Multicast communication failed: ${error.message}`);
      }
      await goBack(driver);
      done();
      Logger.info(`${BUNDLE} Multicast_001 end`);
    });

    /**
     * @tc.number LocalSocket_001
     * @tc.name LocalSocket_001
     * @tc.desc 启动本地服务器
     */
    it(BUNDLE + 'LocalSocket_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE} LocalSocket_001 begin`);
      await checkAndClickByText(ResourceToString($r('app.string.LocalSocket')));
      await checkAndClickByText(ResourceToString($r('app.string.Start_Local_Socket_Server')));
      try {
        let resultText = await driver.findComponent(ON.id('serverStatus'));
        let result = await resultText.getText();
        expect(result).assertContain('Listening');
      } catch (error) {
        Logger.error(`LocalSocket server failed: ${error.message}`);
      }
      await goBack(driver);
      done();
      Logger.info(`${BUNDLE} LocalSocket_001 end`);
    });

    /**
     * @tc.number LocalSocket_002
     * @tc.name LocalSocket_002
     * @tc.desc 启动本地客户端
     */
    it(BUNDLE + 'LocalSocket_002', 0, async (done: Function) => {
      Logger.info(`${BUNDLE} LocalSocket_002 begin`);
      await checkAndClickByText(ResourceToString($r('app.string.LocalSocket')));
      await checkAndClickByText(ResourceToString($r('app.string.Start_Local_Socket_Communication')));
      try {
        let resultText = await driver.findComponent(ON.id('clientStatus'));
        let result = await resultText.getText();
        expect(result).assertContain('Connected');
      } catch (error) {
        Logger.error(`LocalSocket client failed: ${error.message}`);
      }
      await goBack(driver);
      done();
      Logger.info(`${BUNDLE} LocalSocket_002 end`);
    });
  });
}
