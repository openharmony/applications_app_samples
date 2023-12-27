/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@ohos.base';
import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_ServiceCard_Test]';
const DOMAIN = 0xF811;
const BUNDLE = 'ServiceCard_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;
let cardArkTsWidgetEventRouter = 'WidgetEventRouter';
let cardWidgetUpdateRouter = 'WidgetUpdateRouter';
let cardWidgetUpdateCallCard = 'WidgetUpdateCall';
let cardWidgetEventCall = 'WidgetEventCall'
let cardUpdateByMessage = 'UpdateByMessage';
let cardAttrAnimation = 'AttrAnimation';
let cardCustomCanvasDrawing = 'CustomCanvasDrawing';
let cardUpdateDuration = 'UpdateDuration';
let cardScheduledUpdateTime = 'ScheduledUpdateTime';
let cardNextRefreshTimeCard = 'NextRefreshTime';
let cardWidgetImageUpdate = 'WidgetImageUpdate';
let cardWidgetUpdateByStatus = 'WidgetUpdateByStatus';
let cardWidgetProcessData = 'WidgetProcessData';
let cardWidgetPersistentData = 'WidgetPersistentData';
let cardWidgetJS = 'WidgetJS';
let driver = Driver.create();
// Sliding coordinate
const START_SLIDING_X = 700;
const FINISH_SLIDING_X = 50;
const SLIDING_COORDINATE_Y = 300;
// Add to desktop coordinate
const ADD_TO_DESKTOP_X = 300;
const ADD_TO_DESKTOP_Y = 1200;

export default function formTest() {
  describe('ActsFormTest', () => {
    beforeAll(async () => {
      // Exit the test interface to execute the test case
      await driver.pressHome();
      await driver.delayMs(1000);
    })

    /*
     * @tc.number: ServiceCard_ArkTS_001
     * @tc.name: Add WidgetEventRouter cards to desktop.
     * @tc.desc: Add WidgetEventRouter cards to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_001 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardArkTsWidgetEventRouter).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));

      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_001 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_001 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 2; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_001 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardArkTsWidgetEventRouter).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_001 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_002
     * @tc.name: Add cardWidgetUpdateRouter card to desktop.
     * @tc.desc: Add cardWidgetUpdateRouter card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_002 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetUpdateRouter).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_002 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_002 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 12; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_002 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetUpdateRouter).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_002 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_003
     * @tc.name: Add UpdateByMessage card to desktop.
     * @tc.desc: Add UpdateByMessage card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_003 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardUpdateByMessage).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_003 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_003 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 3; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }
      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_003 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardUpdateByMessage).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_003 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_004
     * @tc.name: Add CustomCanvasDrawing card to desktop.
     * @tc.desc: Add CustomCanvasDrawing card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_004 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardCustomCanvasDrawing).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_004 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_004 Start to fling cards)`);
      await driver.delayMs(2000);

      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 500);
      await driver.delayMs(2000);

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_004 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardCustomCanvasDrawing).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_004 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_005
     * @tc.name: Add Animation card to desktop.
     * @tc.desc: Add Animation card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_005 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardAttrAnimation).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_005 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_005 Start to fling cards)`);
      await driver.delayMs(2000);

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_005 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardAttrAnimation).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_005 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_006
     * @tc.name: Add WidgetUpdateByStatus card to desktop.
     * @tc.desc: Add WidgetUpdateByStatus card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_006 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetUpdateByStatus).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_006 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_006 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 7; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(1000);
      }

      /// Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_006 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetUpdateByStatus).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_006 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_007
     * @tc.name: Add WidgetProcessData card to desktop.
     * @tc.desc: Add WidgetProcessData card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_007 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetProcessData).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_007 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_007 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 6; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(1000);
      }
      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_007 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetProcessData).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_007 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_008
     * @tc.name: Add UpdateDuration card to desktop.
     * @tc.desc: Add UpdateDuration card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_008 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardUpdateDuration).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_008 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_008 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 8; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(1000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_008 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardUpdateDuration).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_008 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_009
     * @tc.name: Add ScheduledUpdateTime card to desktop.
     * @tc.desc: Add ScheduledUpdateTime card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_009 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardScheduledUpdateTime).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_009 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_009 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 9; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_009 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardScheduledUpdateTime).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_009 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_010
     * @tc.name: Add NextRefreshTimeCard card to desktop.
     * @tc.desc: Add NextRefreshTimeCard card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_010 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardNextRefreshTimeCard).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_010 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_010 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 10; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_010 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardNextRefreshTimeCard).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_010 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_011
     * @tc.name: Add WidgetImageUpdate card to desktop.
     * @tc.desc: Add WidgetImageUpdate card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_011 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetImageUpdate).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_011 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_011 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 11; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_011 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetImageUpdate).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_011 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_012
     * @tc.name: Add WidgetEventCall card to desktop.
     * @tc.desc: Add WidgetEventCall card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_012', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_012 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetEventCall).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_012 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_012 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 13; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(2000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_012 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetEventCall).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_012 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_013
     * @tc.name: Add WidgetUpdateCall card to desktop.
     * @tc.desc: Add WidgetUpdateCall card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_013', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_013 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetUpdateCallCard).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_013 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_013 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 14; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(1000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_013 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetUpdateCallCard).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_013 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_ArkTS_014
     * @tc.name: Add WidgetPersistentData card to desktop.
     * @tc.desc: Add WidgetPersistentData card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ArkTS_014', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_014 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetPersistentData).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_014 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_014 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 5; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(1000);
      }

      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `ArkTS_014 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetPersistentData).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_014 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })

    /*
     * @tc.number: ServiceCard_JS_UI_001
     * @tc.name: Add WidgetJS card to desktop.
     * @tc.desc: Add WidgetJS card to desktop.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'JS_UI_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `JS_UI_001 getFormData data: ${JSON.stringify(data)}`);
          expect(result !== null).assertTrue();
          cardArkTsCount = result.split(cardWidgetJS).length - 1;
          hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 cardArkTsCount:' + cardArkTsCount);
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 hilog err is: ' + JSON.stringify(err));
        });
      await driver.delayMs(1000);

      // Long click the application
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label')), MatchPattern.CONTAINS));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `JS_UI_001 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(1000);

      // Add an ArkTs card to launcher
      // let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EntryAbility_label'))));
      await driver.assertComponentExist(ON.text('服务卡片', MatchPattern.CONTAINS));
      let serviceCard = await driver.findComponent(ON.text('服务卡片', MatchPattern.CONTAINS));
      await serviceCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + `JS_UI_001 Start to fling cards)`);
      await driver.delayMs(2000);

      for (let i = 0; i < 4; i++) {
        await driver.fling({
          x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, {
          x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
        }, 5, 500);
        await driver.delayMs(1000);
      }
      // Click to add to desktop
      // await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop')), MatchPattern.CONTAINS));
      // await addCard.click();
      await driver.click(ADD_TO_DESKTOP_X, ADD_TO_DESKTOP_Y);
      hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 addCardToDesktop');
      await driver.delayMs(2000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.samples.stageservicewidgetcards'")
        .then((data) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 hilog data success');
          let result = JSON.stringify(data);
          hilog.info(DOMAIN, TAG, BUNDLE + `JS_UI_001 getFormData data: ${JSON.stringify(data)}`);
          cardArkTsCountSecond = result.split(cardWidgetJS).length - 1;
        })
        .catch((err: BusinessError) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 hilog err is: ' + JSON.stringify(err));
        });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'JS_UI_001 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card has been added');
      await driver.delayMs(2000);
      done();
    })
  })
}