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

import { it, expect, describe } from '@ohos/hypium'
import { Driver, ON, } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '{Sample_AppMyXComponent]'
const BUNDLE_NAME = 'com.example.myxcompoent';
const ABILITY_NAME = 'EntryAbility';
const DOMAIN = 0xE629;

interface wantType {
  bundleName: string;
  abilityName: string
}

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {

    /**
     * @tc.name: ActsAbilityTest_StartAbility_001
     * @tc.desc: 跳转到EntryAbility
     * @tc.type: FUNC
     * @tc.require: 成功跳转到EntryAbility
     * @tc.level: normal
     * @tc.size: 1
     * @tc.number: 1
     */
    it('ActsAbilityTest_StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, `${BUNDLE_NAME} StartAbility_001 begin`);
      let want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      } as wantType;
      delegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, `${BUNDLE_NAME} startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, `${BUNDLE_NAME} StartAbility_001 end`);
      done();
    })

    /**
     * @tc.name: ActsAbilityTest_StartAbility_Click_001
     * @tc.desc: 点击界面上的DrawTransform按钮
     * @tc.type: FUNC
     * @tc.require: 点击成功， 并切换到矩形旋转界面
     * @tc.level: normal
     * @tc.size: 1
     * @tc.number: 1
     */
    it('ActsAbilityTest_StartAbility_Click_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_001 begin');

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawTransform'));
        let button = await driver.findComponent(ON.id('DrawTransform'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `click_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_001 end');
    });

    /**
     * @tc.name: ActsAbilityTest_StartAbility_Click_002
     * @tc.desc: 点击界面上的DrawCube按钮
     * @tc.type: FUNC
     * @tc.require: 点击成功， 并切换到立体矩形界面
     * @tc.level: normal
     * @tc.size: 1
     * @tc.number: 1
     */
    it('ActsAbilityTest_StartAbility_Click_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_002 begin');

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawCube'));
        let button = await driver.findComponent(ON.id('DrawCube'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `click_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_002 end');
    });

    /**
     * @tc.name: ActsAbilityTest_StartAbility_Click_003
     * @tc.desc: 点击界面上的DrawTransform按钮
     * @tc.type: FUNC
     * @tc.require: 点击成功， 并切换到矩形旋转界面
     * @tc.level: normal
     * @tc.size: 1
     * @tc.number: 1
     */
    it('ActsAbilityTest_StartAbility_Click_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_003 begin');

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawTransform'));
        let button = await driver.findComponent(ON.id('DrawTransform'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `click_003 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_003 end');
    });
  });
}
