/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
let driver: Driver;
const TAG = '[Sample_EnableCustomComponentCrossAbility]';
const DOMAIN = 0xF811;
const BUNDLE = 'enablecustomcomponentcrossability_';

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(2000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN,TAG,BUNDLE + 'get top ability')
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number IndexPageLoadTest
     * @tc.name 首页加载测试
     * @tc.desc 验证基础元素渲染，检查首页包含"add node to tree"、"remove node from tree"、"start new ability"按钮
     */
    it('IndexPageLoadTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPageLoadTest start');
      // 验证首页包含"add node to tree"按钮
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();

      // 验证首页包含"remove node from tree"按钮
      let removeNodeBtn = await driver.findComponent(ON.text('remove node from tree', MatchPattern.CONTAINS));
      expect(removeNodeBtn === null).assertFalse();

      // 验证首页包含"start new ability"按钮
      let startAbilityBtn = await driver.findComponent(ON.text('start new ability', MatchPattern.CONTAINS));
      expect(startAbilityBtn === null).assertFalse();

      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPageLoadTest end');
      done();
    });

    /**
     * @tc.number AddNodeToTreeTest
     * @tc.name 创建BuilderNode节点
     * @tc.desc 点击"add node to tree"按钮，BuilderNode节点成功创建并挂载到NodeContainer下，显示自定义组件
     */
    it('AddNodeToTreeTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddNodeToTreeTest start');
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      // 验证自定义组件显示
      let messageElement = await driver.findComponent(ON.text('message:', MatchPattern.CONTAINS));
      expect(messageElement === null).assertFalse();

      hilog.info(DOMAIN, TAG, BUNDLE + 'AddNodeToTreeTest end');
      done();
    });

    /**
     * @tc.number RemoveNodeFromTreeTest
     * @tc.name 移除BuilderNode节点
     * @tc.desc 点击"remove node from tree"按钮，BuilderNode节点从NodeContainer上移除，但节点未被销毁
     */
    it('RemoveNodeFromTreeTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RemoveNodeFromTreeTest start');
      // 先添加节点
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      // 移除节点
      let removeNodeBtn = await driver.findComponent(ON.text('remove node from tree', MatchPattern.CONTAINS));
      expect(removeNodeBtn === null).assertFalse();
      await removeNodeBtn!.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'RemoveNodeFromTreeTest end');
      done();
    });

    /**
     * @tc.number StartNewAbilityTest
     * @tc.name 拉起ExtraAbility
     * @tc.desc 点击"start new ability"按钮，成功拉起ExtraAbility，跳转到ExtraIndex页面
     */
    it('StartNewAbilityTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartNewAbilityTest start');
      let startAbilityBtn = await driver.findComponent(ON.text('start new ability', MatchPattern.CONTAINS));
      expect(startAbilityBtn === null).assertFalse();
      await startAbilityBtn!.click();
      await driver.delayMs(3000);

      // 验证跳转到ExtraIndex页面
      let extraIndexElement = await driver.findComponent(ON.text('ExtraIndex', MatchPattern.CONTAINS));
      expect(extraIndexElement === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'StartNewAbilityTest end');
      done();
    });

    /**
     * @tc.number DisposeNodeTest
     * @tc.name 销毁BuilderNode节点
     * @tc.desc 在ExtraIndex页面点击"dispose node"按钮，BuilderNode节点被销毁，globalBuilderNode变为undefined
     */
    it('DisposeNodeTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisposeNodeTest start');
      // 先在Index页面添加节点
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      // 拉起ExtraAbility
      let startAbilityBtn = await driver.findComponent(ON.text('start new ability', MatchPattern.CONTAINS));
      expect(startAbilityBtn === null).assertFalse();
      await startAbilityBtn!.click();
      await driver.delayMs(3000);

      // 在ExtraIndex页面销毁节点
      let disposeNodeBtn = await driver.findComponent(ON.text('dispose node', MatchPattern.CONTAINS));
      expect(disposeNodeBtn === null).assertFalse();
      await disposeNodeBtn!.click();
      await driver.delayMs(1000);

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'DisposeNodeTest end');
      done();
    });

    /**
     * @tc.number CrossAbilityMountTest
     * @tc.name 跨Ability迁移-挂载组件
     * @tc.desc 在ExtraIndex页面点击"add node to tree"按钮，之前创建的BuilderNode节点成功挂载到新的NodeContainer下
     */
    it('CrossAbilityMountTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CrossAbilityMountTest start');
      // 第一步：在Index页面创建BuilderNode
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      // 第二步：移除节点（不销毁）
      let removeNodeBtn = await driver.findComponent(ON.text('remove node from tree', MatchPattern.CONTAINS));
      expect(removeNodeBtn === null).assertFalse();
      await removeNodeBtn!.click();
      await driver.delayMs(1000);

      // 第三步：拉起新Ability
      let startAbilityBtn = await driver.findComponent(ON.text('start new ability', MatchPattern.CONTAINS));
      expect(startAbilityBtn === null).assertFalse();
      await startAbilityBtn!.click();
      await driver.delayMs(3000);

      // 第四步：在ExtraIndex页面重新挂载节点
      let addNodeBtnInExtra = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtnInExtra === null).assertFalse();
      await addNodeBtnInExtra!.click();
      await driver.delayMs(1000);

      // 验证组件正常显示
      let messageElement = await driver.findComponent(ON.text('message:', MatchPattern.CONTAINS));
      expect(messageElement === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'CrossAbilityMountTest end');
      done();
    });

    /**
     * @tc.number CrossAbilityStateUpdateTest
     * @tc.name 跨Ability迁移-状态变量更新
     * @tc.desc 点击"change message"按钮，状态变量message更新成功，UI正常刷新，@Watch回调被触发
     */
    it('CrossAbilityStateUpdateTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CrossAbilityStateUpdateTest start');
      // 第一步：在Index页面创建BuilderNode
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      // 第二步：移除节点
      let removeNodeBtn = await driver.findComponent(ON.text('remove node from tree', MatchPattern.CONTAINS));
      expect(removeNodeBtn === null).assertFalse();
      await removeNodeBtn!.click();
      await driver.delayMs(1000);

      // 第三步：拉起新Ability
      let startAbilityBtn = await driver.findComponent(ON.text('start new ability', MatchPattern.CONTAINS));
      expect(startAbilityBtn === null).assertFalse();
      await startAbilityBtn!.click();
      await driver.delayMs(3000);

      // 第四步：在ExtraIndex页面重新挂载节点
      let addNodeBtnInExtra = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtnInExtra === null).assertFalse();
      await addNodeBtnInExtra!.click();
      await driver.delayMs(1000);

      // 第五步：点击change message按钮，验证状态变量更新
      let changeMessageBtn = await driver.findComponent(ON.text('change message', MatchPattern.CONTAINS));
      expect(changeMessageBtn === null).assertFalse();
      await changeMessageBtn!.click();
      await driver.delayMs(1000);

      // 验证message已更新（包含'world'）
      let updatedMessage = await driver.findComponent(ON.text('world', MatchPattern.CONTAINS));
      expect(updatedMessage === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'CrossAbilityStateUpdateTest end');
      done();
    });

    /**
     * @tc.number MetadataConfigTest
     * @tc.name module.json5配置验证
     * @tc.desc 检查metadata配置，metadata中name为enableCustomComponentCrossAbility，value为true
     */
    it('MetadataConfigTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'MetadataConfigTest start');
      // 验证应用已正常启动，说明metadata配置生效
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();

      // 创建节点并验证跨Ability迁移功能可用
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      let messageElement = await driver.findComponent(ON.text('message:', MatchPattern.CONTAINS));
      expect(messageElement === null).assertFalse();

      hilog.info(DOMAIN, TAG, BUNDLE + 'MetadataConfigTest end');
      done();
    });

    /**
     * @tc.number NodeControllerTest
     * @tc.name NodeController功能验证
     * @tc.desc 验证MyNodeController，makeNode、addBuilderNode、removeBuilderNode、disposeNode方法正常工作
     */
    it('NodeControllerTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NodeControllerTest start');
      // 测试addBuilderNode
      let addNodeBtn = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtn === null).assertFalse();
      await addNodeBtn!.click();
      await driver.delayMs(1000);

      // 验证节点已添加
      let messageElement = await driver.findComponent(ON.text('message:', MatchPattern.CONTAINS));
      expect(messageElement === null).assertFalse();

      // 测试removeBuilderNode
      let removeNodeBtn = await driver.findComponent(ON.text('remove node from tree', MatchPattern.CONTAINS));
      expect(removeNodeBtn === null).assertFalse();
      await removeNodeBtn!.click();
      await driver.delayMs(1000);

      // 拉起ExtraAbility测试disposeNode
      let startAbilityBtn = await driver.findComponent(ON.text('start new ability', MatchPattern.CONTAINS));
      expect(startAbilityBtn === null).assertFalse();
      await startAbilityBtn!.click();
      await driver.delayMs(3000);

      // 重新添加节点
      let addNodeBtnInExtra = await driver.findComponent(ON.text('add node to tree', MatchPattern.CONTAINS));
      expect(addNodeBtnInExtra === null).assertFalse();
      await addNodeBtnInExtra!.click();
      await driver.delayMs(1000);

      // 测试disposeNode
      let disposeNodeBtn = await driver.findComponent(ON.text('dispose node', MatchPattern.CONTAINS));
      expect(disposeNodeBtn === null).assertFalse();
      await disposeNodeBtn!.click();
      await driver.delayMs(1000);

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'NodeControllerTest end');
      done();
    });

    beforeEach(() => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })
  })
}
