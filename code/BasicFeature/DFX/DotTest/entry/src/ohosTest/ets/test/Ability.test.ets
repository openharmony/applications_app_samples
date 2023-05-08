/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG: string = 'Sample_DotTest';
const BUNDLE: string = 'DotTest_';

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want = {
        bundleName: "ohos.samples.dottest",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        console.info("get top ability");
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 打开禁用应用打点开关
    it(BUNDLE + 'EventSwitch_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}EventSwitch_001 begin`);
      await driver.assertComponentExist(ON.id('eventSwitch'));
      let eventSwitch = await driver.findComponent(ON.id('eventSwitch'));
      await eventSwitch.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.appDisabled')), MatchPattern.EQUALS));
      logger.info(TAG, `${BUNDLE}EventSwitch_001 end`);
      done();
    })

    // 禁用应用打点后写入事件
    it(BUNDLE + 'InputEvent_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}InputEvent_001 begin`);
      await driver.assertComponentExist(ON.id('eventInto'));
      let eventIntoBtn = await driver.findComponent(ON.id('eventInto'));
      await eventIntoBtn.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.writeFailed')), MatchPattern.EQUALS));
      logger.info(TAG, `${BUNDLE}InputEvent_001 end`);
      done();
    })

    // 关闭禁用应用打点开关
    it(BUNDLE + 'EventSwitch_002', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}EventSwitch_002 begin`);
      await driver.assertComponentExist(ON.id('eventSwitch'));
      let eventSwitch = await driver.findComponent(ON.id('eventSwitch'));
      await eventSwitch.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.appAble')), MatchPattern.EQUALS));
      logger.info(TAG, `${BUNDLE}EventSwitch_002 end`);
      done();
    })

    // 禁用应用打点后写入事件
    it(BUNDLE + 'InputEvent_002', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}InputEvent_002 begin`);
      await driver.assertComponentExist(ON.id('eventInto'));
      let eventIntoBtn = await driver.findComponent(ON.id('eventInto'));
      await eventIntoBtn.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.writeSuccess')), MatchPattern.EQUALS));
      logger.info(TAG, `${BUNDLE}InputEvent_002 end`);
      done();
    })

    function getString(resource: Resource) {
      return delegator.getAppContext().resourceManager.getStringSync(resource);
    }
  })
}