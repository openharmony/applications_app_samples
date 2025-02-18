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
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../utils/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_ImageViewer]';
const CASE: string = 'imageviewer'; // 案例名称
const CASE_NAME: string = '图片缩放效果实现'; // 案例中文名称
const DELAY_MS_2000: number = 2000; // 指定2000ms的延迟

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.imageviewer',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }
      await driver.delayMs(DELAY_MS_2000);
      Logger.info(TAG, 'beforeAll end');
      done();
    });

    const driver = Driver.create();

    /**
     * 双指捏合缩放图片
     * 通过图片顶部位置来判断是否缩放
     */
    it(CASE + '双指捏合缩放图片', 0, async (done: Function) => {
      const image = await driver.findComponent(ON.id('scale_image'));
      const beforeTop = (await image.getBounds()).top;
      await image.pinchOut(1.1);
      const afterTop = (await image.getBounds()).top;
      await expect(afterTop < beforeTop).assertEqual(true); // 通过图片顶部位置来判断
      await driver.delayMs(500);
      done();
    })

    /**
     * 放大状态下，单指可拖动图片
     */
    it(CASE + '单指拖动图片', 0, async (done: Function) => {
      const image = await driver.findComponent(ON.id('scale_image'));
      const beforeBottom = (await image.getBounds()).bottom;
      await driver.swipe(240, 360, 240, 300);
      const afterBottom = (await image.getBounds()).bottom;
      await expect(afterBottom < beforeBottom).assertEqual(true); // 通过图片中部位置来判断是否拖动
      await driver.delayMs(500);
      done();
    })

    /**
     * 双击图片进行图片的大小切换
     */
    it(CASE + '双击图片大小切换', 0, async (done: Function) => {
      const image = await driver.findComponent(ON.id('scale_image'));
      const beforeTop = (await image.getBounds()).top;
      await image.doubleClick();
      const afterTop = (await image.getBounds()).top;
      await expect(afterTop > beforeTop).assertEqual(true); // 通过图片中部位置来判断图片大小是否改变
      await driver.delayMs(500);
      done();
    })
  })
}