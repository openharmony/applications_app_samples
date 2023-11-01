/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { Driver, ON } from '@ohos.UiTest'
import Logger from '../../../main/ets/model/Logger'

const TAG = '[Sample_DistributedAccount]'
const BUNDLE = 'DistributedAccount_'

const DELAY_TIME = 5000;
let driver: Driver = Driver.create();
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

// 通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.text(atom));
  let button = await driver.findComponent(ON.text(atom));
  await button.click();
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}

// 通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(id: string) {
  let atom = id;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.click();
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}

// 展开Select并选择
async function clickSelectIDAndSelectText(toggleId: string, selectText: string) {
  { //展开
    let atom = toggleId;
    await checkButtonAndClickWithID(atom);
  }
  { //选择
    let atom = selectText;
    await checkButtonAndClickWithText(atom);
  }
}

export default function abilityTest() {
  let driver = Driver.create()
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.distributedaccount',
          abilityName: 'EntryAbility'
        })
        done()
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 绑定分布式帐号
     */
    it(BUNDLE + 'SetOsAccountDistributedInfoByLocalId_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'setOsAccountDistributedInfoByLocalId_001 begin')
      await driver.delayMs(DELAY_TIME)
      // 点击选择头像
      await driver.assertComponentExist(ON.id('select_avatar'))
      let selectAvatar = await driver.findComponent(ON.id('select_avatar'))
      await selectAvatar.click()
      await driver.delayMs(DELAY_TIME)
      // 拍照
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.take_photo'))))
      let takephoto = await driver.findComponent(ON.text(await getResourceString($r('app.string.take_photo'))))
      await takephoto.click()
      await driver.delayMs(5000)
      await driver.click(357, 1100) // 点击拍照
      await driver.delayMs(2000)
      // 点击右上角确定 固定坐标只支持RK3568，其他设备需要调整
      await driver.click(664, 84)
      await driver.delayMs(DELAY_TIME)
      // 输入分布式帐号名
      await driver.assertComponentExist(ON.id('distributedAccountName'))
      let distributedAccountName = await driver.findComponent(ON.id('distributedAccountName'))
      await distributedAccountName.inputText('zhangsan');
      await driver.delayMs(DELAY_TIME)
      // 设置昵称
      await driver.assertComponentExist(ON.id('distributedAccountNickName'))
      let distributedAccountNickName = await driver.findComponent(ON.id('distributedAccountNickName'))
      await distributedAccountNickName.inputText('zs');
      await driver.delayMs(DELAY_TIME)
      // 点击选择框 固定坐标只支持RK3568，其他设备需要调整
      await driver.click(683, 485)
      await driver.delayMs(DELAY_TIME)
      // 选择绑定系统帐号
      await driver.assertComponentExist(ON.text('user'))
      let selectOption = await driver.findComponent(ON.text('user'))
      await selectOption.click()
      await driver.delayMs(DELAY_TIME)
      // 点击绑定
      await driver.assertComponentExist(ON.id('Bind'))
      let btn_Bind = await driver.findComponent(ON.id('Bind'))
      await btn_Bind.click();
      await driver.delayMs(DELAY_TIME)
      Logger.info(TAG, BUNDLE + 'setOsAccountDistributedInfoByLocalId_001 end')
    })

    /**
     * 选择分布式帐号
     */
    it(BUNDLE + 'SelectDistributedAccount_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'selectDistributedAccount_001 begin')
      await driver.delayMs(DELAY_TIME)
      // 点击分布式帐号
      await driver.assertComponentExist(ON.id('distributedAccount0'))
      let distributedAccount = await driver.findComponent(ON.id('distributedAccount0'))
      await distributedAccount.click();
      await driver.delayMs(DELAY_TIME)
      Logger.info(TAG, BUNDLE + 'selectDistributedAccount_001 end')
    })

    /**
     * 解绑分布式帐号
     */
    it(BUNDLE + 'SetOsAccountDistributedInfoByLocalId_002', 0, async () => {
      Logger.info(TAG, BUNDLE + 'setOsAccountDistributedInfoByLocalId_002 begin')
      await driver.delayMs(DELAY_TIME)
      // 点击解绑
      await driver.assertComponentExist(ON.id('Unbind'))
      let btn_Unbind = await driver.findComponent(ON.id('Unbind'))
      await btn_Unbind.click();
      await driver.delayMs(DELAY_TIME)
      // 点击解绑帐号 固定坐标只支持RK3568，其他设备需要调整
      await driver.click(540, 1135);
      await driver.delayMs(DELAY_TIME)
      Logger.info(TAG, BUNDLE + 'setOsAccountDistributedInfoByLocalId_002 end')
    })
  })
}