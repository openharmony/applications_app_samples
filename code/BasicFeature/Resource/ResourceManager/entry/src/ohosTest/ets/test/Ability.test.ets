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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'
import CommonEventManager from '@ohos.commonEventManager'
import router from '@ohos.router';

const TAG = '[Sample_ResourceManager]'
const DOMAIN = 0xF811
const BUNDLE = 'ResourceManager_'
const SPECIFIED_NUM = 2

async function getResourceFormatString(str: Resource, format: Resource): Promise<string> {
  let resMgr = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  try {
    let formatStr = resMgr.getStringSync(format)
    let text = resMgr.getStringSync(str, formatStr)
    return text
  } catch (error) {
    hilog.error(DOMAIN, TAG, `getStringSync failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getResourceString(resource: Resource): Promise<string> {
  let resMgr = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  try {
    let text = await resMgr.getStringValue(resource)
    return text
  } catch (error) {
    hilog.error(DOMAIN, TAG, `getStringValue failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getResourceStringArray(resource: Resource): Promise<string> {
  let resMgr = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  try {
    let text = JSON.stringify(await resMgr.getStringArrayValue(resource))
    return text
  } catch (error) {
    hilog.error(DOMAIN, TAG, `getStringArrayValue failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getResourcePluralString(resource: Resource, num: number): Promise<string> {
  let resMgr = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  try {
    let text = await resMgr.getPluralStringValue(resource, num)
    return text
  } catch (error) {
    hilog.error(DOMAIN, TAG, `getPluralStringValue failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getDeviceCapability(): Promise<string> {
  let resMgr = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  try {
    let text = JSON.stringify(await resMgr.getDeviceCapability())
    return text
  } catch (error) {
    hilog.error(DOMAIN, TAG, `getDeviceCapability failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getConfiguration(): Promise<string> {
  let resMgr = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  try {
    let text = JSON.stringify(await resMgr.getConfiguration())
    return text
  } catch (error) {
    hilog.error(DOMAIN, TAG, `getConfiguration failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

export default function appTest() {
  describe('ActsResMgrTest', function () {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.resourcemanager',
          abilityName: 'EntryAbility'
        }).then(async => {
          function publishCB(err) {
            if (err) {
              console.error(`publish failed, code is ${err.code}, message is ${err.message}`);
            } else {
              console.info("publish");
            }
          }
          setTimeout(()=>{
            CommonEventManager.publish("TestResourcesEvent", publishCB); // 发布事件
            done()
          }, 1500)
        })
        done()
      } catch (error) {
        hilog.info(DOMAIN, TAG, `StartAbility end ${JSON.stringify(error)}`)
        expect(0).assertEqual(error.code)
        done()
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 进入应用，测试getStringValue接口
     */
    it(BUNDLE + 'CreateFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getStringValue接口返回值
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.stringDesc'))))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.string_str'))))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 end')
    })

    /**
     * 进入应用，测试getStringArrayValue接口
     */
    it(BUNDLE + 'CreateFunction_002', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_002 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getStringArrayValue接口返回值
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.stringArrayDesc'))))
      await driver.assertComponentExist(ON.text(await getResourceStringArray($r('app.strarray.str_array'))))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_002 end')
    })

    /**
     * 进入应用，测试getPluralStringValue接口
     */
    it(BUNDLE + 'CreateFunction_003', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_003 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getPluralStringValue接口返回值
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.pluralStringDesc'))))
      await driver.assertComponentExist(ON.text(await getResourcePluralString($r('app.plural.eat_apple'),
        SPECIFIED_NUM)))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_003 end')
    })

    /**
     * 进入应用，测试getConfiguration接口
     */
    it(BUNDLE + 'CreateFunction_004', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_004 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getConfiguration接口返回值
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.configurationDesc'))))
      await driver.assertComponentExist(ON.text(await getConfiguration()))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_004 end')
    })

    /**
     * 进入应用，测试getDeviceCapability接口
     */
    it(BUNDLE + 'CreateFunction_005', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_005 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getDeviceCapability接口返回值
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.capabilityDesc'))))
      await driver.assertComponentExist(ON.text(await getDeviceCapability()))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_005 end')
    })

    /**
     * 进入应用，测试getMediaContent接口
     */
    it(BUNDLE + 'CreateFunction_006', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_006 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getMediaContent接口返回值字节数
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mediaDesc'))))
      await driver.assertComponentExist(ON.text('6790'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_006 end')
    })

    /**
     * 进入应用，测试getMediaContentBase64接口
     */
    it(BUNDLE + 'CreateFunction_007', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_007 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getMediaContentBase64接口返回值长度
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mediaBase64Desc'))))
      await driver.assertComponentExist(ON.text('9078'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_007 end')
    })

    /**
     * 进入应用，测试getStringSync接口
     */
    it(BUNDLE + 'CreateFunction_008', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_008 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getStringSync接口返回的格式化字符串资源
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.formatStrDesc'))))
      await driver.assertComponentExist(ON.text(await getResourceFormatString($r('app.string.formatStr'),
        $r('app.string.world'))))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_008 end')
    })

    /**
     * 进入应用，测试getMediaContentBase64接口
     */
    it(BUNDLE + 'CreateFunction_009', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_009 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getMediaContentBase64接口返回的指定density图片资源
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.densityMediaDesc'))))
      await driver.assertComponentExist(ON.id('getDensityMedia'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_009 end')
    })

    /**
     * 进入应用，测试getSystemResourceManager接口
     */
    it(BUNDLE + 'CreateFunction_010', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_010 begin')
      let driver = await Driver.create()
      await driver.delayMs(3000)
      // 测试getSystemResourceManager接口获取系统资源管理对象，并获取系统资源图片
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.systemResDesc'))))
      await driver.assertComponentExist(ON.id('getSystemMedia'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_010 end')
    })
  })
}