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
     * 打开应用，点击 LoadingWebPages 按钮
     * 在默认页面加载完成后，调用 loadUrl 接口加载指定的网页
     */
    it('LoadingWebPages', 0, async (done: Function) => {
      console.info('uitest: LoadingWebPages begin');
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
      await driver.delayMs(4000);

      const button1 = await driver.findComponent(ON.text('LoadingWebPages'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: LoadingWebPages end');
      done();
    });

    /*
     * 打开应用，点击 LoadingLocalPages 按钮
     * 默认页面加载完成后可通过调用 loadUrl 接口变更当前Web组件的页面
     */
    it('LoadingLocalPages', 0, async (done: Function) => {
      console.info('uitest: LoadingLocalPages begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('LoadingLocalPages'));
      await button1.click();
      await driver.delayMs(1000);

      const button = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('local.html');

      await driver.pressBack();
      console.info('uitest: LoadingLocalPages end');
      done();
    });

    /*
     * 打开应用，点击 LoadingHTMLRichTextData 按钮
     * 通过 loadData 接口实现加载HTML格式的文本数据
     */
    it('LoadingHTMLRichTextData', 0, async (done: Function) => {
      console.info('uitest: LoadingHTMLRichTextData begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('LoadingHTMLRichTextData'));
      await button1.click();
      await driver.delayMs(1000);

      const button = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(1000);

      const web = await driver.findComponent(ON.type('Web'));
      let src: string = await web.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: LoadingHTMLRichTextData end');
      done();
    });

    /*
     * 打开应用，点击 LoadLocalPageFileInSandboxPath_one 按钮
     * 加载沙箱路径下的本地页面文件，需要开启应用中文件系统的访问fileAccess权限
     */
    it('LoadLocalPageFileInSandboxPath_one', 0, async (done: Function) => {
      console.info('uitest: LoadLocalPageFileInSandboxPath_one begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('LoadLocalPageFileInSandboxPath_one'));
      await button1.click();
      await driver.delayMs(1000);

      const type1 = await driver.findComponent(ON.type('Text'));
      let text1: string = await type1.getText();
      expect(text1).assertContain('loading success');

      await driver.pressBack();
      console.info('uitest: LoadLocalPageFileInSandboxPath_one end');
      done();
    });

    /*
     * 打开应用，点击 LoadLocalPageFileInSandboxPath_two 按钮
     * 通过data url方式直接加载HTML字符串
     */
    it('LoadLocalPageFileInSandboxPath_two', 0, async (done: Function) => {
      console.info('uitest: LoadLocalPageFileInSandboxPath_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('LoadLocalPageFileInSandboxPath_two'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('Source:');

      await driver.pressBack();
      console.info('uitest: LoadLocalPageFileInSandboxPath_two end');
      done();
    });
  })
}