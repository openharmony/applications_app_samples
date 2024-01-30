/*
* Copyright (C) 2023-2024 Huawei Device Co., Ltd.
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
import Logger from '../utils/Logger';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  const TAG = '[System_Audio]';
  const BUNDLE = 'System_audio_';
  let driver: Driver;
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.audio',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
    })

    it(BUNDLE + 'IndexShow_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'IndexShow_001 begin');
      try {
        driver = Driver.create();
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'spatial_audio_card');
        await driver.assertComponentExist(ON.id('spatial_audio_card'));
        let spatialAudioCardComponent = await driver.findComponent(ON.id('spatial_audio_card'));
        await spatialAudioCardComponent.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_001 end');
      done();
    })

    it(BUNDLE + 'SpatialAudio_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SpatialAudio_001 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + '2P0_play_btn');
        await driver.assertComponentExist(ON.id('2P0_play_btn'));
        let playBtn2P0 = await driver.findComponent(ON.id('2P0_play_btn'));
        await playBtn2P0.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('2P0_pause_btn'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'SpatialAudio_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'SpatialAudio_001 end');
      done();
    })

    it(BUNDLE + 'SpatialAudio_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SpatialAudio_002 begin');
      try {
        await driver.delayMs(1000);
        let PlayBtn5P1 = await driver.findComponent(ON.id('2P0_pause_btn'));
        await PlayBtn5P1.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('2P0_play_btn'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'SpatialAudio_002 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'SpatialAudio_002 end');
      done();
    })

    it(BUNDLE + 'SpatialAudio_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SpatialAudio_003 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + '5P1_play_btn');
        await driver.assertComponentExist(ON.id('5P1_play_btn'));
        let playBtn2P0 = await driver.findComponent(ON.id('5P1_play_btn'));
        await playBtn2P0.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('5P1_pause_btn'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'SpatialAudio_003 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'SpatialAudio_003 end');
      done();
    })

    it(BUNDLE + 'SpatialAudio_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SpatialAudio_004 begin');
      try {
        await driver.delayMs(1000);
        let PlayBtn5P1 = await driver.findComponent(ON.id('5P1_pause_btn'));
        await PlayBtn5P1.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('5P1_play_btn'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'SpatialAudio_004 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'SpatialAudio_004 end');
      done();
    })

    it(BUNDLE + 'SpatialAudio_005', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SpatialAudio_005 begin');
      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('close_mode_on'));
        await driver.assertComponentExist(ON.id('open_mode_disabled'));
        await driver.assertComponentExist(ON.id('tracking_mode_disabled'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'SpatialAudio_005 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'SpatialAudio_005 end');
      done();
    })

    it(BUNDLE + 'SpatialAudio_006', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SpatialAudio_006 begin');
      try {
        await driver.delayMs(1000);
        let SpatialBackBtn = await driver.findComponent(ON.id('spatial_audio_back_btn'));
        await SpatialBackBtn.click();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'SpatialAudio_006 err:' + JSON.stringify(err));
        expect(false).assertTrue();

      }
      Logger.info(TAG, BUNDLE + 'SpatialAudio_006 end');
      done();
    })
  })
}