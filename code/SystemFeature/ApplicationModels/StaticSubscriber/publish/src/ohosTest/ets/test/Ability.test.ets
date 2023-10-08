/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import Logger from '../../../../../entry/src/main/ets/model/Logger'
import Want from '@ohos.app.ability.Want';

const TAG = '[Sample_CommonEventPublish]';
const BUNDLE = 'CommonEventPublish_';

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {
    /**
     * 拉起发布静态订阅消息应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want: Want = {
        bundleName: "com.samples.staticsubscriber",
        abilityName: "com.samples.commoneventpublisher.MainAbility"
      };
      delegator.startAbility(want, (err) => {
        Logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 点击发布消息
     */
    it(BUNDLE + 'Publish_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}Publish_001 begin`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnPublish'));
      let btnPublish = await driver.findComponent(ON.id('btnPublish'));
      await btnPublish.click();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}Publish_001 end`);
      done();
    })
  })
}