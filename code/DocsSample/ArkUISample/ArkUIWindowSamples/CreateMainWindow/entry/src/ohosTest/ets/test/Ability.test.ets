/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

const TAG = '[Sample_CreatMainWindow]';
const DOMAIN = 0xFF00
const BUNDLE = 'CreatMainWindow_';

export default function abilityTest() {

  describe('EntryAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.createmainwindow',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Hello World'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 点击Hello Window，与主窗交互
     */
    it (BUNDLE + 'CreateMainWindow_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "CreateMainWindow_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.createmainwindow',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `CreateMainWindow_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Hello World'));
      let clickBtn = await driver.findComponent(ON.text('Hello World'));
      await clickBtn.click();
      await driver.delayMs(1000);


      hilog.info(DOMAIN, TAG, BUNDLE + `Hello World_001 end`);
    })
  })
}
