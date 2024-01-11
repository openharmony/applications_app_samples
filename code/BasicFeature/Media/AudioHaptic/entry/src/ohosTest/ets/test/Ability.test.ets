/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
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
import { Driver, ON} from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  const TAG = '[Sample_AudioHaptic]';
  let driver: Driver;

  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      driver = Driver.create();
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

    /*
     * @tc.number: audioHaptic_StartAbility_001
     * @tc.name: StartAbility
     * @tc.desc: StartAbility
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, 'audioHaptic_StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.audiohaptic',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (exception) {
        Logger.info(TAG, `audioHaptic_StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
        done();
      }
      Logger.info(TAG, 'audioHaptic_StartAbility_001 end');
    })

    /*
     * @tc.number: audioHaptic_IndexShow_001
     * @tc.name: Display two entry card
     * @tc.desc: show index
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_IndexShow_001', 0, async (done: Function) => {
      Logger.info(TAG, 'audioHaptic_IndexShow_001 begin')
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, 'audio_haptic_card');
        await driver.assertComponentExist(ON.id('audio_haptic_card'));
        let audioHapticCardComponent = await driver.findComponent(ON.id('audio_haptic_card'));
        await audioHapticCardComponent.click();
      } catch (err) {
        Logger.error(TAG, 'audioHaptic_IndexShow_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'audioHaptic_IndexShow_001 end');
      done();
    })

    /*
     * @tc.number: audioHaptic_IndexShow_001
     * @tc.name: Click 'audio_haptic_card'
     * @tc.desc: Display AudioHaptic Page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_AudioHaptic_001', 0, async (done: Function) => {
      Logger.info(TAG, 'audioHaptic_AudioHaptic_001 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, 'btn_back_index');
        await driver.assertComponentExist(ON.id('btn_back_index'));
        Logger.info(TAG, 'play_notification_type');
        await driver.assertComponentExist(ON.id('play_notification_type'));
        Logger.info(TAG, 'play_ringtone_type');
        await driver.assertComponentExist(ON.id('play_ringtone_type'));
        Logger.info(TAG, 'play_alarm_type');
        await driver.assertComponentExist(ON.id('play_alarm_type'));
        Logger.info(TAG, 'btn_audio_mute');
        await driver.assertComponentExist(ON.id('btn_audio_mute'));
        Logger.info(TAG, 'btn_haptic_mute');
        await driver.assertComponentExist(ON.id('btn_haptic_mute'));
      } catch (err) {
        Logger.error(TAG, 'AudioHaptic_001 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'audioHaptic_AudioHaptic_001 end');
      done();
    })

    /*
     * @tc.number: audioHaptic_AudioHaptic_002
     * @tc.name: Click play notification
     * @tc.desc: Click notification item, expect it's state is playing_state
     *           Click notification item, expect it's state is pause
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_AudioHaptic_002', 0, async (done: Function) => {
      Logger.info(TAG, 'audioHaptic_AudioHaptic_002 begin');
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, ' notification_state_text');
        let notificationStateTextComponent = await driver.findComponent(ON.id('notification_state_text'));
        let notificationStateText = await notificationStateTextComponent.getText();
        Logger.info(TAG, 'notificationStateText:' + notificationStateText);
        expect('ic_pause').assertEqual(notificationStateText);
        console.log("AudioHaptic_002 4" )

        Logger.info(TAG, ' play play_notification_type');
        let notificationPlayerComponent = await driver.findComponent(ON.id('play_notification_type'));
        await notificationPlayerComponent.click();

        await driver.delayMs(500);
        notificationStateText = await notificationStateTextComponent.getText()
        Logger.info(TAG, 'notificationStateText:' + notificationStateText);
        expect('ic_play').assertEqual(notificationStateText);

        Logger.info(TAG, ' pause play_notification_type');
        await notificationPlayerComponent.click();
        await driver.delayMs(500);
        notificationStateText = await notificationStateTextComponent.getText()
        Logger.info(TAG, 'notificationStateText:' + notificationStateText);
        expect('ic_pause').assertEqual(notificationStateText);
      } catch (err) {
        Logger.error(TAG, 'audioHaptic_AudioHaptic_002 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'audioHaptic_AudioHaptic_002 end');
      done();
    })

    /*
     * @tc.number: audioHaptic_AudioHaptic_003
     * @tc.name: Click play ringtone
     * @tc.desc: Click ringtone item, expect it's state is playing_state
     *           Click ringtone item, expect it's state is pause
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_AudioHaptic_003', 0, async (done: Function) => {
      try {
        await driver.delayMs(1000);
        Logger.info(TAG, 'audioHaptic_AudioHaptic_003 begin');
        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'));
        let ringtoneStateText = await ringtoneStateTextComponent.getText();
        Logger.info(TAG, 'ringtoneStateTextComponent:' + ringtoneStateText);
        expect('ic_pause').assertEqual(ringtoneStateText);

        Logger.info(TAG, ' play play_ringtone_type');
        let ringtonePlayerComponent = await driver.findComponent(ON.id('play_ringtone_type'));
        await ringtonePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_play').assertEqual(await ringtoneStateTextComponent.getText());

        Logger.info(TAG, ' pause play_ringtone_type');
        await ringtonePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_pause').assertEqual(await ringtoneStateTextComponent.getText());
      } catch (err) {
          Logger.error(TAG, 'audioHaptic_AudioHaptic_003 err:' + JSON.stringify(err));
          expect(false).assertTrue();
        }
        Logger.info(TAG, 'audioHaptic_AudioHaptic_003 end');
        done();
      })

    /*
     * @tc.number: audioHaptic_AudioHaptic_004
     * @tc.name: Click alarm ringtone
     * @tc.desc: Click alarm item, expect it's state is playing_state
     *           Click alarm item, expect it's state is pause
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_AudioHaptic_004', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'audioHaptic_AudioHaptic_004 begin');

        let alarmStateTextComponent = await driver.findComponent(ON.id('alarm_state_text'));
        let alarmStateText = await alarmStateTextComponent.getText();
        Logger.info(TAG, 'alarmStateTextComponent:' + alarmStateText);
        expect('ic_pause').assertEqual(alarmStateText);

        Logger.info(TAG, ' play play_alarm_type');
        let alarmPlayerComponent = await driver.findComponent(ON.id('play_alarm_type'));
        await alarmPlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_play').assertEqual(await alarmStateTextComponent.getText());

        Logger.info(TAG, ' pause play_alarm_type');
        await alarmPlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_pause').assertEqual(await alarmStateTextComponent.getText());
      } catch (err) {
        Logger.error(TAG, 'audioHaptic_AudioHaptic_004 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'audioHaptic_AudioHaptic_004 end');
      done();
    })

    /*
     * @tc.number: audioHaptic_AudioHaptic_005
     * @tc.name: Click audio Mute
     * @tc.desc: Click audioMute item, expect it's state is playing_state and audio mute
     *           Click audioMute item, expect it's state is pause
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_AudioHaptic_005', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'audioHaptic_AudioHaptic_005 begin');
        let audioMuteTextComponent = await driver.findComponent(ON.id('audio_mute_state_text'));
        let audioMuteText = await audioMuteTextComponent.getText();
        Logger.info(TAG, 'alarmStateTextComponent:' + audioMuteText);
        expect('ic_pause').assertEqual(audioMuteText);

        Logger.info(TAG, ' play btn_audio_mute');
        let audioMutePlayerComponent = await driver.findComponent(ON.id('btn_audio_mute'));
        await audioMutePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_play').assertEqual(await audioMuteTextComponent.getText());

        Logger.info(TAG, ' pause btn_audio_mute');
        await audioMutePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_pause').assertEqual(await audioMuteTextComponent.getText());
      } catch (err) {
        Logger.error(TAG, 'audioHaptic_AudioHaptic_005 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'audioHaptic_AudioHaptic_005 end');
      done();
    })

    /*
     * @tc.number: audioHaptic_AudioHaptic_006
     * @tc.name: Click haptic Mute
     * @tc.desc: Click hapticMute item, expect it's state is playing_state and haptic mute
     *           Click hapticMute item, expect it's state is pause
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioHaptic_AudioHaptic_006', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'audioHaptic_AudioHaptic_006 begin');
        let hapticMuteTextComponent = await driver.findComponent(ON.id('haptic_mute_state_text'));
        let hapticMuteText = await hapticMuteTextComponent.getText();
        Logger.info(TAG, 'hapticMuteTextComponent:' + hapticMuteText);
        expect('ic_pause').assertEqual(hapticMuteText);

        Logger.info(TAG, ' play btn_haptic_mute');
        let hapticMutePlayerComponent = await driver.findComponent(ON.id('btn_haptic_mute'));
        await hapticMutePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_play').assertEqual(await hapticMuteTextComponent.getText());

        Logger.info(TAG, ' pause btn_haptic_mute');
        await hapticMutePlayerComponent.click();
        await driver.delayMs(500);
        expect('ic_pause').assertEqual(await hapticMuteTextComponent.getText());
      } catch (err) {
        Logger.error(TAG, 'audioHaptic_AudioHaptic_006 err:' + JSON.stringify(err));
        expect(false).assertTrue();
      }
      Logger.info(TAG, 'audioHaptic_AudioHaptic_006 end');
      done();
    })
  })
}