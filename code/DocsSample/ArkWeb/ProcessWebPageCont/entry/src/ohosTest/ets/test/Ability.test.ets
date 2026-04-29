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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const entryWant: Want = {
  bundleName: bundleName,
  abilityName: 'EntryAbility'
};

async function createDriverOnIndex(): Promise<Driver> {
  await delegator.startAbility(entryWant);
  const driver = Driver.create();
  await driver.delayMs(1000);
  const ability: UIAbility = await delegator.getCurrentTopAbility();
  console.info('get top ability');
  expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
  await driver.delayMs(3000);
  for (let i = 0; i < 5; i++) {
    const indexButton = await driver.findComponent(ON.text('InitiatePrintW3CAPI'));
    if (indexButton !== null) {
      return driver;
    }
    await driver.pressBack();
    await driver.delayMs(1000);
  }
  const indexButton = await driver.findComponent(ON.text('InitiatePrintW3CAPI'));
  expect(indexButton !== null).assertTrue();
  return driver;
}

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
     * 打开应用，点击 InitiatePrintW3CAPI 按钮
     * 触发 window.print 操作对页面内容进行打印
     */
    it('InitiatePrintW3CAPI', 0, async (done: Function) => {
      console.info('uitest: InitiatePrintW3CAPI begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('InitiatePrintW3CAPI'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('button'));
      await button2.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('print.html');

      await driver.pressBack();
      console.info('uitest: InitiatePrintW3CAPI end');
      done();
    });

    /*
     * 点击 InitiatePrintAppAPI 按钮
     * 创建打印适配器，将适配器传入打印的print接口调起打印
     */
    it('InitiatePrintAppAPI', 0, async (done: Function) => {
      console.info('uitest: InitiatePrintAppAPI begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('InitiatePrintAppAPI'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: InitiatePrintAppAPI end');
      done();
    });

    /*
     * 点击 PreviewPDF 按钮
     * 使用Web组件的PDF文档预览能力加载PDF文档
     */
    it('PreviewPDF', 0, async (done: Function) => {
      console.info('uitest: PreviewPDF begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('PreviewPDF'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com/test.pdf');

      await driver.pressBack();
      console.info('uitest: PreviewPDF end');
      done();
    });

    /*
     * 点击 CalcAdjustSafeArea 按钮
     * 进行安全区域计算并避让适配支持异形屏幕设备在沉浸式效果下页面的正常显示
     */
    it('CalcAdjustSafeArea', 0, async (done: Function) => {
      console.info('uitest: CalcAdjustSafeArea begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('CalcAdjustSafeArea'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: CalcAdjustSafeArea end');
      done();
    });

    /*
     * 点击 LoadNetworkPdf 按钮
     * 使用Web组件的PDF文档预览能力加载网络PDF文档
     */
    it('LoadNetworkPdf', 0, async (done: Function) => {
      console.info('uitest: LoadNetworkPdf begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('LoadNetworkPdf'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com/test.pdf');

      await driver.pressBack();
      console.info('uitest: LoadNetworkPdf end');
      done();
    });

    /*
     * 点击 LoadSandboxPdf 按钮
     * 使用Web组件的PDF文档预览能力加载本地应用沙箱内PDF文档
     */
    it('LoadSandboxPdf', 0, async (done: Function) => {
      console.info('uitest: LoadSandboxPdf begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('LoadSandboxPdf'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('test.pdf');

      await driver.pressBack();
      console.info('uitest: LoadSandboxPdf end');
      done();
    });

    /*
     * 点击 LoadRawfilePdf 按钮
     * 使用Web组件的PDF文档预览能力加载本地PDF文档
     */
    it('LoadRawfilePdf', 0, async (done: Function) => {
      console.info('uitest: LoadRawfilePdf begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('LoadRawfilePdf'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('rawfile/test.pdf');

      await driver.pressBack();
      console.info('uitest: LoadRawfilePdf end');
      done();
    });

    /*
     * 点击 PdfEvent 按钮
     * 使用Web组件的PDF文档预览能力加载本地PDF文档并验证PDF事件回调功能
     */
    it('PdfEvent', 0, async (done: Function) => {
      console.info('uitest: PdfEvent begin');
      const driver = await createDriverOnIndex();

      const button1 = await driver.findComponent(ON.text('PdfEvent'));
      await button1.click();
      await driver.delayMs(3000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('rawfile/test.pdf');

      let eventText = await driver.findComponent(ON.type('Text'));
      let message: string = await eventText.getText();
      expect(message).assertContain('PdfLoadEvent:');
      expect(!message.includes('PdfLoadEvent:pending')).assertTrue();

      const bounds = await web1.getBounds();
      const centerX = Math.trunc((bounds.left + bounds.right) / 2);
      const startY = Math.trunc(bounds.bottom - 80);
      const endY = Math.trunc(bounds.top + 80);

      for (let i = 0; i < 8; i++) {
        await driver.swipe(centerX, startY, centerX, endY, 1200);
        await driver.delayMs(1000);
        eventText = await driver.findComponent(ON.type('Text'));
        message = await eventText.getText();
        if (!message.includes('PdfScrollAtBottomEvent:pending')) {
          break;
        }
      }
      expect(!message.includes('PdfScrollAtBottomEvent:pending')).assertTrue();

      await driver.pressBack();
      console.info('uitest: PdfEvent end');
      done();
    });
  })
}
