/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@kit.TestKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_SystemBarEnabled]';
const DOMAIN = 0xFF00;
const BUNDLE = 'SystemBarEnabled_';
const BUNDLE_NAME = 'com.example.systembarenabled';

async function startEntryAbility(): Promise<void> {
  const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  await abilityDelegator.startAbility({
    bundleName: BUNDLE_NAME,
    abilityName: 'EntryAbility'
  });
}

export default function abilityTest() {
  describe('EntryAbilityTest', () => {
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      const driver = Driver.create();
      try {
        await startEntryAbility();
      } catch (exception) {
        hilog.error(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Top Container'));
      await driver.assertComponentExist(ON.text('Bottom Container'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    it(BUNDLE + 'ShowContent_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShowContent_001 begin');
      const driver = Driver.create();
      try {
        await startEntryAbility();
      } catch (exception) {
        hilog.error(DOMAIN, TAG, BUNDLE + `ShowContent_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Top Container'));
      await driver.assertComponentExist(ON.text('Bottom Container'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShowContent_001 end');
    })
  })
}
