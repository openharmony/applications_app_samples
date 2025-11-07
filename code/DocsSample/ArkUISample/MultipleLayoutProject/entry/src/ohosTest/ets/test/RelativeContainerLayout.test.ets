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

import { beforeAll, describe, expect, it, Level, TestType, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';


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

export default function RelativeContainerLayout() {
  describe('RelativeContainerLayout', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /*
     * @tc.number     : RelativeContainerParentComponentId_001
     * @tc.name       : testRelativeContainerParentComponentId
     * @tc.desc       : 测试RelativeContainer布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerParentComponentId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerParentComponentId'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : RelativeContainerSiblingComponentId_002
     * @tc.name       : testRelativeContainerSiblingComponentId
     * @tc.desc       : 测试RelativeContainer布局,锚点对齐位置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerSiblingComponentId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerSiblingComponentId'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : RelativeContainerChildComponentId_003
     * @tc.name       : testRelativeContainerChildComponentId
     * @tc.desc       : 测试RelativeContainer布局,锚点对齐位置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerChildComponentId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerChildComponentId'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : RelativeContainerChildComponentOffset_004
     * @tc.name       : testRelativeContainerChildComponentOffset
     * @tc.desc       : 测试RelativeContainer布局,子组件位置偏移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerChildComponentOffset', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerChildComponentOffset'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : RelativeContainerDifferentComponentId_005
     * @tc.name       : testRelativeContainerDifferentComponentId
     * @tc.desc       : 测试RelativeContainer布局,多种组件对齐布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerDifferentComponentId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerDifferentComponentId'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : RelativeContainerComponentSize_006
     * @tc.name       : testRelativeContainerComponentSize
     * @tc.desc       : 测试RelativeContainer布局,组件尺寸
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerComponentSize', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerComponentSize'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : RelativeContainerMultipleComponentsChainMode_007
     * @tc.name       : testRelativeContainerMultipleComponentsChainMode
     * @tc.desc       : 测试RelativeContainer布局,多个组件形成链
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerMultipleComponentsChainMode', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerMultipleComponentsChainMode'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : RelativeContainerComponentGuideLine_008
     * @tc.name       : testRelativeContainerComponentGuideLine
     * @tc.desc       : 测试RelativeContainer布局,多个组件形成链
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerComponentGuideLine', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerComponentGuideLine'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : RelativeContainerComponentBarrier_009
     * @tc.name       : testRelativeContainerComponentBarrier
     * @tc.desc       : 测试RelativeContainer布局,多个组件形成链
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRelativeContainerComponentBarrier', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();

        const title = await driver.findComponent(ON.text('RelativeContainerComponentBarrier'));
        expect(title === null).assertFalse();
        await title.click();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

  });
}