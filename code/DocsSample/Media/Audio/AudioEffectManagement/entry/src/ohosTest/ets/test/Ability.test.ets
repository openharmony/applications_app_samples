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

import Logger from '../utils/Logger';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  const TAG = '[Sample_Audio]';
  const BUNDLE = 'audio_';
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

    /**
     * StartAbility
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.audioeffect',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * [Index]
     * Display entry card
     * Click audio_effect_manager_card
     */
    it(BUNDLE + 'IndexShow_001', 0, async (done: Function) => {
      driver = Driver.create();
      Logger.info(TAG, BUNDLE + 'IndexShow_001 begin');
      try {
        await driver.delayMs(500);
        Logger.info(TAG, BUNDLE + 'audio_effect_manager_card');
        await driver.assertComponentExist(ON.id('audio_effect_manager_card'));
        let audioEffectManagerCardComponent = await driver.findComponent(ON.id('audio_effect_manager_card'));
        await audioEffectManagerCardComponent.click();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_001 end');
      done();
    })

    /**
     * [Preset]
     * Display Preset Page
     */
    it(BUNDLE + 'Preset_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Preset_001 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'back_btn_preset');
        await driver.assertComponentExist(ON.id('back_btn_preset'));
        Logger.info(TAG, BUNDLE + 'select_content_preset');
        await driver.assertComponentExist(ON.id('select_content_preset'));
        Logger.info(TAG, BUNDLE + 'select_usage_preset');
        await driver.assertComponentExist(ON.id('select_usage_preset'));
        Logger.info(TAG, BUNDLE + 'query_btn_preset');
        await driver.assertComponentExist(ON.id('query_btn_preset'));
        Logger.info(TAG, BUNDLE + 'query_result_preset');
        await driver.assertComponentExist(ON.id('query_result_preset'));
        Logger.info(TAG, BUNDLE + 'switch_btn_preset');
        await driver.assertComponentExist(ON.id('switch_btn_preset'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Preset_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Preset_001 end');
      done();
    })

    /**
     * [Preset]
     * choose from the two selection boxes
     * assure the conditions to be seen in the boxes*/
    it(BUNDLE + 'Preset_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Preset_002 begin');
      try {
        await driver.delayMs(1000);
        let selectContentPreset = await driver.findComponent(ON.id('select_content_preset'));
        await selectContentPreset.click();
        await driver.delayMs(500);
        await driver.click(180, 400); // content type selection, only for rk3568
        await driver.delayMs(500);
        let selectUsagePreset = await driver.findComponent(ON.id('select_usage_preset'));
        await selectUsagePreset.click();
        await driver.delayMs(500);
        await driver.click(500, 500); // usage selection, only for rk3568
        await driver.delayMs(2000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Preset_002 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Preset_002 end');
      done();
    })

    /**
     * [Preset]
     * click the query button and the result shows in the text
     */
    it(BUNDLE + 'Preset_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Preset_003 begin');
      try {
        await driver.delayMs(1000);
        let queryBtnPreset = await driver.findComponent(ON.id('query_btn_preset'));
        await queryBtnPreset.click();
        await driver.delayMs(500);
        let queryResultPreset = await driver.findComponent(ON.id('query_result_preset'));
        let queryResultText = await queryResultPreset.getText();
        Logger.info(TAG, BUNDLE + 'queryResultText:' + queryResultText);
        expect(queryResultText !== '--').assertTrue();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Preset_003 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Preset_003 end');
      done();
    })

    /**
     * [Preset] change the content type or stream usage
     * check whether the query result changes to '--'
     */
    it(BUNDLE + 'Preset_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Preset_004 begin');
      try {
        await driver.delayMs(1000);

        let selectUsagePreset = await driver.findComponent(ON.id('select_usage_preset'));
        await selectUsagePreset.click();
        await driver.delayMs(500);
        await driver.click(500, 300); // usage selection, only for rk3568
        await driver.delayMs(500);
        let queryResultPreset = await driver.findComponent(ON.id('query_result_preset'));
        let queryResultText = await queryResultPreset.getText();
        expect('--').assertEqual(queryResultText);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Preset_004 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Preset_004 end');
      done();
    })

    /*
     * [Preset] execute query again
     * check the result
     */
    it(BUNDLE + 'Preset_005', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Preset_005 begin');
      try {
        await driver.delayMs(1000);
        let queryBtnPreset = await driver.findComponent(ON.id('query_btn_preset'));
        await queryBtnPreset.click();
        await driver.delayMs(500);
        let queryResultPreset = await driver.findComponent(ON.id('query_result_preset'));
        let queryResultText = await queryResultPreset.getText();
        Logger.info(TAG, BUNDLE + 'queryResultText:' + queryResultText);
        expect(queryResultText !== '--').assertTrue();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Preset_005 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Preset_005 end');
      done();
    })

    /*
     * [Realtime] switch page
     * assert the items
     */
    it(BUNDLE + 'Realtime_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_001 begin');
      try {
        await driver.delayMs(500);
        let SwitchBtnPreset = await driver.findComponent(ON.id('switch_btn_preset'));
        await SwitchBtnPreset.click();
        await driver.delayMs(500);
        Logger.info(TAG, BUNDLE + 'back_btn_realtime');
        await driver.assertComponentExist(ON.id('back_btn_realtime'));
        Logger.info(TAG, BUNDLE + 'select_content_realtime');
        await driver.assertComponentExist(ON.id('select_content_realtime'));
        Logger.info(TAG, BUNDLE + 'select_usage_realtime');
        await driver.assertComponentExist(ON.id('select_usage_realtime'));
        Logger.info(TAG, BUNDLE + 'play_pause_realtime');
        await driver.assertComponentExist(ON.id('play_pause_realtime'));

      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_001:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_001 end');
      done();
    })

    /*
     * [Realtime] assert the items2
     */
    it(BUNDLE + 'Realtime_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_002 begin');
      try {
        await driver.delayMs(500);
        Logger.info(TAG, BUNDLE + 'query_btn_realtime');
        await driver.assertComponentExist(ON.id('query_btn_realtime'));
        Logger.info(TAG, BUNDLE + 'query_result_realtime');
        await driver.assertComponentExist(ON.id('query_result_realtime'));
        Logger.info(TAG, BUNDLE + 'select_mode_realtime');
        await driver.assertComponentExist(ON.id('select_mode_realtime'));
        Logger.info(TAG, BUNDLE + 'switch_btn_realtime');
        await driver.assertComponentExist(ON.id('switch_btn_realtime'));

      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_002:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_002 end');
      done();
    })

    /*
    [Realtime] choose content type and stream usage
     */
    it(BUNDLE + 'Realtime_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_003 begin');
      try {

        let selectContentRealtime = await driver.findComponent(ON.id('select_content_realtime'));
        let selectUsageRealtime = await driver.findComponent(ON.id('select_usage_realtime'));
        await selectContentRealtime.click();
        await driver.delayMs(500);
        await driver.click(180, 400); // content type selection, only for rk3568
        await driver.delayMs(500);
        await selectUsageRealtime.click();
        await driver.delayMs(500);
        await driver.click(500, 500); // usage selection, only for rk3568
        await driver.delayMs(500);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_003:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_003 end');
      done();

    })

    /*
     * [Realtime] click the play button and the audio starts to play
     * the selections are banned
     */
    it(BUNDLE + 'Realtime_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_004 begin');
      try {
        let selectContentRealtime = await driver.findComponent(ON.id('select_content_realtime'));
        let selectUsageRealtime = await driver.findComponent(ON.id('select_usage_realtime'));
        let playPauseRealtime = await driver.findComponent(ON.id('play_pause_realtime'));
        await playPauseRealtime.click();

        let audioPlayState = await driver.findComponent(ON.id('audio_play_state'));
        let audioPlayStateText = await audioPlayState.getText();
        Logger.info(TAG, BUNDLE + 'audioPlayStateText:' + audioPlayStateText);
        expect('onPlaying').assertEqual(audioPlayStateText);

        let selectContentRealtimeState = await selectContentRealtime.isEnabled();
        Logger.info(TAG, BUNDLE + 'selectContentRealtimeState:' + selectContentRealtimeState);
        expect(false).assertEqual(selectContentRealtimeState);
        let selectUsageRealtimeState = await selectUsageRealtime.isEnabled();
        Logger.info(TAG, BUNDLE + 'selectUsageRealtimeState:' + selectUsageRealtimeState);
        expect(false).assertEqual(selectUsageRealtimeState);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_004:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_004 end');
      done();

    })

    /*
     * [Realtime] click the query button
     * the query result is shown below
     */
    it(BUNDLE + 'Realtime_005', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_005 begin');
      try {
        await driver.delayMs(500);
        let queryBtnRealtime = await driver.findComponent(ON.id('query_btn_realtime'));
        await queryBtnRealtime.click();
        let queryResultRealtime = await driver.findComponent(ON.id('query_result_realtime'));
        let queryResultText = await queryResultRealtime.getText();
        Logger.info(TAG, BUNDLE + 'queryResultText:' + queryResultText);
        expect(queryResultText !== '--').assertTrue();

      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_005:' + JSON.stringify(err));
        expect(false).assertTrue();

      }
      Logger.info(TAG, BUNDLE + 'Realtime_005 end');
      done();

    })

    /*
     * [Realtime] click pause and the select buttons are enabled again
     */
    it(BUNDLE + 'Realtime_006', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_006 begin');
      try {
        await driver.delayMs(500);
        let playPauseRealtime = await driver.findComponent(ON.id('play_pause_realtime'));
        await playPauseRealtime.click();
        let audioPlayState = await driver.findComponent(ON.id('audio_play_state'));
        let audioPlayStateText = await audioPlayState.getText();
        Logger.info(TAG, BUNDLE + 'audioPlayStateText:' + audioPlayStateText);
        expect('notPlaying').assertEqual(audioPlayStateText);
        let selectContentRealtime = await driver.findComponent(ON.id('select_content_realtime'));
        let selectContentRealtimeState = await selectContentRealtime.isEnabled();
        Logger.info(TAG, BUNDLE + 'selectContentRealtimeState:' + selectContentRealtimeState);
        expect(true).assertEqual(selectContentRealtimeState);
        let selectUsageRealtime = await driver.findComponent(ON.id('select_usage_realtime'));
        let selectUsageRealtimeState = await selectUsageRealtime.isEnabled();
        Logger.info(TAG, BUNDLE + 'selectUsageRealtimeState:' + selectUsageRealtimeState);
        expect(true).assertEqual(selectUsageRealtimeState);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_006:' + JSON.stringify(err));
        expect(false).assertTrue();

      }
      Logger.info(TAG, BUNDLE + 'Realtime_006 end');
      done();

    })

    /*
     * [Realtime] change content type or stream usage
     * the query result becomes blank
     */
    it(BUNDLE + 'Realtime_007', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_007 begin');
      try {
        let selectContentRealtime = await driver.findComponent(ON.id('select_content_realtime'));
        await selectContentRealtime.click();
        await driver.delayMs(500);
        await driver.click(180, 500); // content type selection, only for rk3568
        await driver.delayMs(500);

        let queryResultRealtime = await driver.findComponent(ON.id('query_result_realtime'));
        let queryResultRealtimeText = await queryResultRealtime.getText();
        Logger.info(TAG, BUNDLE + 'queryResultRealtimeText:' + queryResultRealtimeText);
        expect('--').assertEqual(queryResultRealtimeText);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_007:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_007 end');
      done();

    })

    /*
     * [Realtime] click play button, the audio plays.
     * click query button, result shows below
     */
    it(BUNDLE + 'Realtime_008', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_008 begin');
      try {
        let playPauseRealtime = await driver.findComponent(ON.id('play_pause_realtime'));
        await playPauseRealtime.click();
        let playState = await driver.findComponent(ON.id('audio_play_state'));
        let platStateText = await playState.getText();
        Logger.info(TAG, BUNDLE + 'platStateText:' + platStateText);
        expect('onPlaying').assertEqual(platStateText);
        let queryBtnRealtime = await driver.findComponent(ON.id('query_btn_realtime'));
        await queryBtnRealtime.click();
        let queryResultRealtime = await driver.findComponent(ON.id('query_result_realtime'));
        let queryResultText = await queryResultRealtime.getText();
        Logger.info(TAG, BUNDLE + 'queryResultText:' + queryResultText);
        expect(queryResultText !== '--').assertTrue();

      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_008:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_008 end');
      done();
    })

    /*
     * [Realtime] set audio effect mode
     */
    it(BUNDLE + 'Realtime_009', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Realtime_009 begin');
      try {
        let selectMode = await driver.findComponent(ON.id('select_mode_realtime'));
        await selectMode.click();
        await driver.delayMs(500);
        await driver.click(600, 500); // mode selection, only for rk3568
        let queryBtnRealtime = await driver.findComponent(ON.id('query_btn_realtime'));
        await queryBtnRealtime.click();
        let queryResultRealtime = await driver.findComponent(ON.id('query_result_realtime'));
        let selectModeName = await driver.findComponent(ON.id('select_mode_name_realtime'));
        let selectModeText = await selectModeName.getText();
        Logger.info(TAG, BUNDLE + 'selectModeText:' + selectModeText);
        let queryResultText = await queryResultRealtime.getText();
        Logger.info(TAG, BUNDLE + 'queryResultText:' + queryResultText);
        expect(queryResultText === selectModeText).assertTrue();
        await driver.click(100, 100); // back button, only for rk3568
        await driver.delayMs(2000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Realtime_009:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Realtime_009 end');
      done();
    })
  })
}