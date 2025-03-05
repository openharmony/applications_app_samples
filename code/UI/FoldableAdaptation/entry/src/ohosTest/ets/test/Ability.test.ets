/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { beforeAll, describe, expect, it } from '@ohos/hypium';
import Logger from '../utils/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@kit.TestKit';

const TAG = '[Sample_FoldableAdaption]';
const CASE: string = 'FoldableAdaption'; // 案例名称
const CASE_NAME: string = '折叠屏适配'; // 案例中文名称
const DELAY_MS_2000: number = 2000; // 指定2000ms的延迟

export default function abilityTest() {
  const driver = Driver.create();
  describe('ActsAbilityTest', () => {
    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.foldableadaptation',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }
      await driver.delayMs(DELAY_MS_2000);
      Logger.info(TAG, 'beforeAll end');
      done();
    });

    /**
     * 双指捏合缩放图片
     * 通过图片顶部位置来判断是否缩放
     */
    it(CASE + '查看页面是否正常显示', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('MainSwiper'));
      await driver.assertComponentExist(ON.id('MainWaterFlow'));

      const mainSwiper = await driver.findComponent(ON.id('MainSwiper'));
      const waterFlowItem = await driver.findComponent(ON.id("WaterFlow0"));

      await mainSwiper.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await waterFlowItem.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);

      done();
    })

  })
}