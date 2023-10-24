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

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';

const TAG = '[Sample_DataProxyForm_Test]';
const DOMAIN = 0xF811;
const BUNDLE = 'DataProxyForm_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;
let cardJs = 'persistentWidgetJS';
let cardArkTs = 'persistentWidget';
let pushCardJs = 'processJsWidget';
let pushCardArkTs = 'processWidget';
let driver = Driver.create();
// Sliding coordinate
const START_SLIDING_X = 700;
const FINISH_SLIDING_X = 50;
const SLIDING_COORDINATE_Y = 300;

export default function formTest() {
  describe('ActsFormTest', () => {
    beforeAll(async () => {
      // Exit the test interface to execute the test case
      await driver.pressBack();
      await driver.delayMs(1000);
      // Open launcher
      await abilityDelegator.executeShellCommand('aa start -b ohos.samples.launcher -a MainAbility').then((result) =>{
        hilog.info(DOMAIN, TAG, BUNDLE + 'start launcher success');
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'start launcher fail');
      });
    })

    afterAll(async () => {
      // Close launcher
      await abilityDelegator.executeShellCommand('pkill -f ohos.samples.launcher').then((result) =>{
        hilog.info(DOMAIN, TAG, BUNDLE + 'close launcher success');
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'close launcher fail');
      });
    })

    /**
     * Scene:Add cards to launcher.
     * Input:Long click on the application icon, select 'service card' from the pop-up menu and select 'Add a card to the desktop' button.
     * Expected output:An ArkTs card is added to the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_001 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardArkTsCount = result.split(pushCardArkTs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 cardArkTsCount:' + cardArkTsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 hilog err is: ' + JSON.stringify(err));
      });
      await driver.delayMs(1000);

      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height =rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_001 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add an ArkTs card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(2000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 addCardToDesktop');
      await driver.delayMs(1000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_001 getFormData data: ${JSON.stringify(data)}`);
        cardArkTsCountSecond = result.split(pushCardArkTs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 hilog err is: ' + JSON.stringify(err));
      });

      // Assert an ArkTs card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card be added');
      await driver.delayMs(1000);

      // Remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_001 end');
      done();
    })

    /**
     * Scene:Add cards to launcher.
     * Input:Long click on the application icon, select 'service card' from the pop-up menu and select 'service card' button.
     * Expected output:A Js card is added to the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_002', 1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 begin');
      await driver.delayMs(1000);
      // Confirm the number of cards
      let cardJsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_002 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardJsCount = result.split(pushCardJs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 cardJsCount:' + cardJsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 hilog err is: ' + JSON.stringify(err));
      });

      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      let rect = await app.getBounds();
      let height =rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_002 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add a Js card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 addCardToDesktop');
      await driver.delayMs(1000);

      // Verify that a Js card has been added
      let cardJsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_002 getFormData data: ${JSON.stringify(data)}`);
        cardJsCountSecond = result.split(pushCardJs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 hilog err is: ' + JSON.stringify(err));
      });

      // Assert a Js card has been added
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 assert an ArkTs card has been added, ' +
      'cardJsCountSecond:' + cardJsCountSecond);
      expect(cardJsCount + 1).assertEqual(cardJsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 ' + (cardJsCountSecond - cardJsCount) + ' card be added');
      await driver.delayMs(1000);

      // Remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_002 end');
      done();
    })

    /**
     * Scene:Add cards to launcher.
     * Input:Long click on the application icon, select 'service card' from the pop-up menu and select 'Add a card to the desktop' button.
     * Expected output:An ArkTs card is added to the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_003', 2, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 begin');
      await driver.delayMs(3000);
      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 hilog data successDataProxyForm_003 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_003 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardArkTsCount = result.split(cardArkTs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 cardArkTsCount:' + cardArkTsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 hilog err is: ' + JSON.stringify(err));
      });
      await driver.delayMs(1000);

      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height =rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_003 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add an ArkTs card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 addCardToDesktop');
      await driver.delayMs(1000);

      // Verify that only one card has been added
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_003 getFormData data: ${JSON.stringify(data)}`);
        cardArkTsCountSecond = result.split(cardArkTs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 hilog err is: ' + JSON.stringify(err));
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 assert an ArkTs card has been added, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 ' + (cardArkTsCountSecond - cardArkTsCount) + ' card be added');
      await driver.delayMs(1000);

      // Remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_003 end');
      done();
    })

    /**
     * Scene:Add cards to launcher.
     * Input:Long click on the application icon, select 'service card' from the pop-up menu and select 'service card' button.
     * Expected output:A Js card is added to the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_004', 3, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 begin');
      await driver.delayMs(1000);
      // Confirm the number of cards
      let cardJsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_004 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardJsCount = result.split(cardJs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 cardJsCount:' + cardJsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 hilog err is: ' + JSON.stringify(err));
      });

      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      let rect = await app.getBounds();
      let height =rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_004 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add a Js card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(500);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 addCardToDesktop');
      await driver.delayMs(1000);

      // Verify that a Js card has been added
      let cardJsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 getFormData data: ' + JSON.stringify(data));
        cardJsCountSecond = result.split(cardJs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 hilog err is: ' + JSON.stringify(err));
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 assert an ArkTs card has been added, ' +
      'cardJsCountSecond:' + cardJsCountSecond);
      expect(cardJsCount + 1).assertEqual(cardJsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 ' + (cardJsCountSecond - cardJsCount) + ' card be added');
      await driver.delayMs(1000);

      // Remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_004 end');
      done();
    })

    /**
     * Scene:Delete cards from launcher.
     * Input:Long click on the card, select 'delete' from the pop-up menu,and confirm to remove.
     * Expected output:An ArkTs card is deleted from the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_005', 4, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 begin');
      await driver.delayMs(1000);
      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      let rect = await app.getBounds();
      let height =rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_005 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add an ArkTs card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(1000);

      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_005 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardArkTsCount = result.split(pushCardArkTs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 cardArkTsCount:' + cardArkTsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 hilog err is: ' + JSON.stringify(err));
      });

      // Find and remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 removeCardToDesktop');

      // Verify that one card has been deleted
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_005 getFormData data: ${JSON.stringify(data)}`);
        cardArkTsCountSecond = result.split(pushCardArkTs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 hilog err is: ' + JSON.stringify(err));
      });

      // Assert an ArkTs card has been removed
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 assert an ArkTs card has been deleted, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount - 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 ' + (cardArkTsCount - cardArkTsCountSecond) + ' card be deleted');
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_005 end');
      done();
    })

    /**
     * Scene:Delete cards from launcher.
     * Input:Long click on the card, select 'delete' from the pop-up menu.
     * Expected output:A Js card is deleted from the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_006', 5, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 begin');
      await driver.delayMs(1000);
      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      let rect = await app.getBounds();
      let height =rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_006 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add a Js card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(1000);

      // Confirm the number of cards
      let cardJsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_006 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardJsCount = result.split(pushCardJs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 cardJsCount:' + cardJsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 hilog err is: ' + JSON.stringify(err));
      });

      // Find and remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.pushName'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 removeCardToDesktop');

      // Verify that one card has been deleted
      let cardJsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_006 getFormData data: ${JSON.stringify(data)}`);
        cardJsCountSecond = result.split(pushCardJs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 hilog err is: ' + JSON.stringify(err));
      });

      // Assert a Js card has been removed
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 assert an ArkTs card has been deleted, ' +
      'cardJsCountSecond:' + cardJsCountSecond);
      expect(cardJsCount - 1).assertEqual(cardJsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 ' + (cardJsCount - cardJsCountSecond) + ' card be deleted');
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_006 end');
      done();
    })

    /**
     * Scene:Delete cards from launcher.
     * Input:Long click on the card, select 'delete' from the pop-up menu,and confirm to remove.
     * Expected output:An ArkTs card is deleted from the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_007', 6, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 begin');
      await driver.delayMs(1000);
      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      let rect = await app.getBounds();
      let height =rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_007 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add an ArkTs card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(500);

      // Confirm the number of cards on the desktop
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_007 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardArkTsCount = result.split(cardArkTs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 cardArkTsCount:' + cardArkTsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 hilog err is: ' + JSON.stringify(err));
      });

      // Find and remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 removeCardToDesktop');

      // Verify that one card has been deleted
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_007 getFormData data: ${JSON.stringify(data)}`);
        cardArkTsCountSecond = result.split(cardArkTs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 hilog err is: ' + JSON.stringify(err));
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 assert an ArkTs card has been deleted, ' +
      'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount - 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 ' + (cardArkTsCount - cardArkTsCountSecond) + ' card be deleted');
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_007 end');
      done();
    })

    /**
     * Scene:Delete cards from launcher.
     * Input:Long click on the card, select 'delete' from the pop-up menu.
     * Expected output:A Js card is deleted from the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_008', 7, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 begin');
      await driver.delayMs(1000);
      // Long click the application
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      let rect = await app.getBounds();
      let height =rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.longClick(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_008 long click app, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(100);

      // Add a Js card to launcher
      let serviceCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))));
      await serviceCard.click();
      await driver.delayMs(500);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      await driver.fling({
        x: START_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, {
        x: FINISH_SLIDING_X, y: SLIDING_COORDINATE_Y
      }, 5, 100);
      await driver.delayMs(1000);
      let addCard = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(2000);

      // Confirm the number of cards
      let cardJsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_008 getFormData data: ${JSON.stringify(data)}`);
        expect(result !== null).assertTrue();
        cardJsCount = result.split(cardJs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 cardJsCount:' + cardJsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 hilog err is: ' + JSON.stringify(err));
      });

      // Find and remove the card
      let appList = await driver.findComponents(ON.text(await resourceManager.getStringValue($r('app.string.persistent_name'))));
      await driver.delayMs(1000);
      let rectList = await appList[appList.length-1].getBounds();
      let heightList =rectList.bottom - rectList.top;
      let pointList = await appList[appList.length-1].getBoundsCenter();
      await driver.longClick(pointList.x, pointList.y - heightList);
      let removeText = await resourceManager.getStringValue($r('app.string.remove'));
      let removeCard = await driver.findComponent(ON.text(removeText));
      await removeCard.click();
      await driver.delayMs(1000);
      let remove = await driver.findComponent(ON.text(removeText));
      await remove.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 removeCardToDesktop');

      // Verify that one card has been deleted
      let cardJsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a ' -n ohos.samples.formextability'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 hilog data success');
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_008 getFormData data: ${JSON.stringify(data)}`);
        cardJsCountSecond = result.split(cardJs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 hilog err is: ' + JSON.stringify(err));
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 assert an ArkTs card has been deleted, ' +
      'cardJsCountSecond:' + cardJsCountSecond);
      expect(cardJsCount - 1).assertEqual(cardJsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 ' + (cardJsCount - cardJsCountSecond) + ' card be deleted');
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_008 end');
      done();
    })
  })
}