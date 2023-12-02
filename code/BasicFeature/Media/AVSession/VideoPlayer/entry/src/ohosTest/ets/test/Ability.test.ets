/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {Driver, ON, MatchPattern} from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'

const TAG: string = 'VideoPlayer';
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const BUNDLE = 'VideoPlayer_';

export default function abilityTest() {

  describe('ActsAbilityTest', () => {

    /**
     * open_sample
     */
    it(BUNDLE +'StartAbility_001', 0, async (done: Function) => {
      hilog.info(0x0, TAG, 'StartAbility_001 start');
      await abilityDelegator.startAbility({
        bundleName: 'com.samples.videoplayer',
        abilityName: 'EntryAbility'
      })
      hilog.info(0x0, TAG, 'StartAbility_001 end');
      done();
    })

    /**
     * music_last
     */
    it(BUNDLE + 'music_last', 0, async (done: Function) => {
      hilog.info(0x0, TAG, 'music_last start');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('music_last'));
      let lastButton = await driver.findComponent(ON.id('music_last'));
      await lastButton.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('music_play_or_pause'));
      let playOrPause = await driver.findComponent(ON.id('music_play_or_pause'));
      await playOrPause.click();
      await driver.delayMs(1000);
      await playOrPause.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('music_next'));
      let nextButton = await driver.findComponent(ON.id('music_next'));
      await nextButton.click();
      await driver.delayMs(1000);
      hilog.info(0x0, TAG, 'music_last end');
      done();
    })
  })
}