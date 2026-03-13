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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON} from '@ohos.UiTest'
import {abilityDelegatorRegistry} from '@kit.TestKit'
import { UIAbility, Want } from '@kit.AbilityKit';

const DELAY_LONG = 1000;
const DELAY_SHORT = 400;

const delegate = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
     it('NavigationQuery_001', 0, async (done: Function) => {
       console.log("NavigationQuery_001 start");
       const want: Want = {
         bundleName: bundleName,
         abilityName: "EntryAbility"
       };
       await delegate.startAbility(want);
       let driver = Driver.create();
       await driver.delayMs(DELAY_LONG);

       // check top display ability
       const ability: UIAbility = await delegate.getCurrentTopAbility();
       expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
       done();
       console.log("NavigationQuery_001 end");
     });

     it('NavigationQuery_002', 0, async (done: Function) => {
       let driver = Driver.create();
       let routerInfo = await driver.findComponent(ON.id('QueryRouter'));

       await routerInfo.click();
       await driver.delayMs(DELAY_LONG);

       // 获取页面跳转参数
       let pageInfo = await driver.findComponent(ON.text('getRouterName'));
       await pageInfo.click();
       // 校验获取页面跳转参数
       await driver.assertComponentExist(ON.text('pageName: pages/Index'));
       await driver.pressBack()
       done();
     });
  });
}