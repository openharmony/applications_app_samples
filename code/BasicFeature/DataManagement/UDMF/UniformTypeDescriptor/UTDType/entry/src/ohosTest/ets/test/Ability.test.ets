/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'
import { logger } from '../util/Logger';

const TIME_OUT = 60000;
const TAG: string = 'Sample_UTDType';
let ability: UIAbility | undefined = undefined;
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {

  describe('ActsAbilityTest', () => {
    /**
     * @tc.number UDMF_StartAbility_00100
     * @tc.name UDMF_StartAbility_001
     * @tc.desc Test app start, wrong owner.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMF_StartAbility_001', 0, async (done : () => void) => {
      logger.info(TAG, 'UDMF_StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.UTDType',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (exception) {
        logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      let onAbilityCreateCallback: () => void = (): void => {
        logger.info(TAG, "onAbilityCreateCallback");
      }
      let monitor: AbilityDelegatorRegistry.AbilityMonitor = {
        abilityName: "EntryAbility",
        onAbilityCreate: onAbilityCreateCallback
      };
      ability = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT);
      logger.info(TAG, 'UDMF_StartAbility_001 end');
    })

    /**
     * @tc.number UDMF_EnterMainPage_00100
     * @tc.name UDMF_EnterMainPage_001
     * @tc.desc Test app first page, click button router to main page.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMF_EnterMainPage_001', 0, async () => {
      logger.info(TAG, 'UDMF_EnterMainPage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.type('Button'));
      let btnStart = await driver.findComponent(ON.type('Button').id('EnterMainPage'));
      await btnStart.click();
      await driver.delayMs(1000);
      logger.info(TAG, 'UDMF_EnterMainPage_001 end');
    })

    /**
     * @tc.number UDMF_select_type_00100
     * @tc.name UDMF_select_type_001
     * @tc.desc Test getUniformDataTypeByFilenameExtension() and belongsTo() interface.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 1
     * @tc.require
     */
    it('UDMF_select_type_001', 1, async () => {
      logger.info(TAG, 'UDMF_select_type_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('SelectTypeList'));
      let selectType = await driver.findComponent(ON.id('SelectTypeList'));
      await selectType.click();
      await driver.delayMs(500);
      await driver.click(54, 233);
      await driver.delayMs(500);
      await driver.click(166, 509);
      await driver.delayMs(500);
      logger.info(TAG, 'UDMF_select_type_001 end');
    })

    /**
     * @tc.number UDMF_select_file_00100
     * @tc.name UDMF_select_file_001
     * @tc.desc Test getTypeDescriptor() interace and iconFile proerty.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 1
     * @tc.require
     */
    it('UDMF_select_file_001', 1, async () => {
      logger.info(TAG, 'UDMF_select_file_001 begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.type('List'));
      await driver.findComponent(ON.type('ListItem').id('listItem_1'));

      await driver.assertComponentExist(ON.type('Text').id('textFilename_1'));
      let selectFile = await driver.findComponent(ON.type('Text').id('textFilename_1'));
      await selectFile.click();
      await driver.delayMs(1000);
      logger.info(TAG, 'UDMF_select_file_001 end');
    })

    /**
     * @tc.number UDMF_back_to_main_00100
     * @tc.name UDMF_back_to_main_001
     * @tc.desc Test app router back to main page.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 1
     * @tc.require
     */
    it('UDMF_back_to_main_001', 1, async () => {
      logger.info(TAG, 'UDMF_back_to_main_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('thirdPageBack'));
      let routerBack = await driver.findComponent(ON.id('thirdPageBack'));
      await routerBack.click();
      await driver.delayMs(1000);
      logger.info(TAG, 'UDMF_back_to_main_001 end');
    })

  })
}
