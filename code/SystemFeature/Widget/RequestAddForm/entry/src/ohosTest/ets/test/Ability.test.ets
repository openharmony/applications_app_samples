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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';

const TAG = '[Sample_RequestAdd_Test]';
const DOMAIN = 0xF811;
const BUNDLE = 'RequestAdd_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
let addArkTsButtonId = 'addArkTsCard';
let addJsButtonId = 'addJsCard';
let formArkTs = 'widget';
let formJs = 'JsWidget';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * Scene:Publish data agent cards to the desktop in the application.
     * Input:Click to open the application, click the button to publish the data agent card.
     * Expected output:An ArkTs card be added to the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_017', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      // Find the number of application
      let cardArkTsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.ohos.hag.famanager'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_017 getFormData ArkTs : + ${JSON.stringify(data)}`);
        let result = JSON.stringify(data);
        expect(result !== null).assertTrue();
        cardArkTsCount = result.split(formArkTs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 cardArkTsCount:' + cardArkTsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 hilog err is: ' + JSON.stringify(err));
      });

      // Find and open the test application
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 driver.findComponent start');
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.app_name'))));
      // Get the text control border
      let rect = await app.getBounds();
      // Calculate the height of the text control
      let height = rect.bottom - rect.top;
      // Get the center point of the text control
      let point = await app.getBoundsCenter();
      await driver.click(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_017 open appStore, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(500);

      // Find the button and click
      let button = await driver.findComponent(ON.id(addArkTsButtonId));
      await button.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 click the button');
      await driver.delayMs(500);

      // Verify a card has been added to the desktop
      let cardArkTsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.ohos.hag.famanager'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_017 getFormData ArkTs : + ${JSON.stringify(data)}`);
        let result = JSON.stringify(data);
        cardArkTsCountSecond = result.split(formArkTs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 hilog err is: ' + JSON.stringify(err));
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 assert an ArkTs card has been added, ' +
        'cardArkTsCountSecond:' + cardArkTsCountSecond);
      expect(cardArkTsCount + 1).assertEqual(cardArkTsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 ' + (cardArkTsCountSecond - cardArkTsCount) + ' ArkTs card be added');

      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_017 end');
      done();
    })

    /**
     * Scene:Publish data agent cards to the desktop in the application.
     * Input:Click to open the application, click the button to publish the data agent card.
     * Expected output:A Js card be added to the desktop successfully.
     */
    it(BUNDLE + 'DataProxyForm_018', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 begin');
      let driver = Driver.create();
      await driver.delayMs(500);
      // Find the number of application
      let cardJsCount = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.ohos.hag.famanager'").then((data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_018 getFormData Js: + ${JSON.stringify(data)}`);
        let result = JSON.stringify(data);
        expect(result !== null).assertTrue();
        cardJsCount = result.split(formJs).length - 1;
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 cardJsCount:' + cardJsCount);
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 hilog err is: ' + JSON.stringify(err));
      });

      // Find and open the test application
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 driver.findComponent start');
      let app = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.app_name'))));
      let rect = await app.getBounds();
      let height = rect.bottom - rect.top;
      let point = await app.getBoundsCenter();
      await driver.click(point.x, point.y - height);
      hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_018 open appStore, coordinate:(${point.x},` + `${point.y - height})`);
      await driver.delayMs(500);

      // Find the button and click
      let button = await driver.findComponent(ON.id(addJsButtonId));
      await button.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 click the button');
      await driver.delayMs(500);

      // Verify a card has been added to the desktop
      let formJsCountSecond = 0;
      await abilityDelegator.executeShellCommand("hidumper -s FormMgr -a '-n com.ohos.hag.famanager'").then((data) => {
        let result = JSON.stringify(data);
        hilog.info(DOMAIN, TAG, BUNDLE + `DataProxyForm_018 getFormData Js: + ${JSON.stringify(data)}`);
        formJsCountSecond = result.split(formJs).length - 1;
      }).catch((err: BusinessError) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 hilog err is: ' + JSON.stringify(err));
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 assert an Js card has been added, ' +
        'formJsCountSecond:' + formJsCountSecond);
      expect(cardJsCount + 1).assertEqual(formJsCountSecond);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 ' + (formJsCountSecond - cardJsCount) + ' Js card be added');

      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataProxyForm_018 end');
      done();
    })
  })
}