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
import { abilityDelegatorRegistry, Driver, ON,MatchPattern} from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
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
      console.info("get top ability");
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

    it("Index_Start", 0, async (done: Function) => {
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
        console.error("Index test failed:", error);
        done();
      }
    });

    /**
     * @tc.number :testStestSmakeObserved1_0101
     * @tc.name  :testStestSmakeObserved1_0101
     * @tc.desc  :测试打开UI不会刷新，因为State只能观察到第一层的变化
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0101', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page1', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0102
     * @tc.name  :testStestSmakeObserved1_0102
     * @tc.desc  :测试打开makeObserved仅对入参生效，不会改变接受返回值的观察能力
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0102', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page2', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('change id', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('change Info', MatchPattern.CONTAINS));
      expect(subItem2 === null).assertFalse();

      let subItem3 = await driver.findComponent(ON.text('change Info1', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);

      await subItem2.click();
      await driver.delayMs(1000);

      await subItem3.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      done();
    });

    /**
     * @tc.number :testStestSmakeObserved1_0103
     * @tc.name  :testStestSmakeObserved1_0103
     * @tc.desc  :测试打开makeObserved和@Sendable装饰的class配合使用
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */

    it('testStestSmakeObserved1_0103', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page3', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('change name', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('task', MatchPattern.CONTAINS));
      expect(subItem2 === null).assertFalse();

      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);

      await subItem2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0104
     * @tc.name  :testStestSmakeObserved1_0104
     * @tc.desc  :测试打开makeObserved和collections.Array/Set/Map配合使用
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0104', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page4', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);

      // // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('push', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('pop', MatchPattern.CONTAINS));
      expect(subItem2 === null).assertFalse();

      let subItem3 = await driver.findComponent(ON.text('unshift', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      let subItem4 = await driver.findComponent(ON.text('splice', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      let subItem5 = await driver.findComponent(ON.text('shrinkTo', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      let subItem6 = await driver.findComponent(ON.text('extendTo', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      let subItem7 = await driver.findComponent(ON.text('sort', MatchPattern.CONTAINS));
      expect(subItem3 === null).assertFalse();

      let subItem8 = await driver.findComponent(ON.text('fill', MatchPattern.CONTAINS));
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

      await subItem5.click();
      await driver.delayMs(1000);

      await subItem6.click();
      await driver.delayMs(1000);

      await subItem7.click();
      await driver.delayMs(1000);

      await subItem8.click();
      await driver.delayMs(1000);



      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0105
     * @tc.name  :testStestSmakeObserved1_0105
     * @tc.desc  :测试打开collections.Map可以触发UI刷新的API有：set、clear、delete。
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0105', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page5', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('set c', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('delete c', MatchPattern.CONTAINS));
      expect(subItem2 === null).assertFalse();

      let subItem3 = await driver.findComponent(ON.text('clear', MatchPattern.CONTAINS));
      expect(subItem2 === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await subItem2.click();
      await driver.delayMs(1000);
      await subItem3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0106
     * @tc.name  :testStestSmakeObserved1_0106
     * @tc.desc  :测试打开collections.Set可以触发UI刷新的API有：add、clear、delete。
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0106', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page6', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.text('add', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.text('delete', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem3 = await driver.findComponent(ON.text('clear', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await subItem2.click();
      await driver.delayMs(1000);
      await subItem3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0107
     * @tc.name  :testStestSmakeObserved1_0107
     * @tc.desc  :测试打开makeObserved的入参为JSON.parse的返回值
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0107', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page7', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.id('textId1', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      let subItem2 = await driver.findComponent(ON.id('textId2', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await subItem2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0108
     * @tc.name  :testStestSmakeObserved1_0108
     * @tc.desc  :测试打开makeObserved和V2装饰器配合使用
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0108', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page8', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.id('textIdMessage', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      let subItem2 = await driver.findComponent(ON.id('textAgeMessageAge', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      let subItem3 = await driver.findComponent(ON.id('buttonChangeInfo', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await subItem2.click();
      await driver.delayMs(1000);
      await subItem3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0109
     * @tc.name  :testStestSmakeObserved1_0109
     * @tc.desc  :测试打开makeObserved在@Component内使用
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0109', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page9', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.id('textNumber', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /**
     * @tc.number :testStestSmakeObserved1_0110
     * @tc.name  :testStestSmakeObserved1_0110
     * @tc.desc  :测试打开getTarget后的数据可以正常赋值，但是无法触发UI刷新
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0110', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('page10', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      // 分别查找并断言每个子项的存在性
      let subItem = await driver.findComponent(ON.id('textobservedObj1', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();

      let subItem2 = await driver.findComponent(ON.id('textobservedObj2', MatchPattern.CONTAINS));
      expect(subItem === null).assertFalse();
      // 点击每个子项
      await subItem.click();
      await driver.delayMs(1000);
      await subItem2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      done();
    });
  })
}



function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
