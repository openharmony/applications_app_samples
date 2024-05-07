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
import deviceInfo from '@ohos.deviceInfo';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

export default function abilityTest() {
  const TAG = '[Sample_Audio]';
  // const BUNDLE = 'audio_';
  const DEVICE_TYPE = 'phone';

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
    it('StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, 'StartAbility_001 begin');
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
      Logger.info(TAG, 'StartAbility_001 end');
    })

    /**
     * Allow Microsoft Permission
     */
    it('_Permission', 0, async () => {
      Logger.info(TAG, '_Permission begin');
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
      Logger.info(TAG, '_Permission end');
    })

    /**
     * [Home] display Home page
     */
    it('RecordAndPlayHome', 0, async (done: Function) => {
      Logger.info(TAG, 'RecordAndPlayHome begin');
      try {
        let audioCapturerComponent = await driver.findComponent(ON.id('record_play_card'));
        await audioCapturerComponent.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, 'RecordAndPlayHome:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'RecordAndPlayHome end');
      done();
    })

    /**
     * [LowLatencyCapturer] display LowLatencyCapturer page,and click open lowLatency play btn
     */
    it('OpenLowLatencyPlay', 0, async (done: Function) => {
      Logger.info(TAG, 'OpenLowLatencyPlay begin');
      let deviceType = deviceInfo.deviceType;
      if (DEVICE_TYPE === deviceType) {
        try {
          let startRecordBtnComponent = await driver.findComponent(ON.id('capturer_low_latency_btn'));
          await startRecordBtnComponent.click();
          await driver.delayMs(2000);
        } catch (err) {
          Logger.error(TAG, 'OpenLowLatencyPlay:' + JSON.stringify(err));
          expect(false).assertTrue();
        }
      }
      Logger.info(TAG, 'OpenLowLatencyPlay end');
      done();
    })

    /**
     * [LowLatencyCapturer] display LowLatencyCapturer page,and click start record btn
     */
    it('LowLatencyCapturer_001', 0, async (done: Function) => {
      Logger.info(TAG, 'LowLatencyCapturer_001 begin');
      try {
        let startRecordBtnComponent = await driver.findComponent(ON.id('start_record_btn'));
        await startRecordBtnComponent.click();
        await driver.delayMs(3000);
        await driver.assertComponentExist(ON.id('show_time_txt'));
        await driver.assertComponentExist(ON.id('stop_record_btn'));
        await driver.assertComponentExist(ON.id('pause_record_btn'));
        startRecordBtnComponent = await driver.findComponent(ON.id('start_record_btn'));
        expect(startRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, 'LowLatencyCapturer_001:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'LowLatencyCapturer_001 end');
      done();
    })

    /**
     * [LowLatencyCapturer] display LowLatencyCapturer page,and click pause record btn
     */
    it('LowLatencyCapturer_002', 0, async (done: Function) => {
      Logger.info(TAG, 'LowLatencyCapturer_002 begin');
      try {
        let pauseRecordBtnComponent = await driver.findComponent(ON.id('pause_record_btn'));
        await pauseRecordBtnComponent.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('continue_record_btn'));
        pauseRecordBtnComponent = await driver.findComponent(ON.id('pause_record_btn'));
        console.log(`pauseRecordBtnComponent=${JSON.stringify(pauseRecordBtnComponent)}`);
        expect(pauseRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, 'LowLatencyCapturer_002:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'LowLatencyCapturer_002 end');
      done();
    })

    /**
     * [LowLatencyCapturer] display LowLatencyCapturer page,and click continue record btn
     */
    it('LowLatencyCapturer_003', 0, async (done: Function) => {
      Logger.info(TAG, 'LowLatencyCapturer_003 begin');
      try {
        let continueRecordBtnComponent = await driver.findComponent(ON.id('continue_record_btn'));
        await continueRecordBtnComponent.click();
        await driver.delayMs(3000);
        await driver.assertComponentExist(ON.id('pause_record_btn'));
        continueRecordBtnComponent = await driver.findComponent(ON.id('continue_record_btn'));
        expect(continueRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, 'LowLatencyCapturer_003:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'LowLatencyCapturer_003 end');
      done();
    })

    /**
     * [LowLatencyCapturer] display LowLatencyCapturer page,and click stop record btn
     *  show result
     */
    it('LowLatencyCapturer_004', 0, async (done: Function) => {
      Logger.info(TAG, 'LowLatencyCapturer_004 begin');
      try {
        let stopRecordBtnComponent = await driver.findComponent(ON.id('stop_record_btn'));
        await stopRecordBtnComponent.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('player_btn'));
        await driver.assertComponentExist(ON.id('disalbe_btn'));
        stopRecordBtnComponent = await driver.findComponent(ON.id('stop_record_btn'));
        console.log('stopRecordBtnComponent==' + JSON.stringify(stopRecordBtnComponent));
        expect(stopRecordBtnComponent === null).assertTrue();
      } catch (err) {
        Logger.error(TAG, 'LowLatencyCapturer_004:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'LowLatencyCapturer_004 end');
      done();
    })

    /**
     * [LowLatencyRendererOpen] display LowLatencyCapturer page,and click open lowLatency renderer btn
     */
    it('LowLatencyRendererOpen', 0, async (done: Function) => {
      Logger.info(TAG, 'LowLatencyRendererOpen begin');
      let deviceType = deviceInfo.deviceType;
      if (DEVICE_TYPE === deviceType) {
        try {
          let startRecordBtnComponent = await driver.findComponent(ON.id('renderer_low_latency_btn'));
          await startRecordBtnComponent.click();
          await driver.delayMs(2000);
        } catch (err) {
          Logger.error(TAG, 'LowLatencyRendererOpen:' + JSON.stringify(err));
          expect(false).assertTrue();
        }
      }
      Logger.info(TAG, 'LowLatencyRendererOpen end');
      done();
    })

    /**
     * [LowLatencyRenderer] click record_player to play and pause
     *  play->pause->play->pause
     */
    it('LowLatencyRenderer', 0, async (done: Function) => {
      Logger.info(TAG, 'LowLatencyRenderer begin');
      try {
        let player_btn = await driver.findComponent(ON.id('player_btn'));
        await player_btn.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('playing_state'));
        await player_btn.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('paused_state'));
        await player_btn.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('playing_state'));
      } catch (err) {
        Logger.error(TAG, 'LowLatencyRenderer:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'LowLatencyRenderer end');
      done();
    })

    /**
     * [Back] click back btn to home
     *  back
     */
    it('Back', 0, async (done: Function) => {
      Logger.info(TAG, 'Back begin');
      try {
        let parallel_capturer_back_btn = await driver.findComponent(ON.id('capturer_back_btn'));
        await parallel_capturer_back_btn.click();
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, 'Back:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'Back end');
      done();
    })


    /**
     * [EnterAudioVivid] Enter AudioVivid playback page
     *  enter -> check buttons
     */
    it('EnterAudioVivid', 0, async (done: Function) => {
      Logger.info(TAG, 'EnterAudioVivid begin');
      try {
        await driver.assertComponentExist(ON.id('audiovivid_page_card'));
        let enter_btn = await driver.findComponent(ON.id('audiovivid_page_card'));
        await enter_btn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('normal_play_btn'));
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('vivid_play_btn'));
      } catch (err) {
        Logger.error(TAG, 'EnterAudioVivid:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'EnterAudioVivid end');
      done();
    })

    /**
     * [NormalMusicPlayback] play normal music
     *  click play -> click pause
     */
    it('NormalMusicPlayback', 0, async (done: Function) => {
      Logger.info(TAG, 'NormalMusicPlayback begin');
      try {
        let play_btn = await driver.findComponent(ON.id('normal_play_btn'));
        await play_btn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('normal_pause_btn'));
        await driver.delayMs(1000);

        let pause_btn = await driver.findComponent(ON.id('normal_pause_btn'));
        await pause_btn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('normal_play_btn'));
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, 'NormalMusicPlayback:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'NormalMusicPlayback end');
      done();
    })

    /**
     * [VividMusicPlayback] play audiovivid music
     *  click play -> click pause
     */
    it('VividMusicPlayback', 0, async (done: Function) => {
      Logger.info(TAG, 'VividMusicPlayback begin');
      try {
        let play_btn = await driver.findComponent(ON.id('vivid_play_btn'));
        await play_btn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('vivid_pause_btn'));
        await driver.delayMs(1000);

        let pause_btn = await driver.findComponent(ON.id('vivid_pause_btn'));
        await pause_btn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('vivid_play_btn'));
        await driver.delayMs(1000);
      } catch (err) {
        Logger.error(TAG, 'VividMusicPlayback:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'VividMusicPlayback end');
      done();
    })

    /**
     * [Back] click back btn to home
     *  back
     */
    it('Back', 0, async (done: Function) => {
      Logger.info(TAG, 'Back begin');
      try {
        let back_btn = await driver.findComponent(ON.id('spatial_audio_back_btn'));
        await back_btn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('audiovivid_page_card'));
      } catch (err) {
        Logger.error(TAG, 'Back:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'Back end');
      done();
    })

  })
}