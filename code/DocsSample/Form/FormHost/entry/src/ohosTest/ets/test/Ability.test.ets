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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import logger from '../util/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';


const TAG = '[Sample_EtsCardFormHost]';
const BUNDLE = 'FormHost_';


export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
    let manager = abilityDelegatorRegistry.getAppContext().resourceManager;
    const DRIVER = Driver.create();
    beforeAll(async () => {
      await abilityDelegatorRegistry.startAbility({
        bundleName: 'com.samples.formhost',
        abilityName: 'EntryAbility'
      });
      await DRIVER.delayMs(500);
      let inquiryFormButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.inquiryForm'))));
      await inquiryFormButton.click();
      let selectAddFormButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.selectAddForm'))));
      await selectAddFormButton.click();
      while (true) {
        let item = await DRIVER.findComponent(ON.text('com.samples.formprovider'));
        if (item) {
          await item.click();
          break;
        } else {
          await DRIVER.click(200, 1030)
        }
      }
      while (true) {
        await DRIVER.delayMs(100);
        let subItem = await DRIVER.findComponent(ON.text('widget_4_4#4*4'));
        if (subItem) {
          await subItem.click();
          break;
        } else {
          await DRIVER.doubleClick(550, 1030);
        }
      }
      let sureButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.confirm'))));
      await sureButton.click();
      await DRIVER.delayMs(200);
      await DRIVER.assertComponentExist(ON.type('FormComponent'));
    })
    beforeEach(async () => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })


    // 卡片可见
    it('visibleForms', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}visibleForms begin`);
      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(100);
        let visibleFormsButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.visibleForms'))));
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
    it('invisibleForms', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}invisibleForms begin`);
      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(100);
        let invisibleFormsButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.invisibleForms'))));
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
    it('disableFormsUpdate', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}disableFormsUpdate begin`);

      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(100);
        let disableFormsUpdate = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.disableFormsUpdate'))));
        await disableFormsUpdate.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        await selectBar.click();
        await DRIVER.delayMs(100);
        // 执行更新卡片
        let updateFormButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.updateForm'))));
        await updateFormButton.click();
        let executeButton2 = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
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
    it('enableFormsUpdate', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}enableFormsUpdate begin`);
      try {
        let selectBar = await DRIVER.findComponent(ON.type('Select'));
        await selectBar.click();
        await DRIVER.delayMs(100);
        let enableFormsUpdateButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.enableFormsUpdate'))));
        await enableFormsUpdateButton.click();
        let executeButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton.click();
        await DRIVER.delayMs(100);
        await selectBar.click();
        await DRIVER.delayMs(100);
        // 执行更新卡片
        let updateFormButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.updateForm'))));
        await updateFormButton.click();
        let executeButton2 = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.execute'))));
        await executeButton2.click();
        await DRIVER.delayMs(100);
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
    it('deleteForm', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}deleteForm begin`);
      try {
        let scrollBar = await DRIVER.findComponent(ON.type('Select'));
        await scrollBar.click();
        await DRIVER.delayMs(500);
        // 执行删除卡片
        let deleteFormButton = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.deleteForm'))));
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