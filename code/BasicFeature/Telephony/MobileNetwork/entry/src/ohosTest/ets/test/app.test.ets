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

const TAG = '[Sample_MobileNetwork]';
const BUNDLE = 'MobileNetwork_';

export default function appTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('appTest', function () {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want = {
        bundleName: "ohos.samples.mobilenetwork",
        abilityName: "MainAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        logger.info(TAG, `${BUNDLE}get top ability, ${Ability.context.abilityInfo.name}`);
        expect(Ability.context.abilityInfo.name).assertEqual('MainAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 检查UI界面显示是否正常
    it(BUNDLE + 'CheckUI_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}CheckUI_001 begin`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('默认数据卡', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text('移动数据', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text('漫游', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.id('mobileData'));
      await driver.assertComponentExist(ON.id('roaming'));
      await driver.assertComponentExist(ON.id('dataFlowType'));
      await driver.assertComponentExist(ON.id('connectState'));
      logger.info(TAG, `${BUNDLE}CheckUI_001 end`);
      done();
    })
  })
}