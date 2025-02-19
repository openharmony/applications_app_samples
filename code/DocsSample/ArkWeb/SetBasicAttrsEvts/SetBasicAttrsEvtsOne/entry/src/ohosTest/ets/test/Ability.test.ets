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

function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

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
     * 打开应用，点击 AllowGeolocation 按钮
     * 开启Web组件的隐私模式
     * 设置隐私模式下的Web组件允许指定来源使用地理位置
     */
    it('AllowGeolocation', 0, async (done: Function) => {
      console.info('uitest: AllowGeolocation begin');
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

      const button1 = await driver.findComponent(ON.text('AllowGeolocation'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: AllowGeolocation end');
      done();
    });
    
    /*
     * 点击 ClearAllCookiesSync 按钮
     * 开启Web组件的隐私模式
     * 通过 clearAllCookiesSync 清除隐私模式下所有cookie
     */
    it('ClearAllCookiesSync', 0, async (done: Function) => {
      console.info('uitest: ClearAllCookiesSync begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ClearAllCookiesSync'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: ClearAllCookiesSync end');
      done();
    });
    
    /*
     * 点击 ConfigCookieSync 按钮
     * 开启Web组件的隐私模式
     * 通过 configCookieSync 设置隐私模式下指定url的单个cookie的值
     */
    it('ConfigCookieSync', 0, async (done: Function) => {
      console.info('uitest: ConfigCookieSync begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ConfigCookieSync'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: ConfigCookieSync end');
      done();
    });
    
    /*
     * 点击 DeleteAllData 按钮
     * 开启Web组件的隐私模式
     * 通过 deleteAllData 清除隐私模式下Web SQL当前使用的所有存储
     */
    it('DeleteAllData', 0, async (done: Function) => {
      console.info('uitest: DeleteAllData begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('DeleteAllData'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index.html');

      await driver.pressBack();
      console.info('uitest: DeleteAllData end');
      done();
    });
    
    /*
     * 点击 DeleteGeolocation 按钮
     * 开启Web组件的隐私模式
     * 通过 deleteGeolocation 清除隐私模式下指定来源的地理位置权限状态
     */
    it('DeleteGeolocation', 0, async (done: Function) => {
      console.info('uitest: DeleteGeolocation begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('DeleteGeolocation'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: DeleteGeolocation end');
      done();
    });
    
    /*
     * 点击 ExistCookie 按钮
     * 开启Web组件的隐私模式
     * 通过 existCookie 查询隐私模式下是否存在cookie
     */
    it('ExistCookie', 0, async (done: Function) => {
      console.info('uitest: ExistCookie begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ExistCookie'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: ExistCookie end');
      done();
    });
    
    /*
     * 点击 FetchCookieSync 按钮
     * 开启Web组件的隐私模式
     * 通过 fetchCookieSync 获取隐私模式下指定url对应cookie的值
     */
    it('FetchCookieSync', 0, async (done: Function) => {
      console.info('uitest: FetchCookieSync begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('FetchCookieSync'));
      await button1.click();
      await driver.delayMs(1000);

      const web = await driver.findComponent(ON.type('Web'));
      let src: string = await web.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: FetchCookieSync end');
      done();
    });
    
    /*
     * 点击 GetAccessibleGeolocation 按钮
     * 开启Web组件的隐私模式
     * 通过 getAccessibleGeolocation 以回调方式异步获取隐私模式下指定源的地理位置权限状态
     */
    it('GetAccessibleGeolocation', 0, async (done: Function) => {
      console.info('uitest: GetAccessibleGeolocation begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('GetAccessibleGeolocation'));
      await button1.click();
      await driver.delayMs(1000);

      const web = await driver.findComponent(ON.type('Web'));
      let src: string = await web.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: GetAccessibleGeolocation end');
      done();
    });
    
    /*
     * 点击 IncognitoMode_one 按钮
     * 开启Web组件的隐私模式
     * 浏览网页时的Cookie、 Cache Data等数据不会保存在本地的持久化文件，数据将不被记录下来
     */
    it('IncognitoMode_one', 0, async (done: Function) => {
      console.info('uitest: IncognitoMode_one begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('IncognitoMode_one'));
      await button1.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: IncognitoMode_one end');
      done();
    });
    
    /*
     * 点击 IncognitoMode_two 按钮
     * 开启Web组件的隐私模式
     * 通过isIncogntoMode判断当前Web组件是否是隐私模式
     */
    it('IncognitoMode_two', 0, async (done: Function) => {
      console.info('uitest: IncognitoMode_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('IncognitoMode_two'));
      await button1.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: IncognitoMode_two end');
      done();
    });
    
    /*
     * 点击 OpenPageNewWin 按钮
     * 通过 multiWindowAccess 接口来设置是否允许网页在新窗口打开
     * 
     */
    it('OpenPageNewWin', 0, async (done: Function) => {
      console.info('uitest: OpenPageNewWin begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('OpenPageNewWin'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('button'));
      await button2.click();
      await driver.delayMs(2000);

      const dialog = JSON.stringify(getInspectorTree());
      expect(dialog).assertContain('Dialog');

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: OpenPageNewWin end');
      done();
    });
    
    /*
     * 点击 ManageLocPerms 按钮
     * 通过 onGeolocationShow 接口对网站进行位置权限管理
     * Web组件根据接口响应结果，决定是否赋予前端页面权限
     */
    it('ManageLocPerms', 0, async (done: Function) => {
      console.info('uitest: ManageLocPerms begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ManageLocPerms'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text(resourceToString($r('app.string.use_is_permitted'))));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.type('button'));
      await button3.click();
      await driver.delayMs(1000);

      const dialog = JSON.stringify(getInspectorTree());
      expect(dialog).assertContain('Dialog');

      const button4 = await driver.findComponent(ON.text('ok'));
      await button4.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      console.info('uitest: ManageLocPerms end');
      done();
    });
    
    /*
     * 点击 DarkMode_one 按钮
     * 开启Web组件的隐私模式
     * 使用 darkMode 接口将页面深色模式配置为跟随系统
     */
    it('DarkMode_one', 0, async (done: Function) => {
      console.info('uitest: DarkMode_one begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('DarkMode_one'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let text1 = await web1.getText();
      expect(text1).assertContain('darkModePage.html');

      await driver.pressBack();
      console.info('uitest: DarkMode_one end');
      done();
    });
    
    /*
     * 点击 DarkMode_two 按钮
     * 开启Web组件的隐私模式
     * 通过 forceDarkAccess 接口可将前端页面强制配置深色模式
     */
    it('DarkMode_two', 0, async (done: Function) => {
      console.info('uitest: DarkMode_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('DarkMode_two'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let text1 = await web1.getText();
      expect(text1).assertContain('darkModePage.html');

      console.info('uitest: DarkMode_two end');
      done();
    });
  })
}