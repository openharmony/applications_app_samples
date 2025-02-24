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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /*
     * 打开应用，点击 OnInterceptRequest_one 按钮
     * 应用层构造本地资源响应消息发送给Web内核
     * Web内核解析应用层响应信息，根据此响应信息进行页面资源加载
     */
    it('OnInterceptRequest_one',0, async (done: Function) => {
      console.info('uitest: OnInterceptRequest_one begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('OnInterceptRequest_one'));
      await button1.click();
      await driver.delayMs(1000);

      const clickText = await driver.findComponent(ON.clickable(true).enabled(true));
      await clickText.click();
      await driver.delayMs(1000);

      const web = await driver.findComponent(ON.type('Web'));
      let src: string = await web.getText();
      expect(src).assertContain('index1.html');

      await driver.pressBack();
      console.info('uitest: OnInterceptRequest_one end');
      done();
    });

    /*
     * 点击 OnInterceptRequest_two 按钮
     * Web组件通过拦截页面请求，应用侧代码构建响应资源
     * 在响应头中添加“ResponseDataID”字段，开启生成CodeCache的功能
     */
    it('OnInterceptRequest_two',0, async (done: Function) => {
      console.info('uitest: OnInterceptRequest_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('OnInterceptRequest_two'));
      await button1.click();
      await driver.delayMs(1000);

      const clickText = await driver.findComponent(ON.clickable(true).enabled(true));
      await clickText.click();
      await driver.delayMs(1000);

      const web = await driver.findComponent(ON.type('Web'));
      let src: string = await web.getText();
      expect(src).assertContain('index2.html');

      console.info('uitest: OnInterceptRequest_two end');
      done();
    });
  })
}