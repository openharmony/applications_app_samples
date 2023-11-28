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
import { describe, it } from '@ohos/hypium';
import { logger } from '../util/Logger';

export default function abilityTest() {
  describe('AbilityTest', () => {

    /**
     * @tc.number:Startup_001
     * @tc.name: Startup_001
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: application startup test
     */
    // 拉起应用
    it('Startup_001', 0, async (done: Function) => {
      logger.info('Startup_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.startup',
          abilityName: 'EntryAbility'
        });
        done();
      }
      catch (expection) {
        logger.info(`Startup_001 end ${JSON.stringify(expection)}`);
        done();
      }
      logger.info('Startup_001 end');
    })
  })
}