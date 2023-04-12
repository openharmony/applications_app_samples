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
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Process]'
const DOMAIN = 0xF811
const BUNDLE = 'Process_'

export default function appTest() {
  describe('abilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.process",
        abilityName: "EntryAbility"
      }, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin, err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * Process
     */
    it(BUNDLE + 'ProcessFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 获取当前系统运行时间
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 getUptime')
      await driver.assertComponentExist(BY.key('getUptime'))
      let getUptime = await driver.findComponent(BY.key('getUptime'))
      await getUptime.click()
      await driver.delayMs(1000)
      // 获取进程当前工作目录
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 getDirectory')
      await driver.assertComponentExist(BY.key('getDirectory'))
      let getDirectory = await driver.findComponent(BY.key('getDirectory'))
      await getDirectory.click()
      await driver.delayMs(1000)
      // 更改进程当前工作目录
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 changeDirectory')
      await driver.assertComponentExist(BY.key('changeDirectory'))
      let changeDirectory = await driver.findComponent(BY.key('changeDirectory'))
      await changeDirectory.click()
      await driver.delayMs(1000)
      // 发送signal到指定的进程
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 sendSignal')
      await driver.assertComponentExist(BY.key('sendSignal'))
      let sendSignal = await driver.findComponent(BY.key('sendSignal'))
      await sendSignal.click()
      await driver.delayMs(1000)
      // 启动一个子进程
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 startProcess')
      await driver.assertComponentExist(BY.key('startProcess'))
      let startProcess = await driver.findComponent(BY.key('startProcess'))
      await startProcess.click()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 end')
    })
  })
}