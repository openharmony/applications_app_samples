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
    
    /**
     * 打开应用，点击 LocCrossOriginResAccSol_one 按钮
     * 对本地资源进行拦截和相应的替换
     */
    it('LocCrossOriginResAccSol_one', 0, async (done: Function) => {
      console.info('uitest: LocCrossOriginResAccSol_one begin');
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

      const button1 = await driver.findComponent(ON.text('LocCrossOriginResAccSol_one'));
      await button1.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('index.html');

      await driver.pressBack();
      console.info('uitest: LocCrossOriginResAccSol_one end');
      done();
    });
    
    /**
     * 点击 LocCrossOriginResAccSol_two 按钮，跨域访问本地文件
     */
    it('LocCrossOriginResAccSol_two', 0, async (done: Function) => {
      console.info('uitest: LocCrossOriginResAccSol_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('LocCrossOriginResAccSol_two'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('button'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.type('button'));
      await button3.click();

      const web1 = await driver.findComponent(ON.type('Web'));
      let src = await web1.getText();
      expect(src).assertContain('');

      await driver.pressBack();
      console.info('uitest: LocCrossOriginResAccSol_two end');
      done();
    });
    
    /**
     * 点击 AddIntTrackPreventByPassList 按钮
     * 设置需要绕过智能防跟踪功能的域名列表
     */
    it('AddIntTrackPreventByPassList',0, async (done: Function) => {
      console.info('uitest: AddIntTrackPreventByPassList begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('AddIntTrackPreventByPassList'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: AddIntTrackPreventByPassList end');
      done();
    });
    
    /**
     * 点击 ClearIntTrackPreventByPassList 按钮
     * 清除通过 addIntelligentTrackingPreventionBypassingList 接口设置的所有域名
     */
    it('ClearIntTrackPreventByPassList',0, async (done: Function) => {
      console.info('uitest: ClearIntTrackPreventByPassList begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ClearIntTrackPreventByPassList'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: ClearIntTrackPreventByPassList end');
      done();
    });
    
    /**
     * 点击 EnableIntTrackPrevent 按钮
     * 使能或者关闭相应Web组件的智能防跟踪功能
     */
    it('EnableIntTrackPrevent',0, async (done: Function) => {
      console.info('uitest: EnableIntTrackPrevent begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('EnableIntTrackPrevent'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: EnableIntTrackPrevent end');
      done();
    });

    /**
     * 点击 IsIntTrackPreventEnabled 按钮
     * 判断当前Web组件是否开启了智能防跟踪功能
     */
    it('IsIntTrackPreventEnabled',0, async (done: Function) => {
      console.info('uitest: IsIntTrackPreventEnabled begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('IsIntTrackPreventEnabled'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: IsIntTrackPreventEnabled end');
      done();
    });

    /**
     * 点击 OnIntTrackPreventResult 按钮
     * 异步获取拦截的跟踪型网站的域名和访问的网站域名信息
     */
    it('OnIntTrackPreventResult',0, async (done: Function) => {
      console.info('uitest: OnIntTrackPreventResult begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('OnIntTrackPreventResult'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: OnIntTrackPreventResult end');
      done();
    });

    /**
     * 点击 RemoveIntTrackPreventByPassList 按钮
     * 移除通过 addIntelligentTrackingPreventionBypassingList 接口设置的部分域名列表
     */
    it('RemoveIntTrackPreventByPassList',0, async (done: Function) => {
      console.info('uitest: RemoveIntTrackPreventByPassList begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('RemoveIntTrackPreventByPassList'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: RemoveIntTrackPreventByPassList end');
      done();
    });

    /**
     * 点击 EnablingAdsBlocking 按钮
     * 设置自定义的easylist过滤规则并使能广告过滤特性
     */
    it('EnablingAdsBlocking',0, async (done: Function) => {
      console.info('uitest: EnablingAdsBlocking begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('EnablingAdsBlocking'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: EnablingAdsBlocking end');
      done();
    });

    /**
     * 点击 DisAdsBlockSpecDomPages_one 按钮
     * 关闭一些特定页面的广告过滤功能
     */
    it('DisAdsBlockSpecDomPages_one',0, async (done: Function) => {
      console.info('uitest: DisAdsBlockSpecDomPages_one begin');
      const driver = Driver.create();
      await driver.delayMs(5000);

      const button1 = await driver.findComponent(ON.text('DisAdsBlockSpecDomPages_one'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('Go'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('addAdsBlockDisallowedList'));
      await button3.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: DisAdsBlockSpecDomPages_one end');
      done();
    });

    /**
     * 点击 DisAdsBlockSpecDomPages_two 按钮
     * 使用 addAdsBlockDisallowedList 接口添加域名
     */
    it('DisAdsBlockSpecDomPages_two',0, async (done: Function) => {
      console.info('uitest: DisAdsBlockSpecDomPages_two begin');
      const driver = Driver.create();
      await driver.delayMs(5000);

      const button1 = await driver.findComponent(ON.text('DisAdsBlockSpecDomPages_two'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('Go'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('addAdsBlockAllowedList'));
      await button3.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      let src: string = await type.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: DisAdsBlockSpecDomPages_two end');
      done();
    });

    /**
     * 点击 CollectingAdsBlockingInformation 按钮
     * 触发发生了广告过滤后过滤信息的收集和统计
     */
    it('CollectingAdsBlockingInformation',0, async (done: Function) => {
      console.info('uitest: CollectingAdsBlockingInformation begin');
      const driver = Driver.create();
      await driver.delayMs(5000);

      const button1 = await driver.findComponent(ON.text('CollectingAdsBlockingInformation'));
      await button1.click();
      await driver.delayMs(1000);

      const type1 = await driver.findComponent(ON.type('Web'));
      let text: string = await type1.getText();
      expect(text).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: CollectingAdsBlockingInformation end');
      done();
    });
  })
}