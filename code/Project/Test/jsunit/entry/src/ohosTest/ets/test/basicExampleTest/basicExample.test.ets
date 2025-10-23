/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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
// [Start basic_sample]
import { describe, it, expect, Level, Size, TestType } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}
export default function abilityTest() {
  describe('ActsAbilityTest', () =>{
  // 测试套名称为ActsAbilityTest
    // 可根据此处设置的用例类型、用例规模、用例级别进行用例筛选
    it('testExample',TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
    // 测试用例名称为testExample
      console.info("unitTest: TestExample begin");
      await sleep(500);
      const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      // 启动被测试Ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      await sleep(500);
      // 获取设备上前台显示的页面并断言检查
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
    })
  })
}
// [End basic_sample]