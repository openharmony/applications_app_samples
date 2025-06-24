/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, MatchPattern, ON } from '@ohos.UiTest';
import { UIAbility } from '@kit.AbilityKit';

const BUNDLE = 'Socket';
const TAG = '[Sample_Socket]';
const DOMAIN = 0xF811;
let uiAbility: UIAbility;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起一个Ability
     */
    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let driver = Driver.create();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.socket',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(3000);
      } catch (exception) {
        hilog.info(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      done();
    })

    /**
     * 检查界面是否正常显示
     */
    it('CheckAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAbility_001 begin');
      let driver = Driver.create();
      uiAbility = await AbilityDelegatorRegistry.getAbilityDelegator().getCurrentTopAbility();
      let resourceManager = uiAbility.context.resourceManager;
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Local_IP')), MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.users')), MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.id('TextInput1'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAbility_001 end');
      done();
    })
  })
}