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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import UIAbility from '@ohos.app.ability.UIAbility';

const TAG: string = '[Sample_MusicAlbum]';
const DOMAIN = 0xF811;
const BUNDLE = 'MusicAlbum_';
let ability: UIAbility;

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.MusicAlbum',
          abilityName: 'MainAbility'
        });
        done();
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection));
        done();
      }
      ability = await abilityDelegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 点击窗口化
     */
    it(BUNDLE + 'WindowSplitFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WindowSplitFunction_001 begin');
      let driver = await Driver.create();
      await driver.click(500, 500);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'WindowSplitFunction_001 end');
    })

    /**
     * 检查窗口
     */
    it(BUNDLE + 'WindowResumeFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WindowResumeFunction_001 begin');
      let driver = await Driver.create();
      let window = await driver.findWindow({
        bundleName: 'ohos.samples.MusicAlbum'
      });
      let boundsBefore = await window.getBounds();
      hilog.info(DOMAIN, TAG, BUNDLE + JSON.stringify(boundsBefore));
      // 检查窗口化
      await window.resume();
      await driver.delayMs(1000);
      let boundsAfter = await window.getBounds();
      expect(boundsBefore.bottom - boundsBefore.top).assertLarger(boundsAfter.bottom - boundsAfter.top);
      expect(boundsBefore.right - boundsBefore.left).assertLarger(boundsAfter.right - boundsAfter.left);
      // 检查窗口拖动
      await driver.drag(boundsAfter.left + 30, boundsAfter.top + 15, 100, 100, 100);
      await driver.delayMs(1000);
      let boundsMove = await window.getBounds();
      expect(boundsAfter.top).assertLarger(boundsMove.top);
      expect(boundsAfter.right).assertLarger(boundsMove.right);
      await driver.delayMs(1000);
      await window.resume();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'WindowResumeFunction_001 end');
    })
  })
}