/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { Driver, ON } from '@ohos.UiTest';

const TAG = '[Sample_DrawingAPI]';

let visited: Set<string> = new Set()

async function clickAllButtons(driver: Driver, parentName: string = '') {
  // 查找当前页面所有按钮
  try {
    const buttons = await driver.findComponents(ON.type('Button'));
    if (buttons && buttons.length > 0) {
      for (const button of buttons) {
        const name = await button.getText()
        console.log(TAG, parentName + name)
        if (visited.has(name)) {
          continue
        }
        await button.click();
        await driver.delayMs(1000); // 等待页面跳转/更新

        // 递归处理新页面
        await clickAllButtons(driver, name + '/');
        await driver.pressBack()
        await driver.delayMs(500)
        visited.add(name)
      }
    }
  } catch (error) {
    console.log(TAG, error)
  }
}

export default function abilityTest() {

  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkcomplextext1',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        done()
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
    })

    /**
     * 执行所有用例
     */
    it('TravelAllSamples', 2, async () => {
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkcomplextext1',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(300);
        await clickAllButtons(driver)
      } catch (exception) {
        console.info(TAG, `TravelAllSamples exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
    })
  })
}