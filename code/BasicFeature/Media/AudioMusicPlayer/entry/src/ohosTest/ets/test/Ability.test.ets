/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { display } from '@kit.ArkUI';

const TAG = '[SampleDemoTest]';
const DOMAIN = 0x0000;
const DRIVER = Driver.create();
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString<T extends Resource>(resource: T): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    beforeAll(() => {
      hilog.info(DOMAIN, TAG, 'beforeAll called');
    });

    beforeEach(() => {
      hilog.info(DOMAIN, TAG, 'beforeEach called');
    });

    afterEach(() => {
      hilog.info(DOMAIN, TAG, 'afterEach called');
    });

    afterAll(() => {
      hilog.info(DOMAIN, TAG, 'afterAll called');
    });

    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.audiomusicplayer',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (exception) {
        hilog.error(DOMAIN, TAG, 'StartAbility_001 exception: %{public}s', JSON.stringify(exception));
        expect().assertFail();
        done();
      }
      hilog.info(DOMAIN, TAG, 'StartAbility_001 end');
    });

    it('MainPageShow_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'MainPageShow_001 begin');
      await DRIVER.delayMs(2000);
      await DRIVER.assertComponentExist(ON.id('playerInfoComponent'));
      hilog.info(DOMAIN, TAG, 'MainPageShow_001 end');
      done();
    });

    it('MusicInfoShow_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'MusicInfoShow_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('musicCover'));
      await DRIVER.assertComponentExist(ON.id('songTitle'));
      await DRIVER.assertComponentExist(ON.id('singerName'));
      hilog.info(DOMAIN, TAG, 'MusicInfoShow_001 end');
      done();
    });

    it('ControlAreaShow_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlAreaShow_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('playButton'));
      await DRIVER.assertComponentExist(ON.id('prevButton'));
      await DRIVER.assertComponentExist(ON.id('nextButton'));
      await DRIVER.assertComponentExist(ON.id('playModeButton'));
      await DRIVER.assertComponentExist(ON.id('progressSlider'));
      hilog.info(DOMAIN, TAG, 'ControlAreaShow_001 end');
      done();
    });

    it('PlayPause_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'PlayPause_001 begin');
      await DRIVER.delayMs(1000);
      let playBtn = await DRIVER.findComponent(ON.id('playButton'));
      await playBtn.click();
      await DRIVER.delayMs(1000);
      await playBtn.click();
      hilog.info(DOMAIN, TAG, 'PlayPause_001 end');
      done();
    });

    it('NextMusic_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'NextMusic_001 begin');
      await DRIVER.delayMs(1000);
      let nextBtn = await DRIVER.findComponent(ON.id('nextButton'));
      await nextBtn.click();
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'NextMusic_001 end');
      done();
    });

    it('PreviousMusic_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'PreviousMusic_001 begin');
      await DRIVER.delayMs(1000);
      let prevBtn = await DRIVER.findComponent(ON.id('prevButton'));
      await prevBtn.click();
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'PreviousMusic_001 end');
      done();
    });

    it('PlayModeSwitch_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'PlayModeSwitch_001 begin');
      await DRIVER.delayMs(1000);
      let modeBtn = await DRIVER.findComponent(ON.id('playModeButton'));
      await modeBtn.click();
      await DRIVER.delayMs(1000);
      await modeBtn.click();
      await DRIVER.delayMs(1000);
      await modeBtn.click();
      hilog.info(DOMAIN, TAG, 'PlayModeSwitch_001 end');
      done();
    });

    it('SilentMode_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'SilentMode_001 begin');
      await DRIVER.delayMs(1000);
      let silentBtn = await DRIVER.findComponent(ON.id('silentButton'));
      await silentBtn.click();
      await DRIVER.delayMs(1000);
      await silentBtn.click();
      hilog.info(DOMAIN, TAG, 'SilentMode_001 end');
      done();
    });

    it('VolumeSetting_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'VolumeSetting_001 begin');
      await DRIVER.delayMs(2000);
      let volumeBtn = await DRIVER.findComponent(ON.id('volumeButton'));
      await volumeBtn.click();
      await DRIVER.delayMs(3000);
      await DRIVER.assertComponentExist(ON.id('volumeSlider'));
      await DRIVER.pressBack();
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VolumeSetting_001 end');
      done();
    });

    it('SpeedSetting_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'SpeedSetting_001 begin');
      await DRIVER.delayMs(2000);
      let speedBtn = await DRIVER.findComponent(ON.id('speedButton'));
      await speedBtn.click();
      await DRIVER.delayMs(3000);
      await DRIVER.assertComponentExist(ON.id('speedSlider'));
      await DRIVER.pressBack();
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'SpeedSetting_001 end');
      done();
    });

    it('EffectToggle_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'EffectToggle_001 begin');
      await DRIVER.delayMs(2000);
      let effectBtn = await DRIVER.findComponent(ON.id('effectButton'));
      await effectBtn.click();
      await DRIVER.delayMs(3000);
      await DRIVER.assertComponentExist(ON.id('effectToggle'));
      await DRIVER.pressBack();
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'EffectToggle_001 end');
      done();
    });

    it('FavoriteToggle_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'FavoriteToggle_001 begin');
      await DRIVER.delayMs(1000);
      let favoriteBtn = await DRIVER.findComponent(ON.id('favoriteButton'));
      await favoriteBtn.click();
      await DRIVER.delayMs(1000);
      await favoriteBtn.click();
      hilog.info(DOMAIN, TAG, 'FavoriteToggle_001 end');
      done();
    });

    it('LyricsPage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'LyricsPage_001 begin');
      await DRIVER.delayMs(2000);
      let swiper = await DRIVER.findComponent(ON.id('mainSwiper'));
      let bounds = await swiper.getBoundsCenter();
      await DRIVER.swipe(bounds.x + 500, bounds.y, bounds.x - 500, bounds.y);
      await DRIVER.delayMs(3000);
      await DRIVER.assertComponentExist(ON.id('lyricsComponent'));
      hilog.info(DOMAIN, TAG, 'LyricsPage_001 end');
      done();
    });

    it('ProgressSlider_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ProgressSlider_001 begin');
      await DRIVER.delayMs(1000);
      let slider = await DRIVER.findComponent(ON.id('progressSlider'));
      let bounds = await slider.getBoundsCenter();
      await DRIVER.swipe(bounds.x - 50, bounds.y, bounds.x + 50, bounds.y);
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'ProgressSlider_001 end');
      done();
    });

    it('PlayListShow_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'PlayListShow_001 begin');
      await DRIVER.delayMs(1000);
      let listBtn = await DRIVER.findComponent(ON.id('playListButton'));
      await listBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('playListTitle'));
      hilog.info(DOMAIN, TAG, 'PlayListShow_001 end');
      done();
    });
  });
}