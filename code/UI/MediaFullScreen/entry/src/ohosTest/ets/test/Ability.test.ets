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
import Logger from '../utils/Logger';
import { Component, DisplayRotation, Driver, MatchPattern, ON } from '@kit.TestKit';
import { beforeAll, expect } from '@ohos/hypium';
import { describe } from '@ohos/hypium';
import { it } from '@ohos/hypium';

const TAG = '[Sample_MediaFullscreen]';
const DELAY_MS_500: number = 500; // 指定500ms的延迟
const DELAY_MS_2000: number = 2000; // 指定2000ms的延迟

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.mediafullscreen',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }
      await driver.delayMs(DELAY_MS_2000);
      Logger.info(TAG, 'beforeAll end');
      done();
    });

    const driver: Driver = Driver.create();

    /**
     * 点击图片打开视频。
     */
    it('TestOpenVideo', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('mediaPic1'));
      let videoPic = await driver.findComponent(ON.id('mediaPic1'));
      await videoPic.click();
      await driver.delayMs(5000);
      await driver.assertComponentExist(ON.text('media_full_screen_video', MatchPattern.CONTAINS));
      done();
    })

    /**
     * 视频正常播放，窗口为横屏状态。
     */
    it('TestChangeToHorizontal', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('playingIcon'));
      let rotation = await driver.getDisplayRotation();
      expect(rotation === DisplayRotation.ROTATION_90 || rotation === DisplayRotation.ROTATION_270).assertTrue();
      done();
    })

    /**
     * 视频正常缩小，窗口恢复原本状态。
     */
    it('TestRestToNormal', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('collapseVideoButton'));
      let videoPic = await driver.findComponent(ON.id('collapseVideoButton'));
      await videoPic.click();
      await driver.delayMs(3000);
      let rotation = await driver.getDisplayRotation();
      expect(rotation == DisplayRotation.ROTATION_0).assertTrue();
      done();
    })
  })
}