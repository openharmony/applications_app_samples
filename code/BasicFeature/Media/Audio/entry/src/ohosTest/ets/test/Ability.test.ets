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

import Logger from '../utils/Logger';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;

export default function abilityTest() {
  const TAG = '[Sample_Audio]';
  const BUNDLE = 'audio_';
  const WAIT_FOR_RECORD_LENGTH = 6000;
  let driver: Driver;

  describe('ActsAbilityTest',  () => {
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
          bundleName: 'com.samples.audio',
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
     * Allow Microsoft Permission
     */
    it(BUNDLE + '_Permission', 0, async () => {
      driver = Driver.create();
      Logger.info(TAG, BUNDLE + '_Permission begin');
      await driver.delayMs(3000);
      let ability = abilityDelegator.getAppContext();
      manager = ability.resourceManager;
      for (let i = 0; i < 1; i++) {
        let btnAccept = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.allow'))));
        console.log('btnAccept' + JSON.stringify(btnAccept));
        if (btnAccept !== undefined) {
          await btnAccept.click();
          await driver.delayMs(500);
        }
      }
      Logger.info(TAG, BUNDLE + '_Permission end');
    })

    /**
     * [Index]
     * Display two entry card
     * Click select_output_device_card
     */
    it(BUNDLE + 'IndexShow_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'IndexShow_001 begin')
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'select_output_device_card');
        await driver.assertComponentExist(ON.id('select_output_device_card'));
        Logger.info(TAG, BUNDLE + 'audio_focus_card');
        await driver.assertComponentExist(ON.id('audio_focus_card'));
        let selectOutputDeviceCardComponent = await driver.findComponent(ON.id('select_output_device_card'));
        await selectOutputDeviceCardComponent.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_001 end');
      done();
    })

    /**
     * [PreferOutputDevice]
     * Display  current prefer output device
     * Back to index page
     */
    it(BUNDLE + 'PreferOutputDevice_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'PreferOutputDevice_001 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'back_btn');
        await driver.assertComponentExist(ON.id('back_btn'));
        let backComponent = await driver.findComponent(ON.id('back_btn'));
        let deviceNameComponent = await driver.findComponent(ON.id('device_name_text'));
        let deviceNameText = await deviceNameComponent.getText();
        Logger.info(TAG, BUNDLE + 'deviceNameText:' + deviceNameText);
        expect(deviceNameText !== 'Invalid').assertTrue();
        await driver.delayMs(1000);
        await backComponent.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'PreferOutputDevice_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'PreferOutputDevice_001 end');
      done();
    })

    /**
     * [Index]
     * Display two entry card
     * Click select_output_device_card
     */
    it(BUNDLE + 'IndexShow_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'IndexShow_001 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'select_output_device_card');
        await driver.assertComponentExist(ON.id('select_output_device_card'));
        Logger.info(TAG, BUNDLE + 'audio_focus_card');
        await driver.assertComponentExist(ON.id('audio_focus_card'));
        let audioFocusCardComponent = await driver.findComponent(ON.id('audio_focus_card'));
        await audioFocusCardComponent.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_002 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_002 end');
      done();
    })

    /**
     * [Focus]
     * Click 'audio_focus_card'
     * Display Focus Page
     */
    it(BUNDLE + 'Focus_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Focus_001 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'back_btn_focus');
        await driver.assertComponentExist(ON.id('back_btn_focus'));
        Logger.info(TAG, BUNDLE + 'music_player_item');
        await driver.assertComponentExist(ON.id('music_player_item'));
        Logger.info(TAG, BUNDLE + 'ringtone_player_item');
        await driver.assertComponentExist(ON.id('ringtone_player_item'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Focus_001 end');
      done();
    })

    /**
     * [Focus] Click musicplayer item
     * Click musicplayer item,expect it's state is playing and is't clickable
     */
    it(BUNDLE + 'Focus_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Focus_002 begin');
      try {
        await driver.delayMs(1000);
        let musicStateTextComponent = await driver.findComponent(ON.id('music_state_text'));
        let musicStateText = await musicStateTextComponent.getText();
        Logger.info(TAG, BUNDLE + 'musicStateTextComponent:' + musicStateText);
        expect('ic_pause').assertEqual(musicStateText);
        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'));
        let ringtoneStateText = await ringtoneStateTextComponent.getText();
        Logger.info(TAG, BUNDLE + 'ringtoneStateTextComponent:' + ringtoneStateText);
        expect('ic_pause_no').assertEqual(ringtoneStateText);
        let musicPlayerComponent = await driver.findComponent(ON.id('music_player_item'));

        await musicPlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_play_no').assertEqual(await musicStateTextComponent.getText());
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_002 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Focus_002 end');
      done();
    })

    /**
     * [Focus] Click ringtoneplayer item
     * Click ringtoneplayer item,expect it's state is playing and is clickable
     * musicplayer item,expect it's state is paused and is't clickable
     */
    it(BUNDLE + 'Focus_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Focus_003 begin');
      try {
        await driver.delayMs(1000);
        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'));
        expect('ic_pause').assertEqual(await ringtoneStateTextComponent.getText());

        let ringtonePlayerComponent = await driver.findComponent(ON.id('ringtone_player_item'));
        await ringtonePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_play').assertEqual(await ringtoneStateTextComponent.getText());

        await driver.delayMs(500);
        let musicStateTextComponent = await driver.findComponent(ON.id('music_state_text'));
        expect('ic_pause_no').assertEqual(await musicStateTextComponent.getText());
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_003 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Focus_003 end');
      done();
    })

    /**
     * [Focus] musicplayer resume
     * Click ringtoneplayer item,expect it's state is paused and is't clickable
     * musicplayer item,expect it's state is playing and is't clickable
     */
    it(BUNDLE + 'Focus_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Focus_004 begin');
      try {
        await driver.delayMs(1000);

        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'));
        expect('ic_play').assertEqual(await ringtoneStateTextComponent.getText());

        let ringtoneStateImgComponent = await driver.findComponent(ON.id('ringtone_state_img'));
        await ringtoneStateImgComponent.click();
        await driver.delayMs(500);
        expect('ic_pause_no').assertEqual(await ringtoneStateTextComponent.getText());

        await driver.delayMs(500);
        let musicStateTextComponent = await driver.findComponent(ON.id('music_state_text'));
        expect('ic_play_no').assertEqual(await musicStateTextComponent.getText());

        await driver.delayMs(500);
        let backComponent = await driver.findComponent(ON.id('back_btn_focus'));
        await backComponent.click();
        await driver.delayMs(500);

      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_004 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'Focus_004 end');
      done();
    })

    /**
     * [Index]
     * back tp homepage
     * Display  entry card
     * Click audio_effect_manager_card
     */
    it(BUNDLE + 'IndexShow_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'IndexShow_003 begin');
      try {
        await driver.delayMs(500);
        Logger.info(TAG, BUNDLE + 'audio_effect_manager_card');
        await driver.assertComponentExist(ON.id('audio_effect_manager_card'));
        let audioEffectManagerCardComponent = await driver.findComponent(ON.id('audio_effect_manager_card'));
        await audioEffectManagerCardComponent.click();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_003 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_003 end');
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
    *
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

    /**
     * [CapturerHome] display CapturerHome page
     */
    it(BUNDLE + 'CapturerHome_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'CapturerHome_001 begin');
      try {
        let audioCapturerComponent = await driver.findComponent(ON.id('audio_capturer_card'));
        await audioCapturerComponent.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.NORMAL_CAPTURER'))));
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.PARALLEL_CAPTURER'))));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'CapturerHome_001:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'CapturerHome_001 end');
      done();
    })

    /**
     * [NormalCapturer] display NormalCapturer page,and click start record btn
     */
    it(BUNDLE + 'NormalCapturer_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'NormalCapturer_001 begin');
      try {
        let startRecordBtnComponent = await driver.findComponent(ON.id('normal_start_record_btn'));
        await startRecordBtnComponent.click();
        await driver.delayMs(3000);
        await driver.assertComponentExist(ON.id('normal_show_time_txt'));
        await driver.assertComponentExist(ON.id('normal_stop_record_btn'));
        await driver.assertComponentExist(ON.id('normal_pause_record_btn'));
        startRecordBtnComponent = await driver.findComponent(ON.id('normal_start_record_btn'));
        expect(startRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'NormalCapturer_001:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'NormalCapturer_001 end');
      done();
    })

    /**
     * [NormalCapturer] display NormalCapturer page,and click pause record btn
     */
    it(BUNDLE + 'NormalCapturer_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'NormalCapturer_002 begin');
      try {
        let pauseRecordBtnComponent = await driver.findComponent(ON.id('normal_pause_record_btn'));
        await pauseRecordBtnComponent.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('normal_continue_record_btn'));
        pauseRecordBtnComponent = await driver.findComponent(ON.id('normal_pause_record_btn'));
        console.log(`pauseRecordBtnComponent=${JSON.stringify(pauseRecordBtnComponent)}`);
        expect(pauseRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'NormalCapturer_002:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'NormalCapturer_002 end');
      done();
    })

    /**
     * [NormalCapturer] display NormalCapturer page,and click continue record btn
     */
    it(BUNDLE + 'NormalCapturer_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'NormalCapturer_003 begin');
      try {
        let continueRecordBtnComponent = await driver.findComponent(ON.id('normal_continue_record_btn'));
        await continueRecordBtnComponent.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('normal_pause_record_btn'));
        continueRecordBtnComponent = await driver.findComponent(ON.id('normal_continue_record_btn'));
        expect(continueRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'NormalCapturer_003:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'NormalCapturer_003 end');
      done();
    })

    /**
     * [NormalCapturer] display NormalCapturer page,and click stop record btn
     *  show result
     */
    it(BUNDLE + 'NormalCapturer_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'NormalCapturer_004 begin');
      try {
        let stopRecordBtnComponent = await driver.findComponent(ON.id('normal_stop_record_btn'));
        await stopRecordBtnComponent.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('normal_player'));
        await driver.assertComponentExist(ON.id('disalbe_btn'));
        stopRecordBtnComponent = await driver.findComponent(ON.id('normal_stop_record_btn'));
        console.log('stopRecordBtnComponent==' + JSON.stringify(stopRecordBtnComponent));
        expect(stopRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'NormalCapturer_004:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'NormalCapturer_004 end');
      done();
    })

    /**
     * [NormalCapturer] click record_player to play and pause
     *  show result
     */
    it(BUNDLE + 'NormalCapturer_005', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'NormalCapturer_005 begin');
      try {
        let normal_player = await driver.findComponent(ON.id('normal_player'));
        await normal_player.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('playing_state'));
        await driver.delayMs(2000);
        await normal_player.click();
        await driver.assertComponentExist(ON.id('paused_state'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'NormalCapturer_005:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'NormalCapturer_005 end');
      done();
    })

    /**
     * [ParallelCapturer] display ParallelCapturer page
     */
    it(BUNDLE + 'ParallelCapturer_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_001 begin');
      try {
        let parallelCapturerBtnComponent = await driver.findComponent(ON.id('btn_parallel_capturer'));
        await parallelCapturerBtnComponent.click();
        await driver.delayMs(1000);

        await driver.assertComponentExist(ON.id('music_player_card'));
        await driver.assertComponentExist(ON.id('parallel_start_btn'));
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'ParallelCapturer_001:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_001 end');
      done();
    })

    /**
     * [ParallelCapturer] click music_player_card to play music,then and click record_btn to start record
     */
    it(BUNDLE + 'ParallelCapturer_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_002 begin');
      try {
        let musicPlayerComponent = await driver.findComponent(ON.id('music_player_card'));
        await musicPlayerComponent.click();
        await driver.delayMs(1000);

        // start record
        let startBtnComponent = await driver.findComponent(ON.id('parallel_start_btn'));
        await startBtnComponent.click();
        await driver.delayMs(WAIT_FOR_RECORD_LENGTH);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'ParallelCapturer_002:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_002 end');
      done();
    })

    /**
     * [ParallelCapturer] click stop record btn,show result
     */
    it(BUNDLE + 'ParallelCapturer_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_003 begin');
      try {
        // stop record
        let stopBtnComponent = await driver.findComponent(ON.id('parallel_stop_btn'));
        await stopBtnComponent.click();
        await driver.delayMs(500);

        await driver.assertComponentExist(ON.id('record_result'));
        await driver.assertComponentExist(ON.id('record_player0'));
        await driver.assertComponentExist(ON.id('record_player1'));
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'ParallelCapturer_003:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_003 end');
      done();
    })

    /**
     * [ParallelCapturer] click 2 record_player
     *  play,pause,back
     */
    it(BUNDLE + 'ParallelCapturer_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_004 begin');
      try {
        let record_player0 = await driver.findComponent(ON.id('record_player0'));
        let record_player1 = await driver.findComponent(ON.id('record_player1'));
        await record_player0.click();
        await record_player1.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('playing_state0'));
        await driver.assertComponentExist(ON.id('playing_state1'));

        await record_player0.click();
        await record_player1.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('paused_state0'));
        await driver.assertComponentExist(ON.id('paused_state1'));
        let parallel_capturer_back_btn = await driver.findComponent(ON.id('parallel_capturer_back_btn'));
        await parallel_capturer_back_btn.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'ParallelCapturer_004:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, BUNDLE + 'ParallelCapturer_004 end');
      done();
    })
  })
}