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
     * 打开应用，点击 Cache_one 按钮
     * 使用 cacheMode 接口配置页面资源的缓存模式
     */
    it('Cache_one', 0, async (done: Function) => {
      console.info('uitest: Cache_one begin');
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

      const button1 = await driver.findComponent(ON.text('Cache_one'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let text1 = await web1.getText();
      expect(text1).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: Cache_one end');
      done();
    });

    /*
     * 点击 Cache_two 按钮
     * 通过 removeCache 接口清除已经缓存的资源
     */
    it('Cache_two', 0, async (done: Function) => {
      console.info('uitest: Cache_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('Cache_two'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let text1 = await web1.getText();
      expect(text1).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: Cache_two end');
      done();
    });

    /*
     * 点击 CookieManagement 按钮
     * 使用 configCookieSync 接口来设置单个Cookie的值
     */
    it('CookieManagement', 0, async (done: Function) => {
      console.info('uitest: CookieManagement begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('CookieManagement'));
      await button1.click();
      await driver.delayMs(1000);

      const button = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let text1 = await web1.getText();
      expect(text1).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: CookieManagement end');
      done();
    });

    /*
     * 点击 DomStorage 按钮
     * 使用 domStorageAccess 接口进行使能配置
     */
    it('DomStorage', 0, async (done: Function) => {
      console.info('uitest: DomStorage begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('DomStorage'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let text1 = await web1.getText();
      expect(text1).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: DomStorage end');
      done();
    });

    /*
     * 点击 UserAgent_one 按钮
     * 通过 getUserAgent 接口获取当前默认用户代理
     */
    it('UserAgent_one', 0, async (done: Function) => {
      console.info('uitest: TestUiExample begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UserAgent_one'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('getUserAgent'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: UserAgent_one end');
      done();
    });

    /*
     * 点击 UserAgent_two 按钮
     * 使用 setCustomUserAgent 接口定制UserAgent
     */
    it('UserAgent_two', 0, async (done: Function) => {
      console.info('uitest: UserAgent_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UserAgent_two'));
      await button1.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: UserAgent_two end');
      done();
    });

    /*
     * 点击 UserAgent_three 按钮
     * 通过 getCustomUserAgent 接口获取自定义用户代理
     */
    it('UserAgent_three', 0, async (done: Function) => {
      console.info('uitest: UserAgent_three begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UserAgent_three'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('getCustomUserAgent'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: UserAgent_three end');
      done();
    });
    
    /*
     * 点击 UseMotionDirSensor 按钮
     * 访问运动和方向传感器，使用运动和方向传感器监测设备状态
     */
    it('UseMotionDirSensor',0, async (done: Function) => {
      console.info('uitest: UseMotionDirSensor begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UseMotionDirSensor'));
      await button1.click();
      await driver.delayMs(2000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index.html');

      const button2 = await driver.findComponent(ON.type('button'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('onConfirm'));
      await button3.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      console.info('uitest: UseMotionDirSensor end');
      done();
    });
  })
}