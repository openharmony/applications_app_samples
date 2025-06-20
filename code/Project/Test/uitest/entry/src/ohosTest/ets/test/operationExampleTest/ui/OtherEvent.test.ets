/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect, TestType, beforeAll, Level, Size } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { Driver, ON} from '@ohos.UiTest'
import { BusinessError } from '@ohos.base';
import display from '@ohos.display';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const delegator : AbilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName : string = abilityDelegatorRegistry.getArguments().bundleName;
const waitUiReadyMs : number = 1000;

async function startAbility(bundleName: string, abilityName: string) {
  await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`);
}

export default function otherEvent() {
  describe('otherEvent', () => {
    beforeAll(async () => {
    })

    /*
     * @tc.name: testPressBackWithId
     * @tc.desc: pressBack test，该接口从api20开始支持使用。
     */
    it('testPressBackWithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let disPlay = display.getDefaultDisplaySync();
      let button = await driver.findComponent(ON.belongingDisplay(disPlay.id).text('next page'))
      await button.click()
      await driver.delayMs(waitUiReadyMs)
      await driver.pressBack(disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      let button_ori = await driver.findComponent(ON.belongingDisplay(disPlay.id).text('next page'))
      expect(await button_ori.getText() == 'next page').assertTrue()
    })

    /*
     * @tc.name: testTriggerKeyWithId
     * @tc.desc: triggerKey test，该接口从api20开始支持使用。
     */
    it('testTriggerKeyWithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let disPlay = display.getDefaultDisplaySync();
      await driver.delayMs(waitUiReadyMs)
      let button = await driver.findComponent(ON.belongingDisplay(disPlay.id).text('next page'))
      await button.click()
      await driver.delayMs(waitUiReadyMs)
      let keyBack = 2
      await driver.triggerKey(keyBack, disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      let button_ori = await driver.findComponent(ON.belongingDisplay(disPlay.id).text('next page'))
      expect(await button_ori.getText() == 'next page').assertTrue()
    })


    /*
     * @tc.name: testPressHomeWithId
     * @tc.desc: pressHome test，该接口从api20开始支持使用。
     */
    it('testPressHomeWithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let disPlay = display.getDefaultDisplaySync();
      await driver.pressHome(disPlay.id)
      await driver.delayMs(1000)
      let button = await driver.findComponent(ON.belongingDisplay(disPlay.id).text('next page'))
      expect(button == null).assertTrue()
    })

  })
}