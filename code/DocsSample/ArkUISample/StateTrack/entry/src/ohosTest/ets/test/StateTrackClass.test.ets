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
import router from '@ohos.router';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function StateTrack() {
  describe('StateTrack', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /*
     * @tc.number     : StateTrackClass_001
     * @tc.name       : testStateTrackClass
     * @tc.desc       : 测试@State等装饰器默认支持观察第一层属性的变化，第一层属性的变化虽然可以触发更新，但无法做到类属性级的观察
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateTrackClass', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/stateTrack/StateTrackClass' })
        await driver.delayMs(2000);
        const text = await driver.findComponent(ON.text('change name'));
        await text.click();
        await driver.delayMs(2000);
        const text2 = await driver.findComponent(ON.text('change age'));
        await text2.click();
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : StateTrackClass2_001
     * @tc.name       : testStateTrackClass2
     * @tc.desc       : 测试使用@Track装饰器可以避免冗余刷新。
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateTrackClass2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/stateTrack/StateTrackClass2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : StateTrackClass3_001
     * @tc.name       : testStateTrackClass3
     * @tc.desc       : 测试@Track和自定义组件更新
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateTrackClass3', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/stateTrack/StateTrackClass3' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}