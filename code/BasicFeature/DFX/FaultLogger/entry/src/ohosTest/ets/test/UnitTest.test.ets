/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
import testNapi from 'libentry.so';
import { describe, it, expect } from '@ohos/hypium';
import { logger } from '../util/Logger';
import { Driver } from '@kit.TestKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator()
const TAG: string = 'Sample_FaultLogger';
const BUNDLE = 'FaultLogger_';
const module = 'ohos.samples.faultlogger'

export default function unitTest() {
  let driver: Driver = Driver.create();
  describe('unitTest', () => {
    // 打开应用
    it(BUNDLE + 'StartAbility_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      await delegator.executeShellCommand('aa start -b ohos.samples.faultlogger -a EntryAbility').then(result =>{
        logger.info(TAG, 'Uitest, start ability finished' )
      }).catch((err: Error) => {
        logger.info(TAG, 'Uitest, start ability failed')
      })
      await driver.delayMs(1000);
      //check top display ability
      await delegator.getCurrentTopAbility().then((Ability)=>{
        logger.info(TAG, 'get top ability');
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 构造JS_crash
    it(BUNDLE + 'CreateJsCrash_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}CreateJsCrash_001 begin`);
      await driver.delayMs(1000);
      let tempList = ['0', '1'];
      logger.info(tempList[3].toString());
      logger.info(TAG, `${BUNDLE}CreateJsCrash_001 end`);
      done();
    })

    // 构造CPP_crash
    it(BUNDLE + 'CreateCppCrash_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}CreateCppCrash_001 begin`);
      await driver.delayMs(1000);
      testNapi.add(2, 3);
      logger.info(TAG, `${BUNDLE}CreateCppCrash_001 end`);
      done();
    })

    // 构造APP_FREEZE
    it(BUNDLE + 'CreateAppFreeze_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}CreateAppFreeze_001 begin`);
      await driver.delayMs(1000);
      let index = 0; // 循环初始值
      while (true) {
        index++;
        let selectIndex = index % 2;
      }
      logger.info(TAG, `${BUNDLE}CreateAppFreeze_001 end`);
      done();
    })
  })
}