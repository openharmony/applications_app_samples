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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
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
      let sampleButton = await driver.findComponent(ON.text('Page 1 Page 2 Jump', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      sampleButton = await driver.findComponent(ON.text('From first Page', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      sampleButton = await driver.findComponent(ON.text('go to next page'));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
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
      let sampleButton = await driver.findComponent(ON.text('Page 2 Go back to the previous page', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
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
      let sampleButton = await driver.findComponent(ON.text('TabContent creation', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
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
      let sampleButton = await driver.findComponent(ON.text('Freeze custom components cached in LazyForEach', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number :testStestSmakeObserved1_0105
     * @tc.name  :testStestSmakeObserved1_0105
     * @tc.desc  :测试打开collections.Map可以触发UI刷新的API有:set、clear、delete。
     * @tc.level :level1
     * @tc.size  : MediumTest
     *  @tc.type : Function
     */
    it('testStestSmakeObserved1_0105', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('NavigationContentMsStack will be set to inactive state', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    it('testStestSmakeObserved1_0106', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('Mixed scenario of component reuse, if, and component freezing', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    it('testStestSmakeObserved1_0107', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('LazyForEach、 Mixed scenario of component reuse and component freezing', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    it('testStestSmakeObserved1_0108', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('LazyForEach、if、 Mixed scenario of component reuse and component freezing', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    it('testStestSmakeObserved1_0109', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('Mixing Navigation and TabContent', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    it('testStestSmakeObserved1_0110', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('Page and LazyForEach', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });

    it('testStestSmakeObserved1_0111', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.text('Constraints', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
  })
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}