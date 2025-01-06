/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Driver, MatchPattern, ON } from '@ohos.UiTest';
import logger from '../util/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_EtsCardFormHost]';
const BUNDLE = 'FormHost_';
const DELAYTIME01 = 100;
const DELAYTIME02 = 200;
const DELAYTIME03 = 500;

export default function abilityTest() {
  describe('ActsAbilityTest_001', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
    let manager = abilityDelegatorRegistry.getAppContext().resourceManager;
    const DRIVER = Driver.create();
    beforeAll(async () => {
      await abilityDelegatorRegistry.startAbility({
        bundleName: 'com.samples.formhost',
        abilityName: 'EntryAbility'
      });
      await DRIVER.delayMs(DELAYTIME03);
      let inquiryFormButton =
        await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.inquiryForm'))));
      await inquiryFormButton.click();
      let selectAddFormButton =
        await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.selectAddForm'))));
      await selectAddFormButton.click();
      await DRIVER.delayMs(DELAYTIME03);
      while (true) {
        let item = await DRIVER.findComponent(ON.text('com.ohos.photos', MatchPattern.CONTAINS));
        if (item) {
          await item.click();
          break;
        } else {
          await DRIVER.click(200, 650);
          await DRIVER.delayMs(DELAYTIME03);
        }
      }
      while (true) {
        await DRIVER.delayMs(DELAYTIME01);
        let subItem = await DRIVER.findComponent(ON.text('widget#2*2', MatchPattern.CONTAINS));
        if (subItem) {
          await subItem.click();
          break;
        } else {
          await DRIVER.doubleClick(550, 650);
        }
      }
      let sureButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.confirm'))));
      await sureButton.click();
      await DRIVER.delayMs(DELAYTIME02);
      await DRIVER.assertComponentExist(ON.type('FormComponent'));
    })
    beforeEach(async () => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    // 卡片可见
    it(BUNDLE + 'visibleForms_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}visibleForms begin`);
      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(DELAYTIME01);
        let visibleFormsButton =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.visibleForms'))));
        await visibleFormsButton.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        expect(true).assertTrue();
        logger.info(TAG, `${BUNDLE}visibleForms end`);
        done();
      } catch (err) {
        logger.info(TAG, `${BUNDLE} ${err}`);
        expect(false).assertTrue();
        done();
      }
    })

    // 卡片不可见
    it(BUNDLE + 'invisibleForms_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}invisibleForms begin`);
      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(DELAYTIME01);
        let invisibleFormsButton =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.invisibleForms'))));
        await invisibleFormsButton.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        expect(true).assertTrue();
        logger.info(TAG, `${BUNDLE}invisibleForms end`);
        done();
      } catch (err) {
        logger.info(TAG, `${BUNDLE} ${err}`);
        expect(false).assertTrue();
        done();
      }
    })

    // 卡片不可以更新
    it(BUNDLE + 'disableFormsUpdate_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}disableFormsUpdate begin`);

      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(DELAYTIME01);
        let disableFormsUpdate =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.disableFormsUpdate'))));
        await disableFormsUpdate.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        await selectBar.click();
        await DRIVER.delayMs(DELAYTIME01);
        // 执行更新卡片
        let updateFormButton =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.updateForm'))));
        await updateFormButton.click();
        let executeButton2 =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton2.click();
        expect(true).assertTrue();
        logger.info(TAG, `${BUNDLE}disableFormsUpdate end`);
        done();
      } catch (err) {
        logger.info(TAG, `${BUNDLE} ${err}`);
        expect(false).assertTrue();
        done();
      }
    })

    // 卡片可以更新
    it(BUNDLE + 'enableFormsUpdate_004', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}enableFormsUpdate begin`);
      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(DELAYTIME01);
        let enableFormsUpdateButton =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.enableFormsUpdate'))));
        await enableFormsUpdateButton.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        await DRIVER.delayMs(DELAYTIME01);
        await selectBar.click();
        await DRIVER.delayMs(DELAYTIME01);
        // 执行更新卡片
        let updateFormButton =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.updateForm'))));
        await updateFormButton.click();
        let executeButton2 =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton2.click();
        await DRIVER.delayMs(DELAYTIME01);
        expect(true).assertTrue();
        logger.info(TAG, `${BUNDLE}enableFormsUpdate end`);
        done();
      } catch (err) {
        logger.info(TAG, `${BUNDLE} ${err}`);
        expect(false).assertTrue();
        done();
      }
    })

    // 删除卡片
    it(BUNDLE + 'deleteForm_005', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}deleteForm begin`);
      try {
        let scrollBar = await DRIVER.findComponent(ON.type('Select'));
        await scrollBar.click();
        await DRIVER.delayMs(DELAYTIME03);
        // 执行删除卡片
        let deleteFormButton =
          await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.deleteForm'))));
        await deleteFormButton.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        expect(true).assertTrue();
        logger.info(TAG, `${BUNDLE}deleteForm end`);
        done();
      } catch (err) {
        logger.info(TAG, `${BUNDLE} ${err}`);
        expect(false).assertTrue();
        done();
      }
    })
  })
}