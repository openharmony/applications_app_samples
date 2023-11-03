/*
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../../util/Logger';

const BUNDLE = 'OAID';
const TAG = '[Sample_OAID_Test]';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

// 资源本地化
async function getResourceString<T extends Resource>(resource: T): Promise<string> {
  let manage = delegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + '_startAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let want: Want = {
        bundleName: 'com.samples.oaid',
        abilityName: 'EntryAbility'
      }
      delegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      Logger.info(TAG, BUNDLE + '_startAbility end')
      done()
    })

    /**
     * OAID测试
     */
    it(BUNDLE + 'OAIDFunction_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'OAIDFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      Logger.info(TAG, BUNDLE + 'OAIDFunction_001 clickOAIDShowPage start')
      // 允许广告跟踪权限
      let button = await driver.findComponent(ON.text("允许"));
      await button.click();
      Logger.info(TAG, BUNDLE + 'OAIDFunction_001 clickOAIDShowPage get permission end')
      // 获取OAID按钮，Promise方式
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.oaid_btn_promise'))))
      let getOaidByPromise = await driver.findComponent(ON.text(await getResourceString($r('app.string.oaid_btn_promise'))))
      await getOaidByPromise.click()
      let oaidTextArea = await driver.findComponent(ON.id('hiad_demo_oaid_textArea'))
      let oaid = await oaidTextArea.getText();
      expect(oaid.length > 0).assertEqual(true)
      await driver.delayMs(1000)
      // 获取OAID按钮，Async Callback方式
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.oaid_btn_asynccallback'))))
      let getOaidByAsyncCallback = await driver.findComponent(ON.text(await getResourceString($r('app.string.oaid_btn_asynccallback'))))
      await getOaidByAsyncCallback.click()
      oaid = await oaidTextArea.getText();
      expect(oaid.length > 0).assertEqual(true)
      await driver.delayMs(1000)
      // 重置OAID按钮
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.oaid_btn_reset'))))
      let resetOaid = await driver.findComponent(ON.text(await getResourceString($r('app.string.oaid_btn_reset'))))
      await resetOaid.click()
      oaid = await oaidTextArea.getText();
      expect(oaid.length > 0).assertEqual(true)
      Logger.info(TAG, BUNDLE + 'OAIDFunction_001 clickOAIDShowPage end')
      done()
    })
  })
}