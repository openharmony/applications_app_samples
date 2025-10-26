/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const LOG_PRINT_DOMAIN:  number = 0xFF00;
const PREFIX: string = '[Test]';
const DELAY_TIME: number = 1000;

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let driver: Driver;
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function NodeInterface() {
  describe('NodeInterface', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    beforeEach(async () => {
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
    })

    /**
     * @tc.number: NdkNodeQueryOperate_001
     * @tc.name: InquireUniqueIdTest
     * @tc.desc: Queries the uniqueId of a node and obtains the node information based on the uniqueId
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('InquireUniqueIdTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'InquireUniqueIdTest begin');
        let driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        try {
          // 点击InquireUniqueId进入界面
          const button = await driver.findComponent(ON.id('InquireUniqueId'));
          await button.click();
          await driver.delayMs(DELAY_TIME);
        } catch (error) {
          hilog.error(LOG_PRINT_DOMAIN, PREFIX, 'InquireUniqueIdTest failed: %{public}s', error.message);
        }

        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'InquireUniqueIdTest end');
        done();
      });

    /**
     * @tc.number: NdkNodeQueryOperate_002
     * @tc.name: AttributeTest
     * @tc.desc: The node property update is triggered in the current instant frame
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AttributeTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'AttributeTest begin');
        let driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        try {
          // 点击Attribute进入界面
          const button = await driver.findComponent(ON.id('Attribute'));
          await button.click();
          await driver.delayMs(DELAY_TIME);
        } catch (error) {
          hilog.error(LOG_PRINT_DOMAIN, PREFIX, 'AttributeTest failed: %{public}s', error.message);
        }

        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'AttributeTest end');
        done();
      });

    /**
     * @tc.number: NdkNodeQueryOperate_003
     * @tc.name: MoveToTest
     * @tc.desc: Mobile node
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('MoveToTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'MoveToTest begin');
        let driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        try {
          // 点击Attribute进入界面
          const button = await driver.findComponent(ON.id('MoveTo'));
          await button.click();
          await driver.delayMs(DELAY_TIME);
        } catch (error) {
          hilog.error(LOG_PRINT_DOMAIN, PREFIX, 'MoveToTest failed: %{public}s', error.message);
        }

        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'MoveToTest end');
        done();
      });

    /**
     * @tc.number: NdkNodeQueryOperate_004
     * @tc.name: GetNodeByIdTest
     * @tc.desc: Test to OH_ArkUI_NodeUtils_GetAttachedNodeHandleById interface
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('GetNodeByIdTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'GetNodeByIdTest begin');
        let driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        try {
          // 点击Attribute进入界面
          const button = await driver.findComponent(ON.id('GetNodeById'));
          await button.click();
          await driver.delayMs(DELAY_TIME);
        } catch (error) {
          hilog.error(LOG_PRINT_DOMAIN, PREFIX, 'GetNodeByIdTest failed: %{public}s', error.message);
        }

        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'GetNodeByIdTest end');
        done();
      });

    /**
     * @tc.number: NdkNodeQueryOperate_005
     * @tc.name: FetchAndLoadTest
     * @tc.desc: Test to OH_ArkUI_NodeUtils_GetAttachedNodeHandleById interface
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('FetchAndLoadTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'FetchAndLoadTest begin');
        let driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        try {
          // 点击Attribute进入界面
          const button = await driver.findComponent(ON.id('FetchAndLoad'));
          await button.click();
          await driver.delayMs(DELAY_TIME);

          let button1 = await driver.findComponent(ON.text("getFirstChildIndexWithoutExpand", MatchPattern.CONTAINS));
          expect(button1 === null).assertFalse();
          await button1.click();
          await driver.delayMs(DELAY_TIME);

          let button2 = await driver.findComponent(ON.text("getLastChildIndexWithoutExpand", MatchPattern.CONTAINS));
          expect(button1 === null).assertFalse();
          await button1.click();
          await driver.delayMs(DELAY_TIME);

          let button3 = await driver.findComponent(ON.text("getChildWithNotExpand", MatchPattern.CONTAINS));
          expect(button1 === null).assertFalse();
          await button1.click();
          await driver.delayMs(DELAY_TIME);

          let button4 = await driver.findComponent(ON.text("getChildWithExpand", MatchPattern.CONTAINS));
          expect(button1 === null).assertFalse();
          await button1.click();
          await driver.delayMs(DELAY_TIME);

          let button5 = await driver.findComponent(ON.text("getChildWithLazyExpand", MatchPattern.CONTAINS));
          expect(button1 === null).assertFalse();
          await button1.click();
          await driver.delayMs(DELAY_TIME);
        } catch (error) {
          hilog.error(LOG_PRINT_DOMAIN, PREFIX, 'FetchAndLoadTest failed: %{public}s', error.message);
        }

        hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'FetchAndLoadTest end');
        done();
      });
  })
}