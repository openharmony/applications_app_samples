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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';


const TAG: string = '[Sample_StaticSubscriber]';
const DOMAIN = 0xF811;
const BUNDLE = 'StaticSubscriber_';

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();

  describe('ActsAbilityTest', () => {
    /**
     * 拉起静态订阅应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '${BUNDLE}StartAbility_001 begin');
      let want: Want = {
        bundleName: "com.samples.staticsubscriber",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(DOMAIN, TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, '${BUNDLE}StartAbility_001 end');
      done();
    })

    /**
     * 开启静态订阅
     */
    it(BUNDLE + 'EnableStaticsubscriber_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '${BUNDLE}EnableStaticsubscriber_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnEnable'));
      let btnEnable = await driver.findComponent(ON.id('btnEnable'));
      await btnEnable.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, '${BUNDLE}EnableStaticsubscriber_001 end');
      done();
    })

    /**
     * 关闭静态订阅
     */
    it(BUNDLE + 'DisableStaticsubscriber_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '${BUNDLE}DisableStaticsubscriber_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnDisable'));
      let btnDisable = await driver.findComponent(ON.id('btnDisable'));
      await btnDisable.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, '${BUNDLE}DisableStaticsubscriber_001 end');
      done();
    })
  })
}