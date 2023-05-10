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

import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import faultLogger from '@ohos.faultLogger';
import { describe, it, expect } from '@ohos/hypium';
import { logger } from '../util/Logger';

const delegator = abilityDelegatorRegistry.getAbilityDelegator()
const TAG: string = 'Sample_FaultLogger';
const BUNDLE = 'FaultLogger_';
const module = 'ohos.samples.faultlogger'

export default function unitTest() {
  describe('unitTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility_002', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      await delegator.executeShellCommand('aa start -b ohos.samples.faultlogger -a EntryAbility').then(result =>{
        logger.info(TAG, 'Uitest, start ability finished' )
      }).catch(err => {
        logger.info(TAG, 'Uitest, start ability failed')
      })
      await sleep(1000);
      //check top display ability
      await delegator.getCurrentTopAbility().then((Ability)=>{
        logger.info(TAG, 'get top ability');
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 构造JS_crash
    it(BUNDLE + 'CreateJsCrash_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}CreateJsCrash_001 begin`);
      sleep(1000);
      //@ts-ignore
      faultLogger.addFaultLog(0, faultLogger.FaultType.JS_CRASH, module, 'faultloggertestsummary02')
      logger.info(TAG, `${BUNDLE}CreateJsCrash_001 end`);
      done();
    })

    // 构造CPP_crash
    it(BUNDLE + 'CreateCppCrash_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}CreateCppCrash_001 begin`);
      sleep(1000);
      //@ts-ignore
      faultLogger.addFaultLog(0, faultLogger.FaultType.CPP_CRASH, module, 'faultloggertestsummary02')
      logger.info(TAG, `${BUNDLE}CreateCppCrash_001 end`);
      done();
    })

    // 构造APP_FREEZE
    it(BUNDLE + 'CreateAppFreeze_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}CreateAppFreeze_001 begin`);
      sleep(1000);
      //@ts-ignore
      faultLogger.addFaultLog(0, faultLogger.FaultType.APP_FREEZE, module, 'faultloggertestsummary02')
      logger.info(TAG, `${BUNDLE}CreateAppFreeze_001 end`);
      done();
    })

    function sleep(time) {
      return new Promise((resolve) => setTimeout(resolve, time));
    }
  })
}