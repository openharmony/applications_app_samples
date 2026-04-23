/*
 * Copyright (c) 2022-2026 Huawei Device Co., Ltd.
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

import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Logger } from '../utils/Logger';

const DRIVER = Driver.create();

let abilityDelRegistry = abilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', () =>{
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info('StartAbility_001 begin');

      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.workschedulerextensionability',
          abilityName: 'MainAbility'
        })
        expect(true).assertTrue();
      } catch (exception) {
        Logger.info(`Failed to start ability, error info: ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info('StartAbility_001 end');
      done();
    })

    /**
     * 检查控件是否存在
     */
    it('CheckoutVersion_001', 0, async (done: Function) => {
      Logger.info('CheckoutVersion_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('version'));
      await DRIVER.assertComponentExist(ON.id('btn_start_work'));
      await DRIVER.assertComponentExist(ON.id('btn_stop_work'));
      expect(true).assertTrue();
      Logger.info('CheckoutVersion_001 end');
      done();
    })

    /**
     * 测试申请延迟任务
     */
    it('StartWork_001', 0, async (done: Function) => {
      Logger.info('StartWork_001 begin');
      await DRIVER.delayMs(1000);
      let startWorkBtn = await DRIVER.findComponent(ON.id('btn_start_work'));
      await startWorkBtn.click();
      await DRIVER.delayMs(1000);
      expect(true).assertTrue();
      Logger.info('StartWork_001 end');
      done();
    })

    /**
     * 测试取消延迟任务
     */
    it('StopWork_001', 0, async (done: Function) => {
      Logger.info('StopWork_001 begin');
      await DRIVER.delayMs(1000);
      let stopWorkBtn = await DRIVER.findComponent(ON.id('btn_stop_work'));
      await stopWorkBtn.click();
      await DRIVER.delayMs(1000);
      expect(true).assertTrue();
      Logger.info('StopWork_001 end');
      done();
    })
  })
}