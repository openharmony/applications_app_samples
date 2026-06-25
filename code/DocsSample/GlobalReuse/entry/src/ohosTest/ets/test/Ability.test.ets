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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, On, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import router from '@ohos.router';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const TAG = '[Sample_GlobalReuse]'
const DOMAIN = 0xF811
const BUNDLE = 'GlobalReuse'

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function abilityTest() {

  describe('GlobalReuseTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name globalReuseDefault
     * @tc.desc 测试默认全局复用池场景
     * @tc.level: Level 1
     */
    it('globalReuseDefault', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReuseDefault begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReuseDefault' });
      await driver.delayMs(1000);
      // 查找并点击切换按钮
      let btn = await driver.findComponent(ON.text('Switch components'));
      await btn.click();
      await driver.delayMs(500);
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_002
     * @tc.name globalReusePool
     * @tc.desc 测试全局复用池配置场景
     * @tc.level: Level 1
     */
    it('globalReusePool', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePool begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePool' });
      await driver.delayMs(1000);
      // 查找并点击切换按钮
      let btn = await driver.findComponent(ON.text('Switch components'));
      await btn.click();
      await driver.delayMs(500);
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_003
     * @tc.name globalReusePoolGet
     * @tc.desc 测试全局复用池信息获取场景
     * @tc.level: Level 1
     */
    it('globalReusePoolGet', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePoolGet begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePoolGet' });
      await driver.delayMs(1000);
      // 点击切换组件按钮
      let switchBtn = await driver.findComponent(ON.text('切换组件'));
      await switchBtn.click();
      await driver.delayMs(500);
      // 点击检查GlobalChild按钮
      let checkGlobalBtn = await driver.findComponent(ON.text('检查GlobalChild'));
      await checkGlobalBtn.click();
      await driver.delayMs(500);
      // 点击检查LegacyComp按钮
      let checkLegacyBtn = await driver.findComponent(ON.text('检查LegacyComp'));
      await checkLegacyBtn.click();
      await driver.delayMs(500);
      // 点击设置复用池大小按钮
      let setPoolBtn = await driver.findComponent(ON.text('设置复用池大小'));
      await setPoolBtn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_004
     * @tc.name globalReusePoolMultiLevel
     * @tc.desc 测试多级全局复用池场景
     * @tc.level: Level 1
     */
    it('globalReusePoolMultiLevel', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePoolMultiLevel begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePoolMultiLevel' });
      await driver.delayMs(1000);
      // 点击切换ParentA按钮
      let parentBtn = await driver.findComponent(ON.text('切换 ParentA'));
      await parentBtn.click();
      await driver.delayMs(500);
      await parentBtn.click();
      await driver.delayMs(500);
      // 点击切换ChildA按钮
      let childBtn = await driver.findComponent(ON.text('切换 ChildA'));
      await childBtn.click();
      await driver.delayMs(500);
      await childBtn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_005
     * @tc.name globalReusePoolPerInstance
     * @tc.desc 测试perInstance所有权模式场景
     * @tc.level: Level 1
     */
    it('globalReusePoolPerInstance', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePoolPerInstance begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePoolPerInstance' });
      await driver.delayMs(1000);
      // 点击切换组件按钮
      let switchBtn = await driver.findComponent(ON.text('切换组件'));
      await switchBtn.click();
      await driver.delayMs(500);
      await switchBtn.click();
      await driver.delayMs(500);
      // 点击增加按钮
      let addBtn = await driver.findComponent(ON.text('增加 +10'));
      await addBtn.click();
      await driver.delayMs(500);
      await addBtn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_006
     * @tc.name globalReusePoolPrerender
     * @tc.desc 测试预渲染场景
     * @tc.level: Level 1
     */
    it('globalReusePoolPrerender', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePoolPrerender begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePoolPrerender' });
      await driver.delayMs(1000);
      // 点击Switch按钮
      let switchBtn = await driver.findComponent(ON.text('Switch'));
      await switchBtn.click();
      await driver.delayMs(500);
      await switchBtn.click();
      await driver.delayMs(500);
      // 点击Check pool按钮
      let checkBtn = await driver.findComponent(ON.text('Check pool'));
      await checkBtn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_007
     * @tc.name globalReusePoolReuseID
     * @tc.desc 测试reuseId配置场景
     * @tc.level: Level 1
     */
    it('globalReusePoolReuseID', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePoolReuseID begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePoolReuseID' });
      await driver.delayMs(1000);
      // 点击切换A按钮
      let btnA = await driver.findComponent(ON.text('切换A'));
      await btnA.click();
      await driver.delayMs(500);
      // 点击切换B按钮
      let btnB = await driver.findComponent(ON.text('切换B'));
      await btnB.click();
      await driver.delayMs(500);
      // 点击切换C按钮
      let btnC = await driver.findComponent(ON.text('切换C'));
      await btnC.click();
      await driver.delayMs(500);
      // 点击仅清除B按钮
      let purgeBtn = await driver.findComponent(ON.text('仅清除B'));
      await purgeBtn.click();
      await driver.delayMs(500);
      // 点击打印复用池信息按钮
      let printBtn = await driver.findComponent(ON.text('打印复用池信息'));
      await printBtn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_008
     * @tc.name globalReusePoolShared
     * @tc.desc 测试shared共享池场景
     * @tc.level: Level 1
     */
    it('globalReusePoolShared', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: globalReusePoolShared begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/GlobalReusePoolShared' });
      await driver.delayMs(1000);
      // 点击删除Comp1按钮
      let delBtn1 = await driver.findComponent(ON.text('删除Comp1'));
      await delBtn1.click();
      await driver.delayMs(500);
      // 点击添加Comp1按钮
      let addBtn1 = await driver.findComponent(ON.text('添加Comp1'));
      await addBtn1.click();
      await driver.delayMs(500);
      // 点击删除Comp2按钮
      let delBtn2 = await driver.findComponent(ON.text('删除Comp2'));
      await delBtn2.click();
      await driver.delayMs(500);
      // 点击添加Comp2按钮
      let addBtn2 = await driver.findComponent(ON.text('添加Comp2'));
      await addBtn2.click();
      await driver.delayMs(500);
      // 点击删除Comp3按钮
      let delBtn3 = await driver.findComponent(ON.text('删除Comp3'));
      await delBtn3.click();
      await driver.delayMs(500);
      // 点击添加Comp3按钮
      let addBtn3 = await driver.findComponent(ON.text('添加Comp3'));
      await addBtn3.click();
      await driver.delayMs(1000);
      done();
    });
  })
}