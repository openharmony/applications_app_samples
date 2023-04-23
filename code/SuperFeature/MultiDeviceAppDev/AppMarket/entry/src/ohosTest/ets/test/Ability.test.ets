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

import { describe, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../util/Logger';

const TAG: string = '[Sample_AppMarket]';
const BUNDLE = 'AppMarket_';

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.appmarket',
          abilityName: 'MainAbility'
        })
        done();
      } catch (expection) {
        logger.info(TAG, `StartAbility end ${JSON.stringify(expection)}`);
        done();
      }
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
    })

    /**
     * 关闭窗口
     */
    it(BUNDLE + 'CloseWindowFunction_001', 0, async () => {
      logger.info(TAG, `${BUNDLE}CloseWindowFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      let window = await driver.findWindow({
        actived: true
      });
      await window.close();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}CloseWindowFunction_001 end`);
    })

    /**
     * 最小化窗口
     */
    it(BUNDLE + 'MinimizeWindowFunction_001', 0, async () => {
      logger.info(TAG, `${BUNDLE}MinimizeWindowFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      let appMarket = await driver.findComponent(ON.text('AppMarket'));
      await appMarket.click();
      await driver.delayMs(200);
      let window = await driver.findWindow({
        actived: true
      });
      await window.minimize();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}MinimizeWindowFunction_001 end`);
    })

    /**
     * 窗口分屏
     */
    it(BUNDLE + 'SplitWindowFunction_001', 0, async () => {
      logger.info(TAG, `${BUNDLE}SplitWindowFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      let appMarket = await driver.findComponent(ON.text('AppMarket'));
      await appMarket.click();
      await driver.delayMs(200);
      let window = await driver.findWindow({
        actived: true
      });
      await window.split();
      await driver.delayMs(200);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}SplitWindowFunction_001 end`);
    })
  })
}