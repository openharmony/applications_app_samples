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

import { beforeAll, describe, expect, it, Level, TestType, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import router from '@ohos.router';


const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;


export default function WithEnvTest() {
  describe('WithEnvTest', () => {
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
     * @tc.number     : FontScale_001
     * @tc.name       : testFontScale
     * @tc.desc       : 测试局部字体缩放
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFontScale', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/FontScale' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : LayoutDirection_002
     * @tc.name       : testLayoutDirection
     * @tc.desc       : 测试局部布局方向
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testLayoutDirection', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/LayoutDirection' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CustomEnv_003
     * @tc.name       : testCustomEnv
     * @tc.desc       : 测试自定义环境变量
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCustomEnv', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/CustomEnv' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : NestedScopes_004
     * @tc.name       : testNestedScopes
     * @tc.desc       : 测试嵌套作用域
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testNestedScopes', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/specifications/NestedScopes', })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}
