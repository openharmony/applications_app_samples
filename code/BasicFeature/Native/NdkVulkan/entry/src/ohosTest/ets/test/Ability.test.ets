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
import { describe, it, expect, TestType } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import { Driver, ON } from '@ohos.UiTest'
import hilog from '@ohos.hilog';

const delegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

const TAG = '[Sample_ndkvulkan]';
const DOMAIN = 0XF811;
const BUNDLE = "ndkvulkan_";

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number:StartAbility_001
     * @tc.name: OpenHap
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 打开应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, begin');
      //start tested ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      await sleep(1000);
      //check top display ability
      await delegator.getCurrentTopAbility().then((Ability: UIAbility) => {
        console.info("get top ability");
        hilog.info(DOMAIN, TAG, BUNDLE + Ability.context.abilityInfo.name);
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002, end');
        done();
      })
      //ui test code

      /**
       * @tc.number:StartAbility_002
       * @tc.name: clickButton
       * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
       * @tc.desc: 点击'stop/start'按键使三角形停止旋转
       */
      it('StartAbility_002', TestType.FUNCTION, async (done: Function) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002, begin');
        let driver = Driver.create();
        expect(driver).not().assertNull();
        // get the button with text "stop/start"
        let button = await driver.findComponent(ON.text('stop/start'));
        // check the button is found and clickable
        expect(button).not().assertNull();
        expect(true).assertEqual(await button.isClickable());
        // click the button to stop the triangle
        await button.click();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002, end');
        done();
      })

      /**
       * @tc.number:StartAbility_003
       * @tc.name: clickButton
       * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
       * @tc.desc: 点击'stop/start'按键使三角形重新开始旋转
       */
      it('StartAbility_003', TestType.FUNCTION, async (done: Function) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_003, begin');
        let driver = Driver.create();
        expect(driver).not().assertNull();
        // get the button with text "stop/start"
        let button = await driver.findComponent(ON.text('stop/start'));
        // check the button is found and clickable
        expect(button).not().assertNull();
        expect(true).assertEqual(await button.isClickable());
        // click the button to rotate the triangle
        await button.click();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_003, end');
        done();
      });
    })
  })
}
