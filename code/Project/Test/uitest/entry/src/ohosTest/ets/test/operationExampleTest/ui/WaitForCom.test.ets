/**
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

 // [Start waitForComp_sample]
  import { describe, it, Level, TestType, Size } from '@ohos/hypium';
  // 导入测试依赖kit
  import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';

  const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
  // 指定被测应用包名、ability名，请开发者替换为被测应用包名和ability名
  const bundleName: string = 'com.uitestScene.acts';
  const abilityName: string = 'com.uitestScene.acts.MainAbility';
  export default function abilityTest() {
    describe('waitForComp_sample', () => {
      it('testWaitForComponent_static', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async (done: Function): Promise<void> => {
        let driver = Driver.create();
        // 拉起目标应用      
        await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`).then(result => {
        }).catch((err: Error) => {
            done();
        })
        // 通过等待目标应用首页上的指定控件出现，判断应用拉起完成
        let button = await driver.waitForComponent(ON.text('StartAbility Success!'), 1000);
      })
    })
  }
// [End waitForComp_sample]