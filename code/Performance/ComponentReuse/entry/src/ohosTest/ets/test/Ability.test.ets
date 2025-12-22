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

import hilog from '@ohos.hilog';
import { beforeAll, describe, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, Component } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const SAMPLE: string = 'ComponentReuse';
const TAG: string = 'ComponentReuse_Test';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      const want: Want = {
        bundleName: 'com.example.componentreuse',
        abilityName: 'EntryAbility'
      }

      abilityDelegator.startAbility(want, (err) => {
        if (err) {
          hilog.error(0xFF00, TAG, '%{public}s', `error: ${JSON.stringify(err)}`);
        } else {
          hilog.info(0xFF00, TAG, '%{public}s', 'success start ability');
        }
      });
      await driver.delayMs(1000);

      done();
    })

    const driver = Driver.create();

    /**
     * 点击首页，进入各场景页面，列表可正常滑动
     */
    it(SAMPLE + '进入子页面查看列表功能', 0, async (done: Function) => {
      await runPageTest(driver, '减少组件复用的嵌套层级');
      await runPageTest(driver, '减少组件复用的嵌套层级 - 反例');
      await runPageTest(driver, '使用AttributeUpdater精准控制组件属性的刷新');
      await runPageTest(driver, '使用AttributeUpdater精准控制组件属性的刷新 - 反例');
      await runPageTest(driver, '使用@Link/@ObjectLink替代@Prop减少深拷贝 - 反例');
      await runPageTest(driver, '避免状态变量在aboutToReuse方法中再进行更新 - 反例');
      await runPageTest(driver, '使用reuseId标记不同结构的组件');
      await runPageTest(driver, '使用reuseId标记不同结构的组件 - 反例');
      await runPageTest(driver, '避免使用函数/方法作为复用组件创建时的入参');
      await runPageTest(driver, '避免使用函数/方法作为复用组件创建时的入参 - 反例');
      done();
    })

  })
}

// 运行页面测试
async function runPageTest(driver: Driver, componentText: string) {
  const button: Component = await driver.findComponent(ON.text(componentText));
  await button.click();
  await driver.delayMs(1000);
  await driver.swipe(100, 1000, 100, 100);
  await driver.delayMs(2000);
  await driver.pressBack();
  await driver.delayMs(1000);
}