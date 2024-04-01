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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_Screen]';
const DOMAIN = 0xF811;
const BUNDLE = 'Screen_';
const DRIVER = Driver.create();

export default function appTest() {
  describe('appTest', () => {
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.screen',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      }
    })

    /**
     * DeviceInfo
     */
    it(BUNDLE + 'DeviceInfo_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceInfo_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('bigRect'));
      let bigRect = await DRIVER.findComponent(ON.id('bigRect'));
      await bigRect.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('smallRectId'));
      let screenDetail1 = await DRIVER.findComponent(ON.id('smallRectId'));
      await screenDetail1.click();
      await DRIVER.delayMs(1000);
      let screenDetail2 = await DRIVER.findComponent(ON.id('smallRectId'));
      expect(screenDetail2).assertNull();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceInfo_001 end')
    })

    /**
     * AddScreen
     */
    it(BUNDLE + 'AddScreen_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreen_001 begin');
      await DRIVER.assertComponentExist(ON.id('addScreen'));
      let addScreen = await DRIVER.findComponent(ON.id('addScreen'));
      await addScreen.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('smallRect1'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreen_001 end')
    })

    /**
     * SmallDeviceInfo
     */
    it(BUNDLE + 'SmallDeviceInfo_001', 0, async (done: Function) => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'SmallDeviceInfo_001 begin');
      await DRIVER.assertComponentExist(ON.id('smallRect1'));
      let smallRect1 = await DRIVER.findComponent(ON.id('smallRect1'));
      await smallRect1.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('smallRectId'));
      let screenDetail = await DRIVER.findComponent(ON.id('smallRectId'));
      let smallRectIdArray = (await screenDetail.getText()).trimStart().split(' ');
      expect(smallRectIdArray.length).assertEqual(2);
      await screenDetail.click();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SmallDeviceInfo_001 end');
    })

    /**
     * DeleteSmallDevice
     */
    it(BUNDLE + 'DeleteSmallDevice_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteSmallDevice_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('removeScreen'));
      let removeScreen = await DRIVER.findComponent(ON.id('removeScreen'));
      await removeScreen.click();
      await DRIVER.delayMs(1000);
      let smallRect1 = await DRIVER.findComponent(ON.id('smallRect1'));
      expect(smallRect1).assertNull();
      let screenDetail = await DRIVER.findComponent(ON.id('smallRectId'));
      expect(screenDetail).assertNull();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteSmallDevice_001 end');
    })
  })
}