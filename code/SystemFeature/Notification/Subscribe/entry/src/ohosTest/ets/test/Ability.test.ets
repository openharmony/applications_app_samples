/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest'
import { BusinessError } from '@ohos.base';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const TAG = '[Sample_Subscribe]';
const DOMAIN = 0xF811;
const BUNDLE = 'Subscribe_';
const TIMEOUT_ONE = 1000;
const TIMEOUT_TWO = 2000;
const TIMEOUT_THREE = 3000;
const TIMEOUT_FOUR = 4000;
const PUBLISH_BUNDLE_NAME = 'com.samples.notificationpublish';
const SUBSCRIBE_BUNDLE_NAME = 'com.samples.notificationsubscribe';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 测试实况通知交互
     */
    it(BUNDLE + 'LiveView_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'test start');
      let driver: Driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      await driver.delayMs(TIMEOUT_ONE);
      await abilityDelegator.startAbility({
        bundleName: SUBSCRIBE_BUNDLE_NAME,
        abilityName: 'EntryAbility'
      })
      await driver.delayMs(TIMEOUT_ONE);
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.subscribeNotification'))))
        .then(async (data) => {
          await data.click()
        })
      await driver.delayMs(TIMEOUT_THREE);
      await abilityDelegator.startAbility({
        bundleName: PUBLISH_BUNDLE_NAME,
        abilityName: 'EntryAbility'
      })
      await driver.delayMs(TIMEOUT_TWO);
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.subscribeButton'))))
        .then(async (data) => {
          await data.click()
        })
      await driver.delayMs(TIMEOUT_TWO);
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.publishNotification'))))
        .then(async (data) => {
          await data.click()
        })
      hilog.info(DOMAIN, TAG, '%{public}s', 'findComponent 3');
      await driver.delayMs(TIMEOUT_FOUR)
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
        .then(async (data) => {
          if (data != null) {
            await data.click()
          }
        })
      await driver.delayMs(TIMEOUT_TWO)
      await abilityDelegator.startAbility({
        bundleName: SUBSCRIBE_BUNDLE_NAME,
        abilityName: 'EntryAbility'
      })
      await driver.delayMs(TIMEOUT_ONE)
      await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.pullNotification'))))
        .then(async (data) => {
          await data.click()
        })
      await driver.delayMs(TIMEOUT_ONE)
      await abilityDelegator.startAbility({
        bundleName: PUBLISH_BUNDLE_NAME,
        abilityName: 'EntryAbility'
      })
      await driver.delayMs(TIMEOUT_ONE)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.notificationTitle'))))
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, '%{public}s', 'can not find contentTitle exist:' + err.code);
          expect().assertFail()
        })
      await driver.assertComponentExist(ON.text('pullNot："content"')).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, '%{public}s', 'can not find content exist:' + err.code);
        expect().assertFail()
      })
      hilog.info(DOMAIN, TAG, '%{public}s', 'test end');
      done()
    })
  })
}