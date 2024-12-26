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

import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Component, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_UserAuthentication]';
const DOMAIN = 0xF811;
const BUNDLE = 'UserAuthentication_';
const DELAY_TIME_500MS = 500;
const DELAY_TIME_1S = 1000;
const DELAY_TIME_5S = 5000;
const DELAY_TIME_10S = 10000;
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

export default function IndexTest() {
  describe('IndexTest', () => {
    /**
     * @tc.number IAM_StartAbility_001
     * @tc.name IAM_StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,begin');
      //start tested ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME_500MS);
      // check top display ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,end');
    })

    /**
     * @tc.number IAM_UiTest_001
     * @tc.name IAM_UiTest_001
     * @tc.desc 测试查询能力功能点
     */
    it(BUNDLE + 'UiTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_001,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('queryCapability'));
      await tabBar.click();
      let button: Component = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(DELAY_TIME_1S);
      let textComponent: Component = await driver.findComponent(ON.id('text0'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_001,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_001,end');
    })

    /**
     * @tc.number IAM_UiTest_002
     * @tc.name IAM_UiTest_002
     * @tc.desc 测试实例1功能点
     */
    it(BUNDLE + 'UiTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_002,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('exampleTab1'));
      await tabBar.click();
      await driver.delayMs(DELAY_TIME_500MS);
      let button: Component = await driver.findComponent(ON.type('Button').id('button1'));
      await button.click();
      await driver.delayMs(DELAY_TIME_10S);
      let textComponent: Component = await driver.findComponent(ON.id('text1'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_002,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_002,end');
    })

    /**
     * @tc.number IAM_UiTest_003
     * @tc.name IAM_UiTest_003
     * @tc.desc 测试实例2功能点
     */
    it(BUNDLE + 'UiTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,begin');
      let driver: Driver = Driver.create();
      let button: Component = await driver.findComponent(ON.type('Button').id('button2'));
      await button.click();
      await driver.delayMs(DELAY_TIME_10S);
      let textComponent: Component = await driver.findComponent(ON.id('text2'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,end');
    })

    /**
     * @tc.number IAM_UiTest_004
     * @tc.name IAM_UiTest_004
     * @tc.desc 测试实例3功能点
     */
    it(BUNDLE + 'UiTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('exampleTab2'));
      await tabBar.click();
      await driver.delayMs(DELAY_TIME_500MS);
      let button: Component = await driver.findComponent(ON.type('Button').id('button3'));
      await button.click();
      await driver.delayMs(DELAY_TIME_10S);
      let textComponent: Component = await driver.findComponent(ON.id('text3'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,end');
    })
    /**
     * @tc.number IAM_UiTest_005
     * @tc.name IAM_UiTest_005
     * @tc.desc 测试实例4功能点
     */
    it(BUNDLE + 'UiTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,begin');
      let driver: Driver = Driver.create();
      let button: Component = await driver.findComponent(ON.type('Button').id('button4'));
      await button.click();
      await driver.delayMs(DELAY_TIME_10S);
      let textComponent: Component = await driver.findComponent(ON.id('text4'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_003,end');
    })

    /**
     * @tc.number IAM_UiTest_006
     * @tc.name IAM_UiTest_006
     * @tc.desc 测试"自定义"功能点
     */
    it(BUNDLE + 'UiTest_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_004,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('exampleTab4'));
      await tabBar.click();
      await driver.delayMs(DELAY_TIME_500MS);
      let button: Component = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(DELAY_TIME_10S);
      let textComponent: Component = await driver.findComponent(ON.id('text6'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_004,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_004,end');
    })

    /**
     * @tc.number IAM_UiTest_007
     * @tc.name IAM_UiTest_007
     * @tc.desc 测试"取消实例"功能点
     */
    it(BUNDLE + 'UiTest_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_005,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('exampleTab3'));
      await tabBar.click();
      await driver.delayMs(DELAY_TIME_500MS);
      let button: Component = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(DELAY_TIME_5S);
      let textComponent: Component = await driver.findComponent(ON.id('text5'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_005,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_005,end');
    })

    /**
     * @tc.number IAM_UiTest_008
     * @tc.name IAM_UiTest_008
     * @tc.desc 测试查询凭据功能点
     */
    it(BUNDLE + 'UiTest_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_006,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('credentialQueries'));
      await tabBar.click();
      await driver.delayMs(DELAY_TIME_500MS);
      let button: Component = await driver.findComponent(ON.type('Button'));
      await button.click();
      await driver.delayMs(DELAY_TIME_1S);
      let textComponent: Component = await driver.findComponent(ON.id('text7'));
      let text = await textComponent.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_006,test:' + text);
      expect('Pass').assertEqual(text);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_006,end');
    })
    /**
     * @tc.number IAM_UiTest_009
     * @tc.name IAM_UiTest_009
     * @tc.desc 测试模拟验证按钮功能
     */
    it(BUNDLE + 'UiTest_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_007,begin');
      let driver: Driver = Driver.create();
      let tabBar: Component = await driver.findComponent(ON.id('simulationValidation'));
      await tabBar.click();
      await driver.delayMs(DELAY_TIME_500MS);
      let button1: Component = await driver.findComponent(ON.id('button1'));
      await button1.click();
      await driver.delayMs(DELAY_TIME_1S);
      let button2: Component = await driver.findComponent(ON.id('button2'));
      await button2.click();
      await driver.delayMs(DELAY_TIME_5S);
      let button3: Component = await driver.findComponent(ON.id('button3'));
      await button3.click();
      await driver.delayMs(DELAY_TIME_5S);
      let button4: Component = await driver.findComponent(ON.id('button4'));
      await button4.click();
      await driver.delayMs(DELAY_TIME_1S);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiTest_007,end');
    })
  })
}
