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

const BUNDLE: string = 'AbilityFeatureSystem';
const BUNDLE_NAME: string = 'com.samples.abilityFeatureSystem';
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
     * @tc.number: AbilityFeatureSystem_QueryAppStatus_001
     * @tc.name: QueryAppStatus
     * @tc.desc: QueryAppStatus
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_QueryAppStatus_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_QueryAppStatus_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_queryStatus = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Query_App_Status'))));
      await listItem_queryStatus.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.isRunning'))));
      expect(result != null).assertTrue();
      done();
    })

    /*
     * @tc.number: AbilityFeatureSystem_CreateModalUIExtension_001
     * @tc.name: CreateModalUIExtension
     * @tc.desc: UIExtension createModal
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_CreateModalUIExtension_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_CreateModalUIExtension_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_createModal = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.Create_Modal_UIExtension'))));
      await listItem_createModal.click();
      await sleep(SLEEP_MS);
      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.NewUIExtAbility_label'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_CreateModalUIExtension_001 end`);
      await driver.click(52.000000, 85.000000);
      done();
    })

    /*
     * @tc.number: AbilityFeatureSystem_SendSyncData_001
     * @tc.name: SendSyncData
     * @tc.desc: UIExtension sendSyncData
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_SendSyncData_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_SendSyncData_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_sendSync = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.sendSyncData'))));
      await listItem_sendSync.click();
      await sleep(SLEEP_MS);

      let listItem_sendSyncAgain = await driver.findComponent(ON.id('sendSync'));
      await listItem_sendSyncAgain.click();
      await sleep(SLEEP_MS);

      let result_home = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.HomeAbility_onReceive'))));
      let result_ext = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.UIExtensionAbility_onReceive'))));
      expect(result_home != null).assertTrue();
      expect(result_ext != null).assertTrue();
      logger.info(`${BUNDLE}_SendSyncData_001 end`);

      await driver.click(52.000000, 85.000000);
      done();
    })

    /*
     * @tc.number: AbilityFeatureSystem_startAbilityByType_001
     * @tc.name: UIAbilityStartAbilityByType
     * @tc.desc: UIAbilityStartAbilityByType
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_startAbilityByType_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ExtStartAbilityAsCaller_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_startByType = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.StartAbilityByType'))));
      await listItem_startByType.click();
      await sleep(SLEEP_MS);

      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.NewUIExtAbility_label'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_ExtStartAbilityByType_001 end`);
      await driver.click(52.000000, 85.000000);
      done();
    })
    /*
     * @tc.number: AbilityFeatureSystem_startAbilityAsCaller_001
     * @tc.name: UIAbilityStartAbilityAsCaller
     * @tc.desc: UIAbilityStartAbilityAsCaller
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_startAbilityAsCaller_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ExtStartAbilityAsCaller_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_startAsCaller = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.StartAbilityAsCaller'))));
      await listItem_startAsCaller.click();
      await sleep(SLEEP_MS);

      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.NewAbility_label'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_ExtStartAbilityAsCaller_001 end`);
      await driver.click(52.000000, 85.000000);
      done();
    })

    /*
     * @tc.number: AbilityFeatureSystem_ExtStartAbilityByType_001
     * @tc.name: UIExtensionStartAbilityByType
     * @tc.desc: UIExtensionStartAbilityByType
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_ExtSAbilityByType_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ExtStartAbilityAsCaller_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_startUIExtension = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.startUIExtensionAbility'))));
      await listItem_startUIExtension.click();
      await sleep(SLEEP_MS);

      let listItem_startByType = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.extStartAbilityByType'))));
      await listItem_startByType.click();
      await sleep(SLEEP_MS);

      let result = await driver.findComponent(ON.text(
        await getResourceString($r('app.string.NewUIExtAbility_label'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_ExtStartAbilityByType_001 end`);
      await driver.click(52.000000, 85.000000);
      done();
    })

    /*
     * @tc.number: AbilityFeatureSystem_ExtStartAbilityAsCaller_001
     * @tc.name: UIExtensionStartAbilityAsCaller
     * @tc.desc: UIExtensionStartAbilityAsCaller
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AbilityFeatureSystem_ExtStartAbilityAsCaller_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ExtStartAbilityAsCaller_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();

      let listItem_startAsCaller = await driver.findComponent(
        ON.text(await getResourceString($r('app.string.extStartAbilityAsCaller'))));
      await listItem_startAsCaller.click();
      await sleep(SLEEP_MS);

      let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.NewAbility_label'))));
      expect(result != null).assertTrue();
      logger.info(`${BUNDLE}_ExtStartAbilityAsCaller_001 end`);
      await driver.click(52.000000, 85.000000);
      done();
    })
  })
}