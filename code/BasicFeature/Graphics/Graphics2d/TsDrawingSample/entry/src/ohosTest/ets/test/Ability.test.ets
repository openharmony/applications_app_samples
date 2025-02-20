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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog'

const TAG = '[Sample_DrawingAPI]';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it("StartAbility_001", 0, async (done: Function) => {
      hilog.info(0x0001, TAG, 'StartAbility_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      done();
      hilog.info(0x0001, TAG, 'StartAbility_001 end');
    })

    /**
     * 点击按钮，绘制路径
     */
    it('DrawPath_001', 2, async () => {
      hilog.info(0x0001, TAG, 'DrawPath_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.tsdrawingsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Path'));
      let drawPathBtn = await driver.findComponent(ON.text('Path'));
      // 点击'Path'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(0x0001, TAG, 'DrawPath_001 end');
    })

    /**
     * 点击按钮，绘制画布
     */
    it('DrawCanvas_001', 2, async () => {
      hilog.info(0x0001, TAG, 'DrawCanvas_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.tsdrawingsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Canvas'));
      let drawPathBtn = await driver.findComponent(ON.text('Canvas'));
      // 点击'Canvas'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(0x0001, TAG, 'DrawCanvas_001 end');
    })

    /**
     * 点击按钮，绘制文字和图片
     */
    it('ImageAndFont_001', 2, async () => {
      hilog.info(0x0001, TAG, 'ImageAndFont_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.tsdrawingsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Image and Font'));
      let drawPathBtn = await driver.findComponent(ON.text('Image and Font'));
      // 点击'Image and Font'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(0x0001, TAG, 'ImageAndFont_001 end');
    })
  })
}