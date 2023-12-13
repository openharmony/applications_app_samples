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

import { describe, beforeAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../util/Logger';

const BUNDLE: string = 'AbilityFeature';
const BUNDLE_NAME: string = 'com.samples.abilityFeature';
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
     * @tc.number: AbilityFeatureSwitchLanguage001
     * @tc.name: SwitchLanguage
     * @tc.desc: SwitchLanguage
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSwitchLanguage001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_SwitchLanguage_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();
      let listItemEng = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Set_English_Language'))));
      await listItemEng.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Set_Ch_language'))));
      expect(result != null).assertTrue();
      done();
    })

    /*
     * @tc.number: AbilityFeatureSwitchLanguage002
     * @tc.name: SwitchLanguage
     * @tc.desc: SwitchLanguage
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSwitchLanguage002', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_SwitchLanguage_002 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();
      let listItemChn = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Set_Ch_language'))));
      await listItemChn.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.system_BasicCharacter_Demo'))));
      expect(result != null).assertTrue();
      done();
    })

    /*
     * @tc.number: AbilityFeature_SwitchColorMode_001
     * @tc.name: SwitchDarkColorMode
     * @tc.desc: SwitchDarkColorMode
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeature_SwitchColorMode_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_SwitchColorMode_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();
      let listItem_dark = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Set_Dark_Mode'))));
      await listItem_dark.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.switchDarkSuccess'))));
      expect(result != null).assertTrue();
      done();
    })
    /*
     * @tc.number: AbilityFeature_SwitchColorMode_002
     * @tc.name: SwitchLightColorMode
     * @tc.desc: SwitchLightColorMode
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeature_SwitchColorMode_002', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_SwitchColorMode_002 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();
      let listItem_Light = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Set_Light_Mode'))));
      await listItem_Light.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.switchLightSuccess'))));
      expect(result != null).assertTrue();
      done();
    })
    /*
     * @tc.number: AbilityFeature_ImplicitLaunchNotPopup_002
     * @tc.name: ImplicitLaunchNotPopup
     * @tc.desc: ImplicitLaunchNotPopup
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeature_ImplicitLaunchNotPopup_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ImplicitLaunchNotPopup_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_PopUp = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Implicit_Launch_Popup'))));
      await listItem_PopUp.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.canNotOpen'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_ImplicitLaunchNotPopup_001 end`);
      done();
    })
    /*
     * @tc.number: AbilityFeature_ImplicitLaunchNotPopup_001
     * @tc.name: ImplicitLaunchNotPopup
     * @tc.desc: ImplicitLaunchNotPopup
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeature_ImplicitLaunchNotPopup_002', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ImplicitLaunchNotPopup_002 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_know = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.know'))));
      await listItem_know.click();
      await sleep(SLEEP_MS);

      let listItem_NotPopUp = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Implicit_Launch_not_Popup'))));
      await listItem_NotPopUp.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Implicit_Launch_not_Popup'))));
      expect(result != null).assertTrue();
      done();
    })

    /*
     * @tc.number: AbilityFeature_StartOptions_001
     * @tc.name: StartOptions
     * @tc.desc: setStartOptions to startAbility
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeature_StartOptions_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_StartOptions_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_open = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.open'))));
      await listItem_open.click();
      await sleep(SLEEP_MS);

      let listItem_startOption = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.setStartOptionsPage'))));
      await listItem_startOption.click();
      await sleep(SLEEP_MS);

      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.NewAbility_label'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_StartOptions_001 end`);

      let listItem_back = await driver.findComponent(ON.type('Image'));
      listItem_back.click();
      done();
    })

    /*
     * @tc.number: AbilityFeature_CleanStorageData_001
     * @tc.name: CleanStorageData
     * @tc.desc: CleanStorageData
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    // it('AbilityFeature_CleanStorageData_001', 0, async (done: Function) => {
    //   logger.info(`${BUNDLE}_CleanStorageData_001 begin`);
    //   await sleep(SLEEP_MS);
    //   let driver: Driver = Driver.create();
    //
    //   let listItem_Create = await driver.findComponent(ON.text(
    //   await getResourceString($r('app.string.CreateStorageData'))));
    //   await listItem_Create.click();
    //   await sleep(SLEEP_MS);
    //   await driver.assertComponentExist(ON.text(
    //   await getResourceString($r('app.string.create_File_Success'))));
    //   await sleep(SLEEP_MS);
    //
    //   let listItem_CheckFirst = await driver.findComponent(ON.text(
    //   await getResourceString($r('app.string.CheckStorageData'))));
    //   await listItem_CheckFirst.click();
    //   await sleep(SLEEP_MS);
    //   let result = await driver.findComponent(ON.text(
    //   await getResourceString($r('app.string.search_File_Success'))));
    //   expect(result != null).assertTrue();
    //   done();
    // })

    /*
     * @tc.number: AbilityFeature_CleanStorageData_002
     * @tc.name: CleanStorageData
     * @tc.desc: CleanStorageData
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    // it('AbilityFeature_CleanStorageData_002', 0, async (done: Function) => {
    //   logger.info(`${BUNDLE}_CleanStorageData_002 begin`);
    //   let driver: Driver = Driver.create();
    //
    //   let listItem_Clear = await driver.findComponent(ON.text(
    //   await getResourceString($r('app.string.ClearStorageData'))));
    //   await listItem_Clear.click();
    //   await sleep(SLEEP_MS);
    //
    //   let listItem_CheckSecond = await driver.findComponent(ON.text(
    //   await getResourceString($r('app.string.CheckStorageData'))));
    //   await listItem_CheckSecond.click();
    //   await sleep(SLEEP_MS);
    //   let result = await driver.findComponent(ON.text(
    //   await getResourceString($r('app.string.search_File_Failed'))));
    //   expect(result != null).assertTrue();
    //   logger.info(`${BUNDLE}_CleanStorageData_002 end`);
    //   done();
    // })
  })
}