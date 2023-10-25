/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, it, beforeAll } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import { getString } from '../util/ResourceUtil';

const TAG = '[Sample_Customnotification]';
const DOMAIN = 0xF811;
const BUNDLE = 'customnotification_';
const BUNDLE_NAME: string = 'ohos.samples.customnotification';
const ABILITY_NAME: string = 'MainAbility';

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      let parameter: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      };
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegator.startAbility(parameter);
    })
    it('Customnotification_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let window = await driver.findWindow({
        actived: true,
      });
      await window.focus();
      await driver.delayMs(1000);
      await clickBtn(driver, getString($r('app.string.mainAbility_label')));
      await driver.delayMs(500);
      await clickBtn(driver, getString($r('app.string.allow_button')));
      await driver.delayMs(1000);
      await clickAll(driver);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_001 end');
    })

    it('Customnotification_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_002 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);

      await toggle(driver, 'promptTone');
      await clickAll(driver);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_002 end');
    })

    it('Customnotification_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_003 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);

      await toggle(driver, 'vibrationEffect');
      await clickAll(driver);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_003 end');
    })

    it('Customnotification_004', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_004 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);

      await toggle(driver, 'promptTone');
      await clickBtn(driver, getString($r('app.string.basic_notification')));
      await toggle(driver, 'vibrationEffect');
      await clickBtn(driver, getString($r('app.string.basic_notification')));
      await toggle(driver, 'vibrationEffect');
      await clickBtn(driver, getString($r('app.string.basic_notification')));
      await toggle(driver, 'promptTone');
      await clickBtn(driver, getString($r('app.string.basic_notification')));
      await toggle(driver, 'promptTone');
      await clickBtn(driver, getString($r('app.string.basic_notification')));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Customnotification_004 end');
    })
  })

  let clickBtn = async (driver: Driver, msg: string) => {
    await driver.assertComponentExist(ON.text(msg));
    let text1: Component = await driver.findComponent(ON.text(msg));
    await text1.click();
    await driver.delayMs(500);
  }

  let toggle = async (driver: Driver, msg: string) => {
    await driver.assertComponentExist(ON.id(msg));
    let text1: Component = await driver.findComponent(ON.id(msg));
    await text1.click();
    await driver.delayMs(500);
  }

  let clickAll = async (driver: Driver) => {
    await clickBtn(driver, getString($r('app.string.basic_notification')));

    await clickBtn(driver, getString($r('app.string.long_text_notification')));

    await clickBtn(driver, getString($r('app.string.multiline_notification')));

    await clickBtn(driver, getString($r('app.string.picture_notification')));

    await clickBtn(driver, getString($r('app.string.notification_with_buttons')));

    await clickBtn(driver, getString($r('app.string.clickable_notification')));

    await clickBtn(driver, getString($r('app.string.cancel_all_notifications')));

  }

}