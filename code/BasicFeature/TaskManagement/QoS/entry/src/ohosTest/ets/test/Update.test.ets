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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { Logger } from '../utils/Logger';

const DRIVER = Driver.create();

let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function updateTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起应用
     * 自动化测试用例执行结束后，可通过该测试验证是否升级成功
     */
    it('StartAbility_002', 0, async (done) => {
      Logger.info('StartAbility_002 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.workschedulerextensionability',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      Logger.info('StartAbility_002 end');
    })

    /**
     * 检查版本
     */
    it('CheckoutVersion_002', 1, async () => {
      Logger.info('CheckoutVersion_002 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('version'));
      let version = await DRIVER.findComponent(ON.id('version'));
      // 断言当前版本为1.1,升级成功
      expect((await version.getText()).split('：')[1]).assertEqual('1.1');
      Logger.info('CheckoutVersion_002 end');
    })
  })
}