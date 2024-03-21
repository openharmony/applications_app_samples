/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { describe, beforeAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import inputMethod from '@ohos.inputMethod';
import { logger } from '../../../main/ets/common/Logger';

const BUNDLE: string = 'Asset';
const BUNDLE_NAME: string = 'com.example.asset_sample';
const SLEEP_MS: number = 1500;

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', () => {
    beforeAll(async (done: Function) => {
      logger.info(`${BUNDLE} beforeAll begin`);
      try {
        await abilityDelegator.startAbility({
          bundleName: BUNDLE_NAME,
          abilityName: "EntryAbility"
        });
      } catch (err) {
        logger.info(`${BUNDLE} beforeAll error: ${JSON.stringify(err)}`);
      }
      logger.info(`${BUNDLE}  beforeAll end`);
      done();
    })
    /*
     * @tc.number: AssetAdd001
     * @tc.name: add asset
     * @tc.desc: add asset
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AssetAdd001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_add_001 begin`);
      await sleep(SLEEP_MS);
      let nameInput = await driver.findComponent(ON.id('account_input'));
      await nameInput.inputText('test');
      let secretInput = await driver.findComponent(ON.id('secret_input'));
      await secretInput.inputText('test111');
      let labelInput = await driver.findComponent(ON.id('label_input'));
      await labelInput.inputText('label1');

      inputMethod.getController().stopInputSession();

      let label = await driver.findComponent(ON.id('label'));
      await label.scrollToBottom();

      await sleep(SLEEP_MS);
      let clickAdd = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.save'))));
      await clickAdd.getDescription();
      await clickAdd.click()
      logger.info(`${BUNDLE}_add_001 end`);
      await sleep(SLEEP_MS);
      done();
    })


    /*
     * @tc.number: AssetUpdate002
     * @tc.name: update asset
     * @tc.desc: update asset
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AssetUpdate002', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_update_002 begin`);
      await sleep(SLEEP_MS);
      // let driver: Driver = Driver.create();
      // switch to update
      await driver.click(445, 116);
      await sleep(SLEEP_MS*2);
      // input password
      await driver.click(208, 1015);
      await sleep(SLEEP_MS*2);
      // switch to input number
      await driver.click(54, 1147);
      for (let index = 0; index < 7; index++) {
        await sleep(SLEEP_MS);
        await driver.click(38, 812);
      }
      await sleep(SLEEP_MS*5);
      inputMethod.getController().stopInputSession();

      await sleep(SLEEP_MS*2);

      // select first result to update
      await driver.click(330, 191);
      await sleep(SLEEP_MS*2);

      let label_input = await driver.findComponent(ON.id('label_input'));
      await label_input.inputText('label_update');
      inputMethod.getController().stopInputSession();
      await sleep(SLEEP_MS);

      let clickUpdate = await driver.findComponent(ON.id('update_button'));
      await clickUpdate.click()
      logger.info(`${BUNDLE}_update_002 end`);

      await sleep(SLEEP_MS);
      await driver.click(56, 113);
      done();
    })

    /*
     * @tc.number: AssetSearch003
     * @tc.name: search asset
     * @tc.desc: search asset
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AssetSearch003', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_search_003 begin`);
      await sleep(SLEEP_MS);
      // let driver: Driver = Driver.create();
      // switch to search
      let search_tab = await driver.findComponent(ON.text('查询'));
      search_tab.click();
      await sleep(SLEEP_MS);
      inputMethod.getController().stopInputSession();
      await sleep(SLEEP_MS);
      let search_button = await driver.findComponent(ON.id('search'));
      search_button.click();
      inputMethod.getController().stopInputSession();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.account'))));
      expect(result != null).assertTrue();
      await sleep(SLEEP_MS);
      await driver.click(64, 114);
      logger.info(`${BUNDLE}_search_003 end`);
      await sleep(SLEEP_MS);
      inputMethod.getController().stopInputSession();
      done();
    })

    /*
     * @tc.number: AssetDelete004
     * @tc.name: delete asset
     * @tc.desc: delete asset
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AssetDelete004', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_delete_004 begin`);
      await sleep(SLEEP_MS);
      // let driver: Driver = Driver.create();
      // switch to delete
      await driver.click(263, 120);
      inputMethod.getController().stopInputSession();
      await sleep(SLEEP_MS);
      let clickUpdate = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.delete'))));
      await clickUpdate.click()
      logger.info(`${BUNDLE}_delete_004 end`);
      await sleep(SLEEP_MS);
      done();
    })

  })
}