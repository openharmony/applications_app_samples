/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function FrameNodeTest() {
  describe('FrameNodeTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    let driver = Driver.create();
    const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    beforeAll(async() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      const want: Want = {
        bundleName: 'com.samples.framenode',
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(async (done:Function) => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const driver = Driver.create();
      await driver.pressBack();
      await driver.delayMs(3000);
      done()
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    /**
     * @tc.number ArkUI_FrameNodeTest001
     * @tc.name FrameNodeTest_001
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_001', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeTree'));
      await button.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent((ON.text(await getResourceString($r('app.string.Operate_On_Custom_FrameNode')))));
      await button2.click();
      await driver.delayMs(500);
      const button3 = await driver.findComponent((ON.text(await getResourceString($r('app.string.Operate_On_Proxy_Nodes_In_BuilderNode')))));
      await button3.click();
      await driver.delayMs(500);
      const button4 = await driver.findComponent((ON.text(await getResourceString($r('app.string.Operate_On_Proxy_Nodes_In_System_Components')))));
      await button4.click();
      await driver.delayMs(500);
      const button5 = await driver.findComponent((ON.text(await getResourceString($r('app.string.Add_Proxy_Nodes_Of_BuilderNode')))));
      await button5.click();
      await driver.delayMs(500);
      const button6 = await driver.findComponent((ON.text(await getResourceString($r('app.string.Add_Proxy_Nodes_Of_System_Components')))));
      await button6.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent((ON.text(await getResourceString($r('app.string.Add_Custom_Nodes_With_Existing_Parent_Nodes')))));
      await button1.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest003
     * @tc.name FrameNodeTest_002
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_002', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeMoveTo'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('move'));
      await button1.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest003
     * @tc.name FrameNodeTest_003
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_003', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeCommon'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('modify ArkTS-FrameNode'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('modify FrameNode get by BuilderNode'));
      await button2.click();
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('modify proxyFrameNode get by search'));
      await button3.click();
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('add click event to ArkTS-FrameNode'));
      await button4.click();
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('add click event to FrameNode get by BuilderNode'));
      await button5.click();
      await driver.delayMs(500);
      const button6 = await driver.findComponent(ON.text('add click event to proxyFrameNode get by search'));
      await button6.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest004
     * @tc.name FrameNodeTest_004
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_004', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeDraw'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('Invalidate'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('UpdateLayout'));
      await button2.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest005
     * @tc.name FrameNodeTest_005
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_005', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodePosition'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('getPositionToWindow'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('getPositionToParent'));
      await button2.click();
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('getPositionToScreen'));
      await button3.click();
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('getGlobalPositionOnDisplay'));
      await button4.click();
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('getPositionToParentWithTransform'));
      await button5.click();
      await driver.delayMs(500);
      const button6 = await driver.findComponent(ON.text('getPositionToWindowWithTransform'));
      await button6.click();
      await driver.delayMs(500);
      const button7 = await driver.findComponent(ON.text('getPositionToScreenWithTransform'));
      await button7.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest006
     * @tc.name FrameNodeTest_006
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_006', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeTypeNode'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('getUserConfigBorderWidth'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('getUserConfigPadding'));
      await button2.click();
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('getUserConfigMargin'));
      await button3.click();
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('getUserConfigSize'));
      await button4.click();
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('getId'));
      await button5.click();
      await driver.delayMs(500);
      const button6 = await driver.findComponent(ON.text('getUniqueId'));
      await button6.click();
      await driver.delayMs(500);
      const button7 = await driver.findComponent(ON.text('getNodeType'));
      await button7.click();
      await driver.delayMs(500);
      const button8 = await driver.findComponent(ON.text('getOpacity'));
      await button8.click();
      await driver.delayMs(500);
      const button9 = await driver.findComponent(ON.text('isVisible'));
      await button9.click();
      await driver.delayMs(500);
      const button10 = await driver.findComponent(ON.text('isClipToFrame'));
      await button10.click();
      await driver.delayMs(500);
      const button11 = await driver.findComponent(ON.text('isAttached'));
      await button11.click();
      await driver.delayMs(500);
      const button12 = await driver.findComponent(ON.text('remove Text'));
      await button12.click();
      await driver.delayMs(500);
      const button13 = await driver.findComponent(ON.text('getInspectorInfo'));
      await button13.click();
      await driver.delayMs(500);
      const button14 = await driver.findComponent(ON.text('getCustomProperty'));
      await button14.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest007
     * @tc.name FrameNodeTest_007
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_007', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeDisposed'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('FrameNode dispose'));
      await button1.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest008
     * @tc.name FrameNodeTest_008
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_008', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeIsDisposed'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('FrameNode dispose'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('FrameNode isDisposed'));
      await button2.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest009
     * @tc.name FrameNodeTest_009
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_009', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeLazyForEach'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('Reload'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('Change'));
      await button2.click();
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('Insert'));
      await button3.click();
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('Remove'));
      await button4.click();
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('Move'));
      await button5.click();
      await driver.delayMs(500);
      const button6 = await driver.findComponent(ON.text('Refresh'));
      await button6.click();
      await driver.delayMs(500);
      const button7 = await driver.findComponent(ON.text('Detach'));
      await button7.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest010
     * @tc.name FrameNodeTest_010
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_010', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeLazyForEachSelect'));
      await button.click();
      await driver.delayMs(500);
      const button1 = await driver.findComponent(ON.text('getFirstChildIndexWithoutExpand'));
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('getLastChildIndexWithoutExpand'));
      await button2.click();
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('getChildWithNotExpand'));
      await button3.click();
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('getChildWithExpand'));
      await button4.click();
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('getChildWithLazyExpand'));
      await button5.click();
      await driver.delayMs(500);
    })

    /**
     * @tc.number ArkUI_FrameNodeTest011
     * @tc.name FrameNodeTest_011
     * @tc.desc 自定义组件节点操作节点树
     * @tc.level: Level 1
     */
    it('FrameNodeTest_011', 0, async() => {
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('ShowFrameNodeCanvas'));
      await button.click();
      await driver.delayMs(500);
    })
  })
}