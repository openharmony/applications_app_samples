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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { Driver, ON } from '@ohos.UiTest';
import { describe, it, expect } from '@ohos/hypium';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const TIME_THOUSAND = 1000;
const TAG = '[Sample_Notification]';
const DOMAIN = 0xF811

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function appTest() {
  let driver = Driver.create();
  describe('appTest', () => {

    /*
     * @tc.number: Notification_SetBadgeNumber_001
     * @tc.name: Set corner markers
     * @tc.desc: Set corner markers
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_SetBadgeNumber_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_SetBadgeNumber_001_begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.notification",
          abilityName: "EntryAbility"
        });
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      await driver.delayMs(TIME_THOUSAND);
      let btnUse = await driver.findComponent(ON.text(await getResourceString($r('app.string.enable_notification'))));
      await btnUse.click();
      await driver.delayMs(TIME_THOUSAND);
      let buttonClick = await driver.findComponent(ON.text(await getResourceString($r('app.string.allow_button'))));
      await driver.delayMs(TIME_THOUSAND);
      await buttonClick.click();
      let SetCorner = await driver.findComponent(ON.text(await getResourceString($r('app.string.set_badge_number'))));
      await SetCorner.click();
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.test_text')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.test_text'))));
      await driver.delayMs(TIME_THOUSAND);
      await driver.click(344, 1092);
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_SetBadgeNumber_001_end');
      done();
    });

    /*
     * @tc.number: Notification_BasicNotification_002
     * @tc.name: Test regular text notifications
     * @tc.desc: Test regular text notifications
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_BasicNotification_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_BasicNotification_002_begin');
      await driver.delayMs(TIME_THOUSAND);
      let textBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.basic_notification'))));
      await driver.delayMs(TIME_THOUSAND);
      await textBtn.click();
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.test_text')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.test_text'))));
      await driver.click(344, 1092);
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_BasicNotification_002_end');
      done();
    });

    /*
     * @tc.number: Notification_LongNotification_003
     * @tc.name: Test Long Text Notification
     * @tc.desc: Test Long Text Notification
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_LongNotification_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_LongNotification_003_begin');
      await driver.delayMs(TIME_THOUSAND);
      let textBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.long_notification'))));
      await driver.delayMs(TIME_THOUSAND);
      await textBtn.click();
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      await driver.click(682, 159);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.test_longText')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.test_longText'))))
      await driver.click(344, 1092);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_LongNotification_003_end');
      done();
    });

    /*
     * @tc.number: Notification_MultilineNotification_004
     * @tc.name: Test Multiline Text Notification
     * @tc.desc: Test Multiline Text Notification
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_MultilineNotification_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_MultilineNotification_004_begin');
      await driver.delayMs(TIME_THOUSAND);
      let textBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.multi_line_notification'))));
      await driver.delayMs(TIME_THOUSAND);
      await textBtn.click();
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      await driver.click(667, 166);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.line_01')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.line_01'))))
      await driver.delayMs(TIME_THOUSAND);
      await driver.click(344, 1092);
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_MultilineNotification_004_end');
      done();
    })

    /*
     * @tc.number: Notification_PictureNotification_005
     * @tc.name: Test Picture Notification
     * @tc.desc: Test Picture Notification
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_PictureNotification_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_PictureNotification_005_begin');
      await driver.delayMs(TIME_THOUSAND);
      let textBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.picture_notification'))));
      await driver.delayMs(TIME_THOUSAND);
      await textBtn.click();
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      await driver.click(667, 166);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.test_briefText')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.test_briefText'))));
      await driver.click(344, 1092);
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_PictureNotification_005_end');
      done();
    })

    /*
     * @tc.number: Notification_WantAgentStartAbility_006
     * @tc.name: Test Launch Capability Notification
     * @tc.desc: Test Launch Capability Notification
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_WantAgentStartAbility_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_WantAgentStartAbility_006_begin');
      await driver.delayMs(TIME_THOUSAND);
      let textBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.want_agent_start_ability'))));
      await driver.delayMs(TIME_THOUSAND);
      await textBtn.click();
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      await driver.click(323, 228);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.Second_Page')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.Second_Page'))));
      await driver.click(344, 1092);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_WantAgentStartAbility_006_end');
      done();
    })

    /*
     * @tc.number: Notification_WantAgentCommonEvent_007
     * @tc.name: Testing and publishing public event notifications
     * @tc.desc: Testing and publishing public event notifications
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Notification_WantAgentCommonEvent_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Notification_WantAgentCommonEvent_007_begin');
      await driver.delayMs(TIME_THOUSAND);
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.notification",
          abilityName: "EntryAbility"
        });
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      await driver.delayMs(TIME_THOUSAND);
      let SetCorners = await driver.findComponent(ON.text(await getResourceString($r('app.string.want_agent_common_event'))));
      await driver.delayMs(TIME_THOUSAND);
      await SetCorners.click();
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(TIME_THOUSAND);
      hilog.info(DOMAIN, TAG, await getResourceString($r('app.string.Test_Text')));
      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.Test_Text'))))
      await driver.click(344, 1092);
      await driver.delayMs(TIME_THOUSAND);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(TIME_THOUSAND);
      expect(result != null).assertTrue();
      hilog.info(DOMAIN, TAG, 'Notification_WantAgentCommonEvent_007_end');
      done();
    })

  })
}