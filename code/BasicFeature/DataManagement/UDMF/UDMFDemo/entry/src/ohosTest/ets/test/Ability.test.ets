/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../../../main/ets/util/Logger';

const TAG = '[Sample_UDMFDemo]';
const DOMAIN = 0xF811;
const BUNDLE = 'UDMFDemo_';

export default function abilityTest() {
  describe('UDMFDemo', () => {
    /**
     * @tc.number UDMFDemo_StartAbilityFunction_001
     * @tc.name UDMFDemo_StartAbilityFunction_001
     * @tc.desc Test start ability.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMFDemo_StartAbilityFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.example.udmfdemo",
          abilityName: "EntryAbility"
        });
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })

    /**
     * @tc.number UDMF_Select_001
     * @tc.name UDMF_Select_001
     * @tc.desc Test file select.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMF_Select_001', 0, async () => {
      logger.info(TAG, 'UDMF_Select_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('SelectTypeList'));
      let btnStart = await driver.findComponent(ON.id('SelectTypeList'));
      await btnStart.click();
      await driver.delayMs(500);
      await driver.click(190, 550);
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('test1.txt' , MatchPattern.CONTAINS));
      let ics = await driver.findComponent(ON.text('test1.txt' , MatchPattern.CONTAINS));
      await ics.click();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('textContent'));
      let textContent = await driver.findComponent(ON.id('textContent'));
      let inputString = await textContent.getText();
      logger.info(TAG, 'UDMF_Select_001 inputString: ' + inputString);

      expect(inputString.includes('test content 1 test content 2')).assertTrue();

      await driver.assertComponentExist(ON.id('SelectTypeList'));
      let selectStart = await driver.findComponent(ON.id('SelectTypeList'));
      await selectStart.click();
      await driver.delayMs(500);
      await driver.click(170, 260);
      await driver.delayMs(1000);

      logger.info(TAG, 'UDMF_Select_001 end');
    })

    /**
     * @tc.number UDMF_Select_002
     * @tc.name UDMF_Select_002
     * @tc.desc Test file select.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMF_Select_002', 0, async () => {
      logger.info(TAG, 'UDMF_Select_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('SelectTypeList'));
      let btnStart = await driver.findComponent(ON.id('SelectTypeList'));
      await btnStart.click();
      await driver.delayMs(500);
      await driver.click(250, 700);
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('ics' , MatchPattern.CONTAINS));
      let ics = await driver.findComponent(ON.text('ics' , MatchPattern.CONTAINS));
      expect(ics != null ).assertTrue();

      await driver.assertComponentExist(ON.id('SelectTypeList'));
      let selectStart = await driver.findComponent(ON.id('SelectTypeList'));
      await selectStart.click();
      await driver.delayMs(500);
      await driver.click(170, 260);
      await driver.delayMs(1000);
      logger.info(TAG, 'UDMF_Select_002 end');
    })

    /**
     * @tc.number UDMF_Drag_001
     * @tc.name UDMF_Drag_001
     * @tc.desc Test file drag.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMF_Drag_001', 0, async () => {
      logger.info(TAG, 'UDMF_Drag_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('targetText'));
      let textTarget = await driver.findComponent(ON.id('targetText'));
      await driver.delayMs(500);

      await driver.drag(100, 320, 430, 180);
      await driver.delayMs(1000);

      let result = await textTarget.getText();
      expect(result.includes('Save as')).assertTrue();
      logger.info(TAG, 'UDMF_Drag_001 end');
    })

    /**
     * @tc.number UDMF_Drag_002
     * @tc.name UDMF_Drag_002
     * @tc.desc Test text Drag.
     * @tc.size MEDIUM
     * @tc.type Function
     * @tc.level Level 0
     * @tc.require
     */
    it('UDMF_Drag_002', 0, async () => {
      logger.info(TAG, 'UDMF_Drag_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);

      logger.info(TAG, 'UDMF_Drag_002 aa');
      await driver.assertComponentExist(ON.id('targetText'));
      let textTarget = await driver.findComponent(ON.id('targetText'));

      logger.info(TAG, 'UDMF_Drag_002 bb');
      await driver.delayMs(500);

      await driver.click(100, 320);
      await driver.delayMs(500);

      await driver.drag(350, 740, 430, 180);
      await driver.delayMs(1000);

      let result = await textTarget.getText();
      expect(result.includes('Content save as')).assertTrue();
      logger.info(TAG, 'UDMF_Drag_002 end');
    })
  })
}