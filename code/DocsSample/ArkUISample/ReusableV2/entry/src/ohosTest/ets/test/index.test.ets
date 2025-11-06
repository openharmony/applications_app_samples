/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern} from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function IndexTest(){
  describe('IndexTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(2000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + "get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number :Index_Start_0100
     * @tc.name  :Index_Start_0100
     * @tc.desc  :测试打开应用
     * @tc.level :level10
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */

    it("Index_Start_0100", 0, async (done: Function) => {
      try {
        const want: Want = {
          bundleName: bundleName,
          abilityName: 'com.example.reusablev2'
        };

        // 启动 IndexAbility
        await delegator.startAbility(want);
        await sleep(2000);

        const ability: UIAbility = await delegator.getCurrentTopAbility();
        expect(ability.context.abilityInfo.name).assertEqual('IndexAbility');

        done();
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + "Index test failed:", error);
        done();
      }
    });

    /**
     * @tc.number :testS@ReusableV21_0101
     * @tc.name  :testS@ReusableV21_0101
     * @tc.desc  :测试打开接口说明页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0101', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ExamplePage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number :testS@ReusableV21_0104
     * @tc.name  :testS@ReusableV21_0104
     * @tc.desc  :测试打开复用阶段的冻结页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0104', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('AboutToRecyclePage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);

      // // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('step1. appear', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('step2. recycle', MatchPattern.CONTAINS));
      expect(subItem2 === null).assertFalse();

      let subItem3 = await driver.findComponent(ON.text('step3. reuse', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      let subItem4 = await driver.findComponent(ON.text('step4. disappear', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);

      await subItem2.click();
      await driver.delayMs(1000);

      await subItem3.click();
      await driver.delayMs(1000);

      await subItem4.click();
      await driver.delayMs(1000);


      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0105
     * @tc.name  :testS@ReusableV21_0105
     * @tc.desc  :测试打开复用前的组件内状态变量重置页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0105', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ConditionPage', MatchPattern.CONTAINS));
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0106
     * @tc.name  :testS@ReusableV21_0106
     * @tc.desc  :测试打开复用前的组件内状态变量重置优化页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0106', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ComputedPage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('回收/复用', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0107
     * @tc.name  :testS@ReusableV21_0107
     * @tc.desc  :测试打开在if组件中使用页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0107', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('IMonitorValuePage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      // // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('回收/复用', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0108
     * @tc.name  :testS@ReusableV21_0108
     * @tc.desc  :测试打开在Repeat组件中使用页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0108', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ComponentIfPage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      // // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('回收/复用', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0109
     * @tc.name  :testS@ReusableV21_0109
     * @tc.desc  :测试打开在Repeat组件非懒加载场景的each属性中使用页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0109', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('RepeatPage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      // // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('改变condition', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0110
     * @tc.name  :testS@ReusableV21_0110
     * @tc.desc  :测试打开在ForEach组件中使用页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0110', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ComponentEachPage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      let subItem = await driver.findComponent(ON.text('删除/创建Repeat', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('增加元素', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem3 = await driver.findComponent(ON.text('删除元素', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem4 = await driver.findComponent(ON.text('更改元素', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);

      await subItem2.click();
      await driver.delayMs(1000);

      await subItem3.click();
      await driver.delayMs(1000);

      await subItem4.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      done();
    });

    /**
     * @tc.number :testS@ReusableV21_0112
     * @tc.name  :testS@ReusableV21_0112
     * @tc.desc  :测试打开在ForEach组件中使用页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0112', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ComponentForEachPage', MatchPattern.CONTAINS));

      await button_list.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testS@ReusableV21_0113
     * @tc.name  :testS@ReusableV21_0113
     * @tc.desc  :测试打开测试打开在LazyForEach组件中使用页面
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testS_ReusableV21_0113', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('LazyForEachPage', MatchPattern.CONTAINS));
      
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
  })
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
