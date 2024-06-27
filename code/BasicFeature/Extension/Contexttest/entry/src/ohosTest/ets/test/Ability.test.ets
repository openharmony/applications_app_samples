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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { BusinessError } from '@ohos.base';
import { describe, it, expect, beforeAll, beforeEach, afterEach } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest'

const SUBSCRIBE_BUNDLE_NAME = 'com.example.contexttest';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let driver: Driver = Driver.create();
let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
const INPUTSTOP = 'aa stop-service -a inputMethod -b com.example.contexttest';
const INPUTONESTOP = 'aa stop-service -a inputMethod1 -b com.example.contexttest';
const INPUTSTART = 'aa start -a inputMethod -b com.example.contexttest';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async () => {
      await abilityDelegator.startAbility({
        bundleName: SUBSCRIBE_BUNDLE_NAME,
        abilityName: 'EntryAbility'
      })
      await driver.delayMs(1000);
    })
    beforeEach(async () => {
      await abilityDelegator.executeShellCommand('hilog -r')
    })
    afterEach(async () => {
      await abilityDelegator.executeShellCommand(INPUTSTOP)
      await abilityDelegator.executeShellCommand(INPUTONESTOP)
    })

    /**
     * inputmethod访问其配置groupId为test1的宿主应用的共享沙箱成功
     */
    it('Extension_Course_Test_AbilityContext_0100', 0, async (done: Function) => {
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.SharedFileSuccess'))))
        .then(async (data) => {
          await data.click();
        })
      await driver.delayMs(1000);
      await abilityDelegator.executeShellCommand(INPUTSTART)
        .then((data) => {
        })
      await driver.delayMs(1000);
      await abilityDelegator.executeShellCommand("hilog -x | grep '1:inputMethod Try to write str.'")
        .then((data) => {
          let std = data.stdResult;
          let str = (std.split('file:1:')[1].split('str.')[0]) + 'str.';
          expect(str === 'inputMethod Try to write str.').assertTrue();
          done();
        })
    })

    /**
     * inputmethod访问其配置groupId为test1的宿主应用的共享沙箱失败
     */
    it('Extension_Course_Test_AbilityContext_0200', 0, async (done: Function) => {
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.SharedFileFail'))))
        .then(async (data) => {
          await data.click();
        })
      await driver.delayMs(1000);
      await abilityDelegator.executeShellCommand(INPUTSTART)
      await driver.delayMs(4000);
      await abilityDelegator.executeShellCommand('hilog -x | grep 13900002')
        .then((data) => {
          let std = data.stdResult;
          let str = (std.split("139"))[1];
          let strResult = '139' + str.split('002')[0] + '002';
          expect(strResult === '13900002').assertTrue();
          done();
        })
    })

    /**
     * uiability访问inputmethod module级别的独立extension的沙箱文件
     */
    it('Extension_Course_Test_AbilityContext_0300', 0, async (done: Function) => {
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.InterviewModuleExtension'))))
        .then(async (data) => {
          await data.click();
        })
      await driver.delayMs(1000);
      await abilityDelegator.executeShellCommand(INPUTSTART)
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('moduleFailed')).catch((err: BusinessError) => {
        expect().assertFailed();
      })
      done();
    })

    /**
     * uiability访问inputmethod 应用级别的独立extension的沙箱文件
     */
    it('Extension_Course_Test_AbilityContext_0400', 0, async (done: Function) => {
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.InterviewApplyExtension'))))
        .then(async (data) => {
          await data.click();
        })
      await driver.delayMs(1000);
      await abilityDelegator.executeShellCommand(INPUTSTART)
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('appFailed')).catch((err: BusinessError) => {
        expect().assertFailed();
      })
      done();
    })
  })
}