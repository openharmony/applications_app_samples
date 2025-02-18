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
     * 打开应用，点击 UploadFiles 按钮
     * 处理前端页面文件上传的请求
     */
    it('UploadFiles', 0, async (done: Function) => {
      console.info('uitest: UploadFiles begin');
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
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UploadFiles'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.clickable(true).enabled(true));
      await button2.click();
      await driver.delayMs(3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('local.html');

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: UploadFiles end');
      done();
    });

    /*
     * 点击 ListenForPageDown 按钮
     * 使用Web组件监听页面触发的下载
     */
    it('ListenForPageDown', 0, async (done: Function) => {
      console.info('uitest: ListenForPageDown begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ListenForPageDown'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('setDownloadDelegate'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Download'));
      await button3.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index.html');

      const type1 = await driver.findComponent(ON.type('Text'));
      let text1: string = await type1.getText();
      expect(text1).assertEqual('download finish');

      await driver.pressBack();
      console.info('uitest: ListenForPageDown end');
      done();
    });

    /*
     * 点击 InitiatingADownloadTask 按钮
     * 使用Web组件的下载能力
     */
    it('InitiatingADownloadTask',0, async (done: Function) => {
      console.info('uitest: InitiatingADownloadTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('InitiatingADownloadTask'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('setDownloadDelegate'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('startDownload'));
      await button3.click();
      await driver.delayMs(4000);

      const type1 = await driver.findComponent(ON.type('Text'));
      let text1: string = await type1.getText();
      expect(text1).assertEqual('download finish');

      await driver.pressBack();
      console.info('uitest: InitiatingADownloadTask end');
      done();
    });

    /*
     * 点击 ResumeDownload 按钮
     * 发起一个下载，Web组件发起的下载会根据当前显示的url以及Web组件默认的Referrer Policy来计算referrer
     */
    it('ResumeDownload',0, async (done: Function) => {
      console.info('uitest: ResumeDownload begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ResumeDownload'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('setDownloadDelegate'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('startDownload'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('record'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.text('recovery'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: ResumeDownload end');
      done();
    });
  })
}