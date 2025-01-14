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

import { describe, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { ComponentId } from '../../../main/ets/common/CommonConstant';
import Logger from '../../../main/ets/common/Logger';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

const BUNDLE = 'HTTPCASE_';
const BUNDLE_NAME = 'com.samples.http_case';
const ABILITY_NAME: string = 'EntryAbility';
const DELAY_MS = 3000;
let driver: Driver = Driver.create();

export default function AbilityTest() {
  describe('AbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE}StartAbility_001 begin`);
      const want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      };
      await delegator.startAbility(want);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_TITLE));
      await driver.delayMs(DELAY_MS);
      done();
      Logger.info(`${BUNDLE}StartAbility_001 end`);
    })

    /**
     * @tc.number Http_case_001
     * @tc.name Http_case_001
     * @tc.desc 测试 发送HTTP请求 按钮
     */
    it(BUNDLE + 'Http_case_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME} Http_case_001 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_BUTTON));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_BUTTON));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_001 end`);
      done();
    });

    /**
     * @tc.number Http_case_002
     * @tc.name Http_case_002
     * @tc.desc 测试 发送流式 HTTP 请求 按钮
     */
    it(BUNDLE + 'Http_case_002', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_002 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.STREAM_HTTP_BUTTON));
      let stack = await driver.findComponent(ON.id(ComponentId.STREAM_HTTP_BUTTON));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_002 end`);
      done();
    })
  })
}